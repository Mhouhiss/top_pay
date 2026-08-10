import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_constants.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(AppConstants.longAnimation, () {
        if (!mounted) return;
        context.go(AppRoutes.onboarding);
      });
    });
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
                      'Initializing...',
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

//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'app_controller_riverpod.dart';
// import 'auth_controller_riverpod.dart';
//
// /// Note: in Riverpod, navigation is a widget-level side effect, not something
// /// a Notifier should trigger directly (Notifiers shouldn't hold BuildContext).
// /// So the "SplashController" logic just lives here, in the widget itself.
// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   String _statusText = 'Starting up...';
//
//   @override
//   void initState() {
//     super.initState();
//     // Post-frame so `ref` is safe to use and the first frame paints immediately.
//     WidgetsBinding.instance.addPostFrameCallback((_) => _startSequence());
//   }
//
//   Future<void> _startSequence() async {
//     // Tune this — 2-4s is typical for a fintech/VTU splash.
//     final minimumDelay = Future.delayed(const Duration(seconds: 3));
//
//     setState(() => _statusText = 'Setting things up...');
//
//     final initTasks = Future.wait([
//       ref.read(appControllerProvider.notifier).init(),
//       ref.read(authControllerProvider.notifier).checkAuthStatus(),
//     ]);
//
//     // Whichever takes longer (the delay or the real work) is what the user waits for.
//     await Future.wait([minimumDelay, initTasks]);
//
//     if (!mounted) return;
//     _navigateNext();
//   }
//
//   void _navigateNext() {
//     final appState = ref.read(appControllerProvider);
//     final authState = ref.read(authControllerProvider);
//
//     if (appState.forceUpdate) {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//           '/force-update', (r) => false);
//       return;
//     }
//     if (appState.isFirstLaunch) {
//       Navigator.of(context).pushNamedAndRemoveUntil(
//           '/onboarding', (r) => false);
//     } else if (authState.isLoggedIn) {
//       Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
//     } else {
//       Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset('assets/images/logo.png', width: 120),
//             const SizedBox(height: 24),
//             const CircularProgressIndicator(),
//             const SizedBox(height: 16),
//             Text(_statusText,
//                 style: const TextStyle(fontSize: 13, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }
