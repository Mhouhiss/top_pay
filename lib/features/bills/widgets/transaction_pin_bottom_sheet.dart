import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import '../../transactions/model/transaction_model.dart';

/// Reusable transaction PIN modal used by Airtime, Data, and other services.
/// The callback must submit the PIN to the backend and return the transaction
/// created/confirmed by the backend.
class TransactionPinBottomSheet extends StatefulWidget {
  const TransactionPinBottomSheet({
    super.key,
    required this.onSubmit,
    required this.amount,
  });

  final double amount;
  final Future<TransactionModel> Function(String pin) onSubmit;

  static Future<TransactionModel?> show({
    required BuildContext context,
    required double amount,
    required Future<TransactionModel> Function(String pin) onSubmit,
  }) {
    return showModalBottomSheet<TransactionModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) =>
          TransactionPinBottomSheet(amount: amount, onSubmit: onSubmit),
    );
  }

  @override
  State<TransactionPinBottomSheet> createState() =>
      _TransactionPinBottomSheetState();
}

class _TransactionPinBottomSheetState extends State<TransactionPinBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePin = true;
  String? _errorMessage;

  String _formatAmount(double amount) {
    final raw = amount.toStringAsFixed(2).split('.');
    final whole = raw.first.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
    return '₦$whole.${raw.last}';
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final transaction = await widget.onSubmit(_pinController.text.trim());
      if (!mounted) return;
      // Return the transaction to the confirmation screen. That screen
      // performs navigation after the modal has closed.
      Navigator.of(context).pop(transaction);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Unable to process the transaction. Check your details and try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXl),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            AppSizes.md,
            AppSizes.lg,
            AppSizes.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        'Transaction PIN',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Enter your 6-digit PIN to authorize ${_formatAmount(widget.amount)}.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                TextFormField(
                  controller: _pinController,
                  obscureText: _obscurePin,
                  autofocus: true,
                  enabled: !_isSubmitting,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    letterSpacing: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    labelText: '6-digit transaction PIN',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    suffixIcon: IconButton(
                      tooltip: _obscurePin ? 'Show PIN' : 'Hide PIN',
                      onPressed: () => setState(() {
                        _obscurePin = !_obscurePin;
                      }),
                      icon: Icon(
                        _obscurePin
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !RegExp(r'^\d{6}$').hasMatch(value)) {
                      return 'Enter your 6-digit transaction PIN.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_isSubmitting) _submit();
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSizes.md),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.lg),
                SizedBox(
                  height: AppSizes.lgButtonHeight,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Confirm & Pay'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
