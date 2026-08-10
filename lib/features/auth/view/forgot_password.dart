import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import 'package:top_pay/core/router/router.dart';
import 'package:top_pay/features/auth/view/otp_screen.dart';
import 'package:top_pay/shared/components/custom_textfield.dart';
import 'package:top_pay/core/utils/auth_validator.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  static const double _headerHeightFraction = 0.30;
  static const double _headerMinHeight = 200;
  static const double _headerMaxHeight = 300;
  static const double _cardOverlap = 28;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authViewModelProvider).isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _emailFocusNode.unfocus();
    final email = _emailController.text.trim();

    final success = await ref
        .read(authViewModelProvider.notifier)
        .sendPasswordResetOtp(email);

    if (!mounted) return;
    if (success) {
      context.push(
        AppRoutes.otp,
        extra: OtpScreen(email: email, otpType: OtpType.forgotPassword),
      );
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
                          Icons.lock_reset_outlined,
                          size: AppSizes.xxl,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'Forgot Password',
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
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Enter your email address and we\'ll send you a code to reset your password.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSizes.xl),

                            CustomTextField(
                              label: 'Email',
                              hint: 'Enter your email',
                              prefixIcon: Icon(Icons.email_outlined),
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              enabled: !authState.isLoading,
                              autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              validator: Validators.email,
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

                            const Spacer(),
                            CustomButton(
                              label: 'Send Reset Code',
                              isLoading: authState.isLoading,
                              onPressed: authState.isLoading ? null : _submit,
                            ),

                            const SizedBox(height: AppSizes.lg),
                          ],
                        ),
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
