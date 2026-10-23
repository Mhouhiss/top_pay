import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/utils/formatters.dart';
import 'package:top_pay/shared/components/custom_appbar.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import '../../transactions_history/model/transaction_model.dart';
import '../../transactions_history/widgets/default_transaction_icon.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _statusColor(colorScheme);

    return Scaffold(
      appBar: CustomAppBar(title: 'Transaction Details', centerTitle: true),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.sm,
                  AppSizes.md,
                  AppSizes.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSizes.sm),
                    _buildTransactionSummary(context, statusColor),
                    const SizedBox(height: AppSizes.lg),
                    _buildPaymentDetails(context),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                AppSizes.md,
              ),
              child: CustomButton(
                label: 'Share Receipt',
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSummary(BuildContext context, Color statusColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child:
              transaction.provider != null &&
                  transaction.provider!.trim().isNotEmpty
              ? Image.asset(
                  transaction.providerIcon,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  transactionIcon(transaction),
                  width: 28,
                  height: 28,
                  color: colorScheme.onSurfaceVariant,
                  fit: BoxFit.contain,
                ),
        ),

        const SizedBox(height: AppSizes.md),

        Text(
          Formatters.amount(transaction.amount),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSizes.sm),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                transaction.status == TransactionStatus.successful
                    ? Icons.check_circle_rounded
                    : transaction.status == TransactionStatus.pending
                    ? Icons.pending_rounded
                    : Icons.cancel_rounded,
                size: AppSizes.md,
                color: statusColor,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                transaction.statusLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSizes.md),

        Text(
          transaction.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Payment details card.
  Widget _buildPaymentDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              _buildPaymentDetail(
                context,
                label: 'Reference No',
                value: transaction.reference,
                showCopy: true,
              ),

              const SizedBox(height: AppSizes.md),

              _buildPaymentDetail(
                context,
                label: 'Transaction type',
                value: _transactionType,
              ),
              const SizedBox(height: AppSizes.md),

              if (_hasProvider) ...[
                _buildPaymentDetail(
                  context,
                  label: 'Service Provider',
                  value: transaction.provider!.toUpperCase(),
                ),
                const SizedBox(height: AppSizes.md),
              ],

              if (_hasPhoneNumber) ...[
                _buildPaymentDetail(
                  context,
                  label: 'Phone Number',
                  value: transaction.phoneNumber!,
                ),
                const SizedBox(height: AppSizes.md),
              ],

              _buildPaymentDetail(
                context,
                label: 'Date and Time',
                value: Formatters.dateTime(transaction.createdAt),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Single payment detail widget
  Widget _buildPaymentDetail(
    BuildContext context, {
    required String label,
    required String value,
    bool showCopy = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
          ),
        ),

        const SizedBox(height: AppSizes.xs),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SelectableText(
                value,
                maxLines: 1,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (showCopy) ...[
              const SizedBox(width: AppSizes.xs),
              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  onPressed: () => _copyReference(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.copy_rounded),
                  iconSize: AppSizes.iconSm,
                  color: colorScheme.onSurfaceVariant,
                  tooltip: 'Copy Reference No',
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // Helpers
  bool get _hasProvider =>
      transaction.provider != null && transaction.provider!.trim().isNotEmpty;

  bool get _hasPhoneNumber =>
      transaction.phoneNumber != null &&
      transaction.phoneNumber!.trim().isNotEmpty;

  Future<void> _copyReference() async {
    await Clipboard.setData(ClipboardData(text: transaction.reference));
  }

  String get _transactionType {
    switch (transaction.type.toLowerCase().trim()) {
      case 'airtime':
        return 'Airtime purchase';
      case 'data':
        return 'Data purchase';
      case 'cabletv':
        return 'Cable TV subscription';
      case 'electricity':
        return 'Electricity bill';
      case 'education':
        return 'Education payment';
      case 'betting':
        return 'Betting wallet funding';
      case 'funding':
        return 'Wallet funding';
      case 'card':
        return 'Card transaction';
      default:
        return transaction.type;
    }
  }

  Color _statusColor(ColorScheme colorScheme) {
    switch (transaction.status) {
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
}
