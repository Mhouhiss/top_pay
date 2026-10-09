import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/features/transactions_history/widgets/transaction_tile.dart';
import 'package:top_pay/shared/components/shimmer.dart';
import 'package:top_pay/features/transactions_history/viewmodel/transactions_viewmodel.dart';

class RecentTransactions extends ConsumerStatefulWidget {
  const RecentTransactions({super.key});

  @override
  ConsumerState<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends ConsumerState<RecentTransactions> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final state = ref.watch(transactionHistoryViewModelProvider);
    final items = ref.watch(recentTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Transactions',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (items.isNotEmpty)
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.transactions);
                },
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        if (state.isLoading && items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.md,
            ),
            child: TransactionListShimmer(itemCount: 3),
          )
        else if (items.isEmpty)
          _EmptyView()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : AppSizes.sm,
                ),
                child: TransactionTile(item: item),
              );
            },
          ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: AppSizes.iconLg,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'No recent transactions_history',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
