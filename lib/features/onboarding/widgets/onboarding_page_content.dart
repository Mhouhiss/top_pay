import 'package:flutter/material.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import '../../onboarding/model/onboarding_model.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingModel page;

  const OnboardingPageContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSizes.xxl),
          Image.asset(page.imagePath, fit: BoxFit.contain),
          const SizedBox(height: AppSizes.xl),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall!.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium!.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
