import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Text('Recent Transactions'),
              const Spacer(),
              GestureDetector(child: Text('See all')),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          ListTile(),
        ],
      ),
    );
  }
}
