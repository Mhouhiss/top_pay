import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import 'package:top_pay/core/router/router.dart';

enum OtpType { registration, forgotPassword }

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final OtpType otpType;

  const OtpScreen({
    super.key,
    required this.email,
    this.otpType = OtpType.registration,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const double _headerHeightFraction = 0.30;
  static const double _headerMinHeight = 200;
  static const double _headerMaxHeight = 300;
  static const double _cardOverlap = 28;

  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  Timer? _timer;
  int _secondsLeft = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      switch (widget.otpType) {
        case OtpType.registration:
          final success = await ref
              .read(authViewModelProvider.notifier)
              .sendVerificationEmail();

          if (!mounted) return;

          if (success) {
            _startResendTimer();
          }
          break;
        case OtpType.forgotPassword:
          _startResendTimer();
          break;
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _timer?.cancel();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();

    setState(() {
      _canResend = false;
      _secondsLeft = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        setState(() {
          _secondsLeft = 0;
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _resend() async {
    if (!_canResend || ref.read(authViewModelProvider).isLoading) return;

    final success = await ref
        .read(authViewModelProvider.notifier)
        .sendVerificationEmail();

    if (!mounted) return;
    if (success) {
      _startResendTimer();
    }
  }

  Future<void> _verify(String code) async {
    if (code.trim().length < 6 || ref.read(authViewModelProvider).isLoading) {
      return;
    }

    // final success = await ref
    //     .read(authViewModelProvider.notifier)
    //     .verifyEmail();
    // || !success
    if (!mounted) return;

    _pinController.clear();

    switch (widget.otpType) {
      case OtpType.registration:
        context.pushReplacement(AppRoutes.home);
        break;
      case OtpType.forgotPassword:
        context.go(AppRoutes.resetPassword);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final mediaQuery = MediaQuery.of(context);

    final headerHeight = (mediaQuery.size.height * _headerHeightFraction).clamp(
      _headerMinHeight,
      _headerMaxHeight,
    );
    final cardTop = headerHeight - _cardOverlap;

    final canPop = context.canPop();
    final isRegistration = widget.otpType == OtpType.registration;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: colorScheme.outline),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colorScheme.primary, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: colorScheme.primary.withValues(alpha: 0.08),
      border: Border.all(color: colorScheme.primary),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colorScheme.error, width: 2),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: headerHeight,
              child: Container(
                color: colorScheme.primary,
                child: SafeArea(
                  bottom: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mark_email_read_outlined,
                          size: AppSizes.xxl,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          isRegistration ? 'Verify your Email' : 'Verify OTP',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: cardTop,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.xl),
                    topRight: Radius.circular(AppSizes.xl),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Focus.of(context).unfocus(),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.xl,
                        AppSizes.lg,
                        AppSizes.xl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Enter the 6-digit verification code sent to ${widget.email}',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.xl),

                          Pinput(
                            length: 6,
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            errorPinTheme: errorPinTheme,
                            enabled: !authState.isLoading,
                            autofocus: true,
                            closeKeyboardWhenCompleted: true,
                            keyboardType: TextInputType.number,
                            showCursor: true,
                            cursor: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: 2,
                              height: 24,
                              color: colorScheme.primary,
                            ),
                            onCompleted: _verify,
                            onChanged: (_) => setState(() {}),
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                          ),

                          if (authState.errorMessage != null) ...[
                            const SizedBox(height: AppSizes.sm),
                            Container(
                              padding: const EdgeInsets.all(AppSizes.sm),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: AppSizes.iconSm,
                                    color: theme.colorScheme.error,
                                  ),
                                  const SizedBox(width: AppSizes.sm),
                                  Expanded(
                                    child: Text(
                                      authState.errorMessage!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.error,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: AppSizes.xl),

                          Text(
                            "Didn't receive the code?",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.xs),
                          _canResend
                              ? TextButton(
                                  onPressed: authState.isLoading
                                      ? null
                                      : _resend,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Resend OTP',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Resend OTP in ${_secondsLeft}s',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                          const SizedBox(height: AppSizes.xxl),
                          CustomButton(
                            label: isRegistration
                                ? 'Verify Account'
                                : 'Continue',
                            isLoading: authState.isLoading,
                            onPressed:
                                authState.isLoading ||
                                    _pinController.text.length < 6
                                ? null
                                : () => _verify(_pinController.text),
                          ),
                          const SizedBox(height: AppSizes.lg),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (canPop)
              Positioned(
                top: mediaQuery.padding.top + AppSizes.xs,
                left: AppSizes.xs,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
