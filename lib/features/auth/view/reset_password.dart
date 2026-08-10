import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/shared/components/custom_textfield.dart';
import 'package:top_pay/core/utils/auth_validator.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  static const double _headerHeightFraction = 0.30;
  static const double _headerMinHeight = 200;
  static const double _headerMaxHeight = 300;
  static const double _cardOverlap = 28;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authViewModelProvider).isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .resetPassword(
            password: _passwordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
          );

      if (!mounted) return;
      context.go(AppRoutes.login);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final mediaQuery = MediaQuery.of(context);

    final headerHeight = (mediaQuery.size.height * _headerHeightFraction).clamp(
      _headerMinHeight,
      _headerMaxHeight,
    );
    final cardTop = headerHeight - _cardOverlap;
    final canPop = context.canPop();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: headerHeight,
              child: Container(
                color: colorScheme.primary,
                child: SafeArea(
                  bottom: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_reset_outlined,
                          size: AppSizes.xxl,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'Reset Password',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: cardTop,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.xl),
                    topRight: Radius.circular(AppSizes.xl),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Focus.of(context).unfocus(),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.xl,
                        AppSizes.lg,
                        AppSizes.xl,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Your new password must be different from previously used password.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSizes.xl),

                            CustomTextField(
                              label: 'New Password',
                              hint: 'Enter your new password',
                              prefixIcon: Icon(Icons.lock_outlined),
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              enabled: !authState.isLoading,
                              textInputAction: TextInputAction.next,
                              validator: Validators.password,
                              obscureText: true,
                            ),
                            const SizedBox(height: AppSizes.lg),

                            CustomTextField(
                              label: 'Confirm Password',
                              hint: 'Re-enter your password',
                              prefixIcon: Icon(Icons.lock_outlined),
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocusNode,
                              enabled: !authState.isLoading,
                              textInputAction: TextInputAction.done,
                              validator: (value) => Validators.confirmPassword(
                                value,
                                _passwordController.text,
                              ),
                              obscureText: true,
                            ),

                            if (authState.errorMessage != null) ...[
                              const SizedBox(height: AppSizes.sm),
                              Container(
                                padding: const EdgeInsets.all(AppSizes.sm),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusSm,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: AppSizes.iconSm,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(width: AppSizes.sm),
                                    Expanded(
                                      child: Text(
                                        authState.errorMessage!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            const SizedBox(height: AppSizes.xl),
                            CustomButton(
                              label: 'Reset Password',
                              isLoading: authState.isLoading,
                              onPressed: authState.isLoading ? null : _submit,
                            ),

                            const SizedBox(height: AppSizes.xl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (canPop)
              Positioned(
                top: mediaQuery.padding.top + AppSizes.xs,
                left: AppSizes.xs,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
