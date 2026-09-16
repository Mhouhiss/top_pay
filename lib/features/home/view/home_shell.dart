import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_pay/core/theme/app_colors.dart';
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
    SystemNavigator.pop();
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
