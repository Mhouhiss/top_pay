import 'package:go_router/go_router.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/features/bills/view/data_screen.dart';
import 'package:top_pay/features/bills/view/electricity_screen.dart';
import 'package:top_pay/features/notification/view/notification_screen.dart';
import 'package:top_pay/features/profile/view/edit_profile_screen.dart';
import 'package:top_pay/features/profile/view/profile_screen.dart';
import 'package:top_pay/features/transactions_history/model/transaction_model.dart';
import 'package:top_pay/features/transactions_history/view/transactions_screen.dart';
import 'package:top_pay/features/transactions_history/view/transaction_detail_screen.dart';

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
    GoRoute(
      path: AppRoutes.transactions,
      builder: (context, state) => const TransactionsScreen(),
    ),
    GoRoute(
      path: AppRoutes.transactionDetail,
      builder: (context, state) {
        final transaction = state.extra as TransactionModel;
        return TransactionDetailScreen(transaction: transaction);
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationScreen(),
    ),

    GoRoute(
      path: AppRoutes.airtime,
      builder: (context, state) => const DataScreen(),
    ),
    GoRoute(
      path: AppRoutes.data,
      builder: (context, state) => const DataScreen(),
    ),
    GoRoute(
      path: AppRoutes.electricity,
      builder: (context, state) => const ElectricityScreen(),
    ),
  ],
);
