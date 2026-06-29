import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/theme_provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'dashboard_page.dart';
import 'emergency_page.dart';
import 'marketplace_page.dart';
import 'messages_page.dart';
import 'profile_page.dart';
import 'scheduling_page.dart';
import 'settings_page.dart';

/// Main application shell that hosts the named-route navigation for Milestone 3.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static const String routeName = '/main';

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    MessagesPage(),
    MarketplacePage(),
    SchedulingPage(),
    EmergencyPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appConfig = context.read<AppConfig>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
        actions: [
          IconButton(
            onPressed: themeProvider.isDarkModeEnforced
                ? null
                : themeProvider.toggleTheme,
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: themeProvider.isDarkModeEnforced
                ? 'Dark mode enforced (8PM–6AM)'
                : 'Toggle theme',
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        campusCode: appConfig.campusCode,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
