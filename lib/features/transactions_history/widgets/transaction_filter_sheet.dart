import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

class TransactionFilterSheet extends StatefulWidget {
  const TransactionFilterSheet({super.key, required this.selectedType});

  final String selectedType;

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late String _selectedType;

  static const List<({String label, String value})> _types = [
    (label: 'All transactions', value: 'all'),
    (label: 'Airtime', value: 'airtime'),
    (label: 'Data', value: 'data'),
    (label: 'Cable TV', value: 'cabletv'),
    (label: 'Electricity', value: 'electricity'),
    (label: 'Education', value: 'education'),
    (label: 'Betting', value: 'betting'),
    (label: 'Wallet funding', value: 'funding'),
    (label: 'Cards', value: 'card'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          AppSizes.md,
          AppSizes.md,
          AppSizes.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter transactions',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Transaction type',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in _types)
                  ChoiceChip(
                    label: Text(type.label),
                    selected: _selectedType == type.value,
                    onSelected: (_) {
                      setState(() {
                        _selectedType = type.value;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedType = 'all';
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedType);
                    },
                    child: const Text('Apply filter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
