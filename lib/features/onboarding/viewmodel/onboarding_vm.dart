import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../onboarding/model/onboarding_model.dart';
import '/core/constants/app_assets.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel() {
    _startAutoScroll();
  }

  final PageController pageController = PageController();

  final pages = const [
    OnboardingModel(
      title: 'Instant Airtime & Data',
      subtitle: 'Quick airtime and data top-ups with exclusive offers.',
      imagePath: AppAssets.onboarding1,
    ),
    OnboardingModel(
      title: 'Bills & Subscriptions',
      subtitle: 'Pay your electricity, TV, and Internet bills with ease.',
      imagePath: AppAssets.onboarding2,
    ),
    OnboardingModel(
      title: 'Secured Wallet & Rewards',
      subtitle: 'Enjoy secured payments along with exclusive rewards.',
      imagePath: AppAssets.onboarding3,
    ),
  ];

  int currentPageIndex = 0;

  Timer? _timer;

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!pageController.hasClients) return;

      final nextPage = (currentPageIndex + 1) % pages.length;

      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}

final onboardingViewModelProvider =
    ChangeNotifierProvider.autoDispose<OnboardingViewModel>(
      (ref) => OnboardingViewModel(),
    );
