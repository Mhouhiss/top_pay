import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/utils/auth_validator.dart';
import 'package:top_pay/features/bills/widgets/phone_number_field.dart';
import 'package:top_pay/features/bills/widgets/wallet_balance_card.dart';
import '../../transactions/model/transaction_model.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../bills/model/airtime_purchase_model.dart';
import '../../bills/widgets/network_selector.dart';
import '../../bills/widgets/contact_picker_button.dart';
import '../model/data_bundle_model.dart';
import '../viewmodel/data_viewmodel.dart';
import '../../bills/view/confirmation_screen.dart';

class DataScreen extends ConsumerStatefulWidget {
  const DataScreen({super.key});

  @override
  ConsumerState<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends ConsumerState<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  String _network = 'mtn';
  DataBundleModel? _selectedBundle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(dataViewModelProvider.notifier).loadBundles(_network);
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // String _normalisePhone(String input) {
  //   var phone = input.replaceAll(RegExp(r'[\s\-()]'), '');
  //   if (phone.startsWith('+234')) phone = '0${phone.substring(4)}';
  //   if (phone.startsWith('234')) phone = '0${phone.substring(3)}';
  //   return phone;
  // }

  void _changeNetwork(AirtimeNetwork network) {
    setState(() {
      _network = network;
      _selectedBundle = null;
    });
    ref.read(dataViewModelProvider.notifier).loadBundles(network);
  }

  void _continue(DataState state) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final bundle = _selectedBundle;
    if (bundle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a data bundle to continue.')),
      );
      return;
    }

    final balance = state.walletBalance;
    if (balance == null) return;
    if (bundle.price > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient wallet balance.')),
      );
      return;
    }

    final request = DataPurchaseRequest(
      network: _network,
      phoneNumber: _normalisePhone(_phoneController.text),
      bundle: bundle,
    );
    ref.read(dataViewModelProvider.notifier).setRequest(request);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ServiceConfirmationScreen(
          serviceName: 'Data',
          provider: request.network.label,
          recipientLabel: 'Phone number',
          recipient: request.phoneNumber,
          amount: request.bundle.price,
          description: '${request.bundle.name} - ${request.bundle.validity}',
          transactionDetailRoute: AppRoutes.transactionDetail,
          onSubmit: (pin) async {
            final result = await ref
                .read(dataViewModelProvider.notifier)
                .purchase(pin);

            return TransactionModel(
              id: result.reference,
              description:
                  '${request.network.label} ${request.bundle.name} data purchase',
              amount: request.bundle.price,
              createdAt: result.createdAt,
              status: result.successful
                  ? TransactionStatus.successful
                  : TransactionStatus.failed,
              type: 'data',
              reference: result.reference,
              phoneNumber: request.phoneNumber,
              bundleCode: request.bundle.id,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dataViewModelProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buy Data')),
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
                  ref.read(dataViewModelProvider.notifier).loadWalletBalance();
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choose a data bundle',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (state.isLoadingBundles)
                    const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              if (state.bundlesError != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.bundlesError!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.error,
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(dataViewModelProvider.notifier)
                          .loadBundles(_network),
                      child: const Text('Try again'),
                    ),
                  ],
                )
              else if (state.isLoadingBundles)
                const Padding(
                  padding: EdgeInsets.all(AppSizes.lg),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.bundles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.sm,
                    mainAxisSpacing: AppSizes.sm,
                    childAspectRatio: 1.55,
                  ),
                  itemBuilder: (context, index) {
                    final bundle = state.bundles[index];
                    final selected = _selectedBundle?.id == bundle.id;
                    return InkWell(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      onTap: () => setState(() => _selectedBundle = bundle),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.secondary.withValues(alpha: 0.10)
                              : colors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          border: Border.all(
                            color: selected
                                ? AppColors.secondary
                                : colors.outlineVariant,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bundle.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              bundle.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              Formatters.amount(bundle.price),
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: selected
                                    ? AppColors.secondary
                                    : colors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              bundle.validity,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                height: AppSizes.lgButtonHeight,
                child: FilledButton(
                  onPressed:
                      state.isLoadingBalance ||
                          state.balanceError != null ||
                          state.walletBalance == null ||
                          state.isLoadingBundles ||
                          state.bundles.isEmpty
                      ? null
                      : () => _continue(state),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Check the recipient number, network, bundle and validity before continuing.',
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
}
