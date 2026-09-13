import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/features/auth/view/otp_screen.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import 'package:top_pay/shared/components/custom_textfield.dart';
import 'package:top_pay/core/utils/auth_validator.dart';
import 'package:top_pay/core/router/router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  static const double _headerHeightFraction = 0.30;
  static const double _headerMinHeight = 200;
  static const double _headerMaxHeight = 300;

  static const double _cardOverlap = 28;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authViewModelProvider).isLoading) return;

    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    final success = await ref
        .read(authViewModelProvider.notifier)
        .register(
          username: _usernameController.text.trim(),
          email: email,
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          referralCode: _referralController.text.trim(),
        );

    if (!mounted || !success) return;

    context.push(
      AppRoutes.otp,
      extra: {'email': email, 'otpType': OtpType.registration},
    );
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
                        Image.asset(
                          AppAssets.tpLogo,
                          height: AppSizes.xxl,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          'TopPay',
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
                  borderRadius: BorderRadius.only(
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
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.lg,
                        AppSizes.xl,
                        AppSizes.lg,
                        AppSizes.xxl,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Create your Account',
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppSizes.xl),

                            CustomTextField(
                              label: 'Username',
                              hint: 'John',
                              controller: _usernameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: Validators.username,
                            ),
                            const SizedBox(height: AppSizes.md),

                            CustomTextField(
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              prefixIcon: const Icon(Icons.phone_outlined),
                              validator: Validators.phoneNumber,
                            ),
                            const SizedBox(height: AppSizes.md),

                            CustomTextField(
                              label: 'Email Address',
                              hint: 'Enter your email address',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              prefixIcon: const Icon(Icons.email_outlined),
                              validator: Validators.email,
                            ),
                            const SizedBox(height: AppSizes.md),

                            CustomTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passwordController,
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                              validator: Validators.password,
                            ),

                            const SizedBox(height: AppSizes.md),
                            CustomTextField(
                              label: 'Confirm Password',
                              hint: 'Re-enter your password',
                              controller: _confirmPasswordController,
                              textInputAction: TextInputAction.next,
                              enabled: !authState.isLoading,
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                              validator: (value) => Validators.confirmPassword(
                                value,
                                _passwordController.text,
                              ),
                            ),
                            const SizedBox(height: AppSizes.md),

                            CustomTextField(
                              label: 'Referral Code (Optional)',
                              hint: 'Enter referral code',
                              controller: _referralController,
                              textInputAction: TextInputAction.done,
                              enabled: !authState.isLoading,
                              prefixIcon: const Icon(
                                Icons.card_giftcard_outlined,
                              ),
                              onSubmitted: (_) => _submit(),
                              validator: Validators.referralCode,
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
                            CustomButton(
                              label: 'Sign Up',
                              isLoading: authState.isLoading,
                              onPressed: authState.isLoading ? null : _submit,
                            ),
                            const SizedBox(height: AppSizes.lg),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.xs),
                                  GestureDetector(
                                    onTap: authState.isLoading
                                        ? null
                                        : () => context.go(AppRoutes.login),
                                    child: Text(
                                      'Log in',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
