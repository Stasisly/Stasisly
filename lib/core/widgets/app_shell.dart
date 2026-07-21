import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main application shell providing the bottom navigation bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Stasis',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Salud',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Nutrición',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Físico',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'Mental',
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/stasis') ||
        location.startsWith('/conversations')) {
      return 0;
    }
    if (location.startsWith('/health')) {
      return 1;
    }
    if (location.startsWith('/nutrition')) {
      return 2;
    }
    if (location.startsWith('/physical')) {
      return 3;
    }
    if (location.startsWith('/mental')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/stasis');
      case 1:
        context.go('/health');
      case 2:
        context.go('/nutrition');
      case 3:
        context.go('/physical');
      case 4:
        context.go('/mental');
    }
  }
}
