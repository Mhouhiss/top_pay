import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/utils/formatters.dart';
import '../../transactions/model/transaction_model.dart';
import '../widgets/transaction_pin_bottom_sheet.dart';

class ServiceConfirmationScreen extends StatelessWidget {
  const ServiceConfirmationScreen({
    super.key,
    required this.serviceName,
    required this.provider,
    required this.providerIcon,
    required this.recipientLabel,
    required this.recipient,
    required this.amount,
    required this.transactionDetailRoute,
    required this.onSubmit,
    this.description,
    this.fee = 0,
  });

  final String serviceName;
  final String provider;
  final String providerIcon;
  final String recipientLabel;
  final String recipient;
  final double amount;
  final double fee;
  final String? description;
  final String transactionDetailRoute;
  final Future<TransactionModel> Function(String pin) onSubmit;

  double get _total => amount + fee;

  Future<void> _continueToPin(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final transaction = await TransactionPinBottomSheet.show(
      context: context,
      amount: _total,
      onSubmit: onSubmit,
    );

    if (!context.mounted || transaction == null) return;

    // Remove the confirmation screen so Back from transaction details does
    // not return the user to a completed purchase confirmation.
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.push(transactionDetailRoute, extra: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Confirm $serviceName')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.lg),
              Image.asset(
                providerIcon,
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                'Review your purchase',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total to pay',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      Formatters.amount(_total),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              _DetailRow(label: 'Service', value: serviceName),
              _DetailRow(label: 'Provider', value: provider),
              _DetailRow(label: recipientLabel, value: recipient),
              if (description != null && description!.trim().isNotEmpty)
                _DetailRow(label: 'Plan / Description', value: description!),
              _DetailRow(label: 'Amount', value: Formatters.amount(amount)),
              _DetailRow(
                label: 'Transaction fee',
                value: Formatters.amount(fee),
              ),
              const Divider(height: AppSizes.xl),
              _DetailRow(
                label: 'Total',
                value: Formatters.amount(_total),
                isTotal: true,
              ),
              const Spacer(),
              SizedBox(
                height: AppSizes.lgButtonHeight,
                child: FilledButton(
                  onPressed: () => _continueToPin(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  child: const Text('Continue to PIN'),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Edit details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isTotal ? colors.onSurface : colors.onSurfaceVariant,
                fontWeight: isTotal ? FontWeight.w700 : null,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
