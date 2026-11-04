import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import '../model/notification_model.dart';
import '../viewmodel/notification_viewmodel.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationViewModelProvider);
    final vm = ref.read(notificationViewModelProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: vm.markAllAsRead,
              child: const Text('Read all'),
            ),
        ],
      ),
      body: _body(
        context,
        state,
        () => vm.loadNotifications(refresh: true),
        (item) => vm.markAsRead(item.id),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    NotificationState state,
    Future<void> Function() refresh,
    ValueChanged<AppNotification> onTap,
  ) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.notifications.isEmpty) {
      return _StatusView(
        icon: Icons.notifications_off_outlined,
        title: 'Couldn’t load notifications',
        message: state.errorMessage!,
        buttonText: 'Try again',
        onPressed: () => refresh(),
      );
    }
    if (state.notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [SizedBox(height: 120), _EmptyNotifications()],
        ),
      );
    }

    final groups = _group(state.notifications);
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          if (state.isRefreshing) const LinearProgressIndicator(minHeight: 2),
          for (final entry in groups.entries) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: AppSizes.md,
                bottom: AppSizes.sm,
              ),
              child: Text(
                entry.key,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            ...entry.value.map(
              (item) => _NotificationTile(
                notification: item,
                onTap: () => onTap(item),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, List<AppNotification>> _group(List<AppNotification> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final result = <String, List<AppNotification>>{};
    for (final item in items) {
      final d = item.createdAt;
      final day = DateTime(d.year, d.month, d.day);
      final label = day == today
          ? 'Today'
          : day == yesterday
          ? 'Yesterday'
          : 'Earlier';
      result.putIfAbsent(label, () => []).add(item);
    }
    for (final list in result.values) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return result;
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final iconColor = _iconColor(notification.type, colors);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Material(
        color: notification.isRead
            ? colors.surfaceContainerLowest
            : colors.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    _icon(notification.type),
                    color: iconColor,
                    size: AppSizes.iconMd,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: AppSizes.sm),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        notification.message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        _formatDate(notification.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _icon(AppNotificationType type) => switch (type) {
    AppNotificationType.transaction => Icons.receipt_long_outlined,
    AppNotificationType.security => Icons.shield_outlined,
    AppNotificationType.account => Icons.person_outline,
    AppNotificationType.promotion => Icons.local_offer_outlined,
    AppNotificationType.general => Icons.notifications_none_outlined,
  };

  Color _iconColor(AppNotificationType type, ColorScheme colors) =>
      switch (type) {
        AppNotificationType.transaction => colors.primary,
        AppNotificationType.security => colors.error,
        AppNotificationType.account => AppColors.primaryLight,
        AppNotificationType.promotion => AppColors.secondary,
        AppNotificationType.general => colors.onSurfaceVariant,
      };

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute ${date.hour >= 12 ? 'PM' : 'AM'}';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 56,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'You’re all caught up',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'New notifications will appear here.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const _StatusView({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: colors.onSurfaceVariant),
            const SizedBox(height: AppSizes.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            FilledButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
