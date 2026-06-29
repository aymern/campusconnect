import 'package:flutter/material.dart';

import '../../domain/entities/app_nav_item.dart';

/// Bottom navigation bar for the main application shell.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.campusCode,
    required this.onTap,
  });

  final int currentIndex;
  final String campusCode;
  final ValueChanged<int> onTap;

  static const List<AppNavItem> _items = [
    AppNavItem(
      routeName: '/dashboard',
      label: 'Home',
      icon: Icons.home_rounded,
      description: 'Dashboard',
    ),
    AppNavItem(
      routeName: '/messages',
      label: 'Messages',
      icon: Icons.chat_bubble_rounded,
      description: 'Messages',
    ),
    AppNavItem(
      routeName: '/marketplace',
      label: 'Marketplace',
      icon: Icons.storefront_rounded,
      description: 'Marketplace',
    ),
    AppNavItem(
      routeName: '/scheduling',
      label: 'Schedule',
      icon: Icons.event_rounded,
      description: 'Smart Scheduling',
    ),
    AppNavItem(
      routeName: '/emergency',
      label: 'Emergency',
      icon: Icons.emergency_rounded,
      description: 'Emergency',
    ),
    AppNavItem(
      routeName: '/profile',
      label: 'Profile',
      icon: Icons.person_rounded,
      description: 'Profile',
    ),
    AppNavItem(
      routeName: '/settings',
      label: 'Settings',
      icon: Icons.settings_rounded,
      description: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        for (final item in _items)
          NavigationDestination(
            icon: Icon(item.icon),
            label: item.label,
          ),
      ],
    );
  }
}
