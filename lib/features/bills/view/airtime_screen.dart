import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/utils/phone_utils.dart';
import 'package:top_pay/features/bills/widgets/phone_number_field.dart';
import 'package:top_pay/shared/components/custom_appbar.dart';
import '../../transactions/model/transaction_model.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/auth_validator.dart';
import '../model/airtime_purchase_model.dart';
import '../viewmodel/airtime_viewmodel.dart';
import '../widgets/wallet_balance_card.dart';
import '../../bills/view/confirmation_screen.dart';

class AirtimeScreen extends ConsumerStatefulWidget {
  const AirtimeScreen({super.key});

  @override
  ConsumerState<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends ConsumerState<AirtimeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();

  AirtimeNetwork _network = AirtimeNetwork.mtn;
  double? _selectedQuickAmount;

  static const _quickAmounts = <double>[100, 200, 500, 1000, 2000, 5000];

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _selectAmount(double amount) {
    setState(() {
      _selectedQuickAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _continue(AirtimeState state) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    final balance = state.walletBalance;
    if (balance == null) return;

    final phone = PhoneUtils.normalisePhone(_phoneController.text);
    final amount = double.parse(_amountController.text.trim());

    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient wallet balance.')),
      );
      return;
    }

    final request = AirtimePurchaseRequest(
      network: _network,
      phoneNumber: phone,
      amount: amount,
    );
    ref.read(airtimeViewModelProvider.notifier).setRequest(request);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServiceConfirmationScreen(
          serviceName: 'Airtime',
          provider: request.network.label,
          providerIcon: _getLogo(request.network.label),
          recipientLabel: 'Phone number',
          recipient: request.phoneNumber,
          amount: request.amount,
          transactionDetailRoute: AppRoutes.transactionDetail,
          onSubmit: (pin) async {
            final result = await ref
                .read(airtimeViewModelProvider.notifier)
                .purchase(pin);

            return TransactionModel(
              id: result.reference,
              description: '${request.network.label} airtime purchase',
              amount: request.amount,
              createdAt: result.createdAt,
              status: result.successful
                  ? TransactionStatus.successful
                  : TransactionStatus.failed,
              type: 'airtime',
              reference: result.reference,
              phoneNumber: request.phoneNumber,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(airtimeViewModelProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Buy Airtime'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              WalletBalanceCard(
                balance: state.walletBalance,
                isLoading: state.isLoadingBalance,
                error: state.balanceError,
                onRefresh: () {
                  ref
                      .read(airtimeViewModelProvider.notifier)
                      .loadWalletBalance();
                },
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Mobile number', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSizes.sm),
              PhoneNumberField(
                network: _network,
                onNetworkChanged: (value) {
                  setState(() => _network = value);
                },
                controller: _phoneController,
                validator: Validators.phoneNumber,
              ),
              const SizedBox(height: AppSizes.xl),
              Text('Amount', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSizes.sm),
              Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                children: _quickAmounts.map((amount) {
                  final selected = _selectedQuickAmount == amount;
                  return ChoiceChip(
                    label: Text(Formatters.amount(amount)),
                    selected: selected,
                    onSelected: (_) => _selectAmount(amount),
                    selectedColor: AppColors.secondary.withValues(alpha: 0.16),
                    side: BorderSide(
                      color: selected
                          ? AppColors.secondary
                          : colors.outlineVariant,
                    ),
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: selected ? AppColors.secondary : colors.onSurface,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixText: '₦ ',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                onChanged: (_) => setState(() => _selectedQuickAmount = null),
                validator: (value) {
                  final amount = double.tryParse((value ?? '').trim());
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  if (amount < 50) return 'Minimum airtime amount is ₦50';
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                height: AppSizes.lgButtonHeight,
                child: FilledButton(
                  onPressed:
                      state.isLoadingBalance ||
                          state.balanceError != null ||
                          state.walletBalance == null
                      ? null
                      : () => _continue(state),
                  child: const Text('Continue'),
                ),
              ),
              if (state.balanceError != null) ...[
                const SizedBox(height: AppSizes.sm),
                Text(
                  state.balanceError!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.error,
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.sm),
              Text(
                'Confirm the network and phone number before continuing.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLogo(String provider) {
    switch (provider.toLowerCase().trim()) {
      case 'mtn':
        return AppAssets.mtn;
      case 'airtel':
        return AppAssets.airtel;
      case 'glo':
        return AppAssets.glo;
      case '9mobile':
        return AppAssets.nineMobile;
      default:
        return AppAssets.airtime;
    }
  }
}
