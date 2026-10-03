import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/utils/formatters.dart';
import '../../transactions/model/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem item;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final statusColor = _statusColor(colorScheme);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                item.icon,
                size: AppSizes.iconMd,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    item.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    Formatters.dateTime(item.createdAt),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.amount(item.amount),
                  maxLines: 1,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  _statusLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(ColorScheme colorScheme) {
    switch (item.status) {
      case TransactionStatus.successful:
        return colorScheme.primary;
      case TransactionStatus.pending:
        return colorScheme.secondary;
      case TransactionStatus.failed:
        return colorScheme.error;
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case TransactionStatus.successful:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}
