import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../notifications/presentation/pages/notification_history_page.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../offline/presentation/providers/offline_provider.dart';
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
    final notificationProvider = context.watch<NotificationProvider>();
    final offlineProvider = context.watch<OfflineProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationHistoryPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_rounded),
                tooltip: 'Notifications',
              ),
              if (notificationProvider.badgeCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      notificationProvider.badgeCount > 9
                          ? '9+'
                          : notificationProvider.badgeCount.toString(),
                      style: const TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
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
        child: Column(
          children: [
            if (!offlineProvider.isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Theme.of(context).colorScheme.errorContainer,
                child: const Text('Offline mode · Using cached data', textAlign: TextAlign.center),
              ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
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
