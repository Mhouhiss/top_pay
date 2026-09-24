import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/features/splash/viewmodel/app_viewmodel.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_constants.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/theme/app_text_styles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _statusText = 'initializing...';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final minimumSplashTime = Future.delayed(AppConstants.mediumAnimation);

    final hasSeenOnboarding = await ref
        .read(appViewModelProvider.notifier)
        .initialize();

    if (!mounted) return;
    setState(() {
      _statusText = 'Loading app...';
    });
    await minimumSplashTime;

    if (!mounted) return;
    if (hasSeenOnboarding) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                AppAssets.tpBanner,
                width: 240,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSizes.xl,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: AppSizes.md,
                      width: AppSizes.md,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      _statusText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
