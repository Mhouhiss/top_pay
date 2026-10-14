import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/shared/components/custom_appbar.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import 'package:top_pay/shared/components/custom_textfield.dart';
import 'package:top_pay/shared/components/shimmer.dart';

import '../model/transaction_model.dart';
import '../viewmodel/transactions_viewmodel.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  String _selectedType = 'all';

  static const Map<String, String> _typeLabels = {
    'airtime': 'Airtime',
    'data': 'Data',
    'cabletv': 'Cable TV',
    'electricity': 'Electricity',
    'education': 'Education',
    'betting': 'Betting',
    'funding': 'Wallet Funding',
    'card': 'Card',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionHistoryViewModelProvider.notifier).loadTransactions();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = value.trim().toLowerCase();
      });
    });
  }

  Future<void> _openFilterSheet() async {
    final selectedType = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => TransactionFilterSheet(selectedType: _selectedType),
    );
    if (!mounted || selectedType == null) return;
    setState(() {
      _selectedType = selectedType;
    });
  }

  void _clearTypeFilter() {
    setState(() {
      _selectedType = 'all';
    });
  }

  Future<void> _refreshTransactions() async {
    await ref
        .read(transactionHistoryViewModelProvider.notifier)
        .refreshTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionHistoryViewModelProvider);
    final transactions = ref
        .read(transactionHistoryViewModelProvider.notifier)
        .filterTransactions(type: _selectedType, search: _searchQuery);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Transaction History', showBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              AppSizes.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    hint: 'Search transactions',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _debounce?.cancel();
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                IconButton(
                  onPressed: _openFilterSheet,
                  tooltip: 'Filter transactions',
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    foregroundColor: colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  icon: Icon(Icons.tune),
                ),
              ],
            ),
          ),
          if (_selectedType != 'all')
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                0,
                AppSizes.md,
                AppSizes.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  label: Text(
                    _typeLabels[_selectedType.toLowerCase()] ?? _selectedType,
                  ),
                  onDeleted: _clearTypeFilter,
                  deleteIcon: const Icon(Icons.close, size: 18),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          Expanded(
            child: _buildTransactionContent(
              transactions: transactions,
              isLoading: state.isLoading,
              errorMessage: state.errorMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionContent({
    required List<TransactionModel> transactions,
    required bool isLoading,
    required String? errorMessage,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading && transactions.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: TransactionListShimmer(itemCount: 10),
      );
    }

    if (errorMessage != null && transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: AppSizes.iconLg,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              CustomButton.outline(
                label: 'Try again',
                onPressed: () {
                  ref
                      .read(transactionHistoryViewModelProvider.notifier)
                      .loadTransactions();
                },
              ),
            ],
          ),
        ),
      );
    }

    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: AppSizes.iconLg,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'No transactions found',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshTransactions,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: TransactionTile(
              item: transactions[index],
              onTap: () {
                context.push(AppRoutes.transactionDetail);
              },
            ),
          );
        },
      ),
    );
  }
}
