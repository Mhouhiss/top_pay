import 'package:flutter/material.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Welcome to TopPay App...'),
            const SizedBox(height: AppSizes.md),
            Text('App is still under construction'),
          ],
        ),
      ),
    );
  }
}
