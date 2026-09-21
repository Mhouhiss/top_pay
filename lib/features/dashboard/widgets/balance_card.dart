import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/shared/components/custom_button.dart';

class BalanceCard extends StatefulWidget {
  final double balance;
  final double bonus;

  const BalanceCard({super.key, this.balance = 20000.437, this.bonus = 300});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: AppColors.primaryGradient,
      ),
      child: Stack(
        children: [
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Wallet Balance',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      icon: Icon(
                        _isBalanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  _isBalanceVisible ? '₦ ${widget.balance}' : '₦ ******',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: colorScheme.surface.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          'Bonus: ₦ ${widget.bonus}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.surface.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      label: 'Fund Wallet',
                      leadingIcon: Icons.add,
                      fullWidth: false,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
