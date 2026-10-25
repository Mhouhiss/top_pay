import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/providers/theme_provider.dart';

import 'package:top_pay/shared/components/custom_appbar.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import '../../../core/router/router.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'Are you sure you want to log out of your TopPay account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) return;

    final success = await ref.read(authViewModelProvider.notifier).logout();

    if (!context.mounted) return;

    if (success) {
      context.go(AppRoutes.login);
    } else {
      final error = ref.read(authViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Unable to log out. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', centerTitle: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            const SizedBox(height: AppSizes.md),
            Center(
              child: CircleAvatar(
                radius: 46,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: Image.asset(
                  AppAssets.profile,
                  width: 46,
                  height: 46,
                  color: colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.md),

            Center(
              child: Text(
                user?.displayName?.isNotEmpty == true
                    ? user!.displayName!
                    : 'TopPayer',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            Center(
              child: Text(
                user?.email ?? 'No email available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            CustomButton(
              label: 'Edit Profile',
              leadingIcon: Icons.edit_outlined,
              onPressed: () {
                context.push(AppRoutes.editProfile);
              },
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),

            const SizedBox(height: AppSizes.xl),

            _SectionTitle(title: 'ACCOUNT'),

            _ProfileTile(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Manage your name and contact details',
              onTap: () {
                // Navigate to the Personal Information screen
              },
            ),

            _ProfileTile(
              icon: Icons.verified_user_outlined,
              title: 'Email Verification',
              subtitle: user?.emailVerified == true
                  ? 'Your email is verified'
                  : 'Your email is not verified',
              trailing: Icon(
                user?.emailVerified == true
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
                color: user?.emailVerified == true
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              onTap: user?.emailVerified == true ? null : () {},
            ),

            _ProfileTile(
              icon: Icons.lock_outlined,
              title: 'Change Transaction PIN',
              subtitle: 'Set or change your transaction PIN',
              onTap: () {
                // Navigate to transaction PIN screen.
              },
            ),
            const SizedBox(height: AppSizes.lg),

            _SectionTitle(title: 'PREFERENCES & SUPPORT'),

            _ThemeModeTile(
              isDarkMode: isDarkMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).toggleDarkMode(value);
              },
            ),

            _ProfileTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage your notifications',
              onTap: () {
                context.push(AppRoutes.notifications);
              },
            ),

            _ProfileTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with your account',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help & Support is coming soon.'),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSizes.lg),

            _ProfileTile(
              icon: Icons.logout,
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              iconColor: colorScheme.error,
              titleColor: colorScheme.error,
              onTap: () => _logout(context, ref),
            ),

            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Text(
        title,
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const _ThemeModeTile({required this.isDarkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(
        isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
      ),
      title: const Text('Dark Mode'),
      subtitle: const Text('Switch your app appearance'),
      trailing: Switch.adaptive(
        value: isDarkMode,
        onChanged: onChanged,
        activeTrackColor: colorScheme.primary,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? colorScheme.primary,
          size: AppSizes.iconSm,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: titleColor ?? colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
            size: AppSizes.iconSm,
          ),
      onTap: onTap,
    );
  }
}
