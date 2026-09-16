import 'package:go_router/go_router.dart';
import 'package:top_pay/core/router/router.dart';

import '../../features/splash/view/splash_screen.dart';
import '../../features/onboarding/view/onboarding_screen.dart';
import '../../features/auth//view/login_screen.dart';
import '../../features/auth/view/forgot_password.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/auth/view/reset_password.dart';
import '../../features/auth/view/otp_screen.dart';
import '../../features/home/view/home_shell.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,

  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return OtpScreen(
          email: extra['email'] as String,
          otpType: extra['otpType'] as OtpType,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => const ResetPasswordScreen(),
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeShell(),
    ),
  ],
);
