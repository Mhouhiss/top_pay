import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_pay/core/theme/app_colors.dart';
import 'package:top_pay/core/constants/app_sizes.dart';
import 'package:top_pay/features/dashboard/view/dashboard_screen.dart';
import 'package:top_pay/features/transactions/view/transactions_screen.dart';
import 'package:top_pay/features/profile/view/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  DateTime? _lastBackPressed;
  static const Duration _exitTapTimeout = Duration(seconds: 2);

  static const List<Widget> _pages = [
    DashboardScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  void _handleBackPress() {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });

      return;
    }

    final now = DateTime.now();

    final isSecondBackPress =
        _lastBackPressed != null &&
        now.difference(_lastBackPressed!) <= _exitTapTimeout;

    if (isSecondBackPress) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressed = now;

    _showExitMessage();
  }

  void _showExitMessage() {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: _exitTapTimeout,
          elevation: 6,
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Text(
                'Tap back again to exit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _handleBackPress();
      },

      child: Scaffold(
        backgroundColor: AppColors.white,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onDestinationSelected,
          elevation: 8,
          backgroundColor: colorScheme.surface,
          indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              selectedIcon: Icon(Icons.home, color: colorScheme.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.receipt_long_outlined,
                color: colorScheme.onSurfaceVariant,
              ),

              selectedIcon: Icon(
                Icons.receipt_long,
                color: colorScheme.primary,
              ),
              label: 'Transactions',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: colorScheme.onSurfaceVariant,
              ),

              selectedIcon: Icon(Icons.person, color: colorScheme.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
