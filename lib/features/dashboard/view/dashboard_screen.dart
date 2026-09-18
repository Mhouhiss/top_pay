import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

import '../../dashboard/widgets/dashboard_header.dart';
import '../../dashboard/widgets/balance_card.dart';
import '../../dashboard/widgets/promo_banner.dart';
import '../../dashboard/widgets/recent_transactions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _onRefresh() async {
    // await ref.read()
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: const [
                DashboardHeader(),
                SizedBox(height: AppSizes.md),
                BalanceCard(),
                SizedBox(height: AppSizes.md),
                PromoBanner(),
                SizedBox(height: AppSizes.md),
                RecentTransactions(),
                SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
