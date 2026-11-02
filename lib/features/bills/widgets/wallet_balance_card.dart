import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';

class WalletBalanceCard extends StatelessWidget {
  final double? balance;
  final bool isLoading;
  final String? error;
  final VoidCallback onRefresh;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.isLoading,
    required this.error,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: colorScheme.primary,
            size: AppSizes.iconMd,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wallet balance', style: textTheme.bodyMedium),
                const SizedBox(height: AppSizes.xs),
                if (isLoading)
                  const SizedBox(
                    height: AppSizes.iconSm,
                    width: AppSizes.iconSm,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (error != null)
                  TextButton(onPressed: onRefresh, child: const Text('Retry'))
                else
                  Text(
                    Formatters.amount(balance ?? 0),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Refresh balance',
            onPressed: isLoading ? null : onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
