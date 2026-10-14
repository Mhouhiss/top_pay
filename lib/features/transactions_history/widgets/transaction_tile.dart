import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/utils/formatters.dart';
import '../../transactions_history/model/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel item;
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _transactionIcon(item),
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
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
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
                Formatters.amount(item.amount, item.type),
                maxLines: 1,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Text(
                  item.statusLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(ColorScheme colorScheme) {
    switch (item.status) {
      case TransactionStatus.successful:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.reversed:
        return AppColors.info;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  IconData _transactionIcon(TransactionModel item) {
    switch (item.type.toLowerCase()) {
      case 'airtime':
        return Icons.phone_android_outlined;
      case 'data':
        return Icons.wifi_outlined;
      case 'cabletv':
        return Icons.live_tv_outlined;
      case 'electricity':
        return Icons.lightbulb_outline_rounded;
      case 'education':
        return Icons.school_outlined;
      case 'betting':
        return Icons.sports_soccer_outlined;
      case 'funding':
        return Icons.account_balance_wallet_outlined;
      case 'card':
        return Icons.credit_card_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }
}
