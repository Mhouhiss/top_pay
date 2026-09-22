import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/profile_avatar.dart';
import 'package:top_pay/core/utils/formatters.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();
    int unreadNotifCount = 10;
    final displayName = user?.displayName;
    final photoUrl = user?.photoUrl;

    return Row(
      children: [
        GestureDetector(
          child: ProfileAvatar(photoUrl: photoUrl),
          onTap: () {
            context.push(AppRoutes.profile);
          },
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Good ${Formatters.dayText(now)}, ',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextSpan(
                  text: displayName ?? 'Top Payer',
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Stack(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.notifications_outlined,
                size: 24,
                color: colorScheme.onSurface,
              ),
              onPressed: () {
                context.push(AppRoutes.notifications);
              },
            ),
            if (unreadNotifCount > 0)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 16,
                    minWidth: 16,
                  ),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadNotifCount > 9 ? '9+' : '$unreadNotifCount',
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
