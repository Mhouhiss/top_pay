import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/theme/app_theme.dart';
import 'package:top_pay/features/onboarding/widgets/dot_indicators.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import '../../onboarding/widgets/onboarding_page_content.dart';
import '../../onboarding/viewmodel/onboarding_vm.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(onboardingViewModelProvider);

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: vm.pageController,
                  itemCount: vm.pages.length,
                  onPageChanged: vm.onPageChanged,
                  itemBuilder: (context, index) =>
                      OnboardingPageContent(page: vm.pages[index]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.lg,
                  bottom: AppSizes.xxl,
                  right: AppSizes.lg,
                ),
                child: Column(
                  children: [
                    DotIndicators(
                      count: vm.pages.length,
                      currentIndex: vm.currentPageIndex,
                    ),
                    const SizedBox(height: AppSizes.xl),
                    CustomButton(
                      label: 'GET STARTED',
                      textColor: Colors.white,
                      onPressed: () {
                        context.go(AppRoutes.register);
                      },
                    ),
                    const SizedBox(height: AppSizes.md),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
