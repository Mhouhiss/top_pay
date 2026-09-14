import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:top_pay/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:top_pay/core/utils/auth_validator.dart';
import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/shared/components/custom_button.dart';
import 'package:top_pay/shared/components/custom_textfield.dart';
import 'package:top_pay/core/router/router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const double _headerHeightFraction = 0.30;
  static const double _headerMinHeight = 200;
  static const double _headerMaxHeight = 300;

  static const double _cardOverlap = 28;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (ref.read(authViewModelProvider).isLoading) return;

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authViewModelProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted || !success) return;

    context.go(AppRoutes.home);
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
                    onTap: () => FocusScope.of(context).unfocus(),
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
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Welcome back',
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppSizes.xl),

                            CustomTextField(
                              label: 'Email Address',
                              hint: 'johndoe@example.com',
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
                              validator: Validators.loginPassword,
                            ),
                            const SizedBox(height: AppSizes.xs),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : () => context.push(
                                        AppRoutes.forgotPassword,
                                      ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
                              label: 'Log in',
                              isLoading: authState.isLoading,
                              onPressed: authState.isLoading ? null : _submit,
                            ),
                            const SizedBox(height: AppSizes.lg),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account?',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.xs),
                                  GestureDetector(
                                    onTap: () => authState.isLoading
                                        ? null
                                        : context.go(AppRoutes.register),
                                    child: Text(
                                      'Sign up',
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
