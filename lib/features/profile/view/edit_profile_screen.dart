import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/viewmodel/auth_viewmodel.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  String _initialName = '';

  bool get _hasChanges => _nameController.text.trim() != _initialName;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authViewModelProvider).user;
    _initialName = user?.displayName ?? '';

    _nameController = TextEditingController(text: _initialName);
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_onNameChanged)
      ..dispose();

    super.dispose();
  }

  Future<bool> _confirmDiscard() async {
    if (!_hasChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Keep Editing'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    return shouldDiscard ?? false;
  }

  Future<void> _handleBack() async {
    final shouldLeave = await _confirmDiscard();

    if (!mounted || !shouldLeave) return;

    context.pop();
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    if (!_hasChanges) {
      context.pop();
      return;
    }

    final success = await ref
        .read(authViewModelProvider.notifier)
        .updateProfile(displayName: _nameController.text.trim());

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );

      context.pop();
    } else {
      final error = ref.read(authViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ?? 'Unable to update your profile. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;

    return PopScope(
      canPop: !_hasChanges && !authState.isLoading,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (authState.isLoading) return;

        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          leading: IconButton(
            onPressed: authState.isLoading ? null : _handleBack,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_outline,
                      size: 44,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'Update your personal information',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text('Full Name', style: theme.textTheme.labelLarge),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,
                  enabled: !authState.isLoading,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!authState.isLoading) {
                      _saveProfile();
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    final name = value?.trim() ?? '';

                    if (name.isEmpty) {
                      return 'Please enter your full name.';
                    }

                    if (name.length < 2) {
                      return 'Name must contain at least 2 characters.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                Text('Email Address', style: theme.textTheme.labelLarge),

                const SizedBox(height: 8),

                TextFormField(
                  initialValue: user?.email ?? '',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    helperText: 'Email changes are not available yet.',
                  ),
                ),

                const SizedBox(height: 24),

                Text('Phone Number', style: theme.textTheme.labelLarge),

                const SizedBox(height: 8),

                TextFormField(
                  initialValue: user?.phoneNumber ?? '',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_outlined),
                    helperText: 'Phone number changes are not available yet.',
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: authState.isLoading || !_hasChanges
                        ? null
                        : _saveProfile,
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
