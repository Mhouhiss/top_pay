import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/profile_avatar.dart';

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
    int unreadNotifCount = 2;
    final displayName = user?.displayName;
    final photoUrl = user?.photoUrl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                child: UserAvatar(photoUrl: photoUrl),
                onTap: () {
                  context.push(AppRoutes.profile);
                },
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Good ${dayText(now)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName ?? 'User',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                size: 24,
                color: colorScheme.onSurface,
              ),
              onPressed: () {
                context.push(AppRoutes.notifications);
              },
            ),
            if (unreadNotifCount > 0)
              Positioned(
                top: AppSizes.xs,
                right: AppSizes.xs,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 16,
                    minWidth: 16,
                  ),
                  padding: const EdgeInsets.all(3),
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

  String dayText(DateTime time) {
    if (time.hour < 12) return 'morning';
    if (time.hour < 16) return 'afternoon';
    return 'evening';
  }
}
