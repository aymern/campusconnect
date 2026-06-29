import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_provider.dart';
import '../../../notifications/presentation/pages/notification_history_page.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../offline/presentation/pages/offline_status_page.dart';
import '../../../offline/presentation/providers/offline_provider.dart';

/// Settings feature page.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final offlineProvider = context.watch<OfflineProvider>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Dark mode'),
            subtitle: Text(themeProvider.isDarkModeEnforced
                ? 'Locked by the campus dark-mode rule.'
                : 'Toggle theme manually.'),
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.isDarkModeEnforced
                ? null
                : (value) => themeProvider.setTheme(value ? ThemeMode.dark : ThemeMode.light),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.notifications_active_rounded),
            title: const Text('Notifications'),
            subtitle: Text(
              notificationProvider.permissionGranted
                  ? 'Enabled • ${notificationProvider.badgeCount} unread'
                  : 'Permission required',
            ),
            onTap: () async {
              await notificationProvider.requestPermissions();
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Notification history'),
            subtitle: const Text('View recent alerts'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync_rounded),
            title: const Text('Sync status'),
            subtitle: Text(offlineProvider.isOnline ? 'Online' : 'Offline'),
            trailing: Text(offlineProvider.pendingOperations.isEmpty ? 'Synced' : '${offlineProvider.pendingOperations.length} pending'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OfflineStatusPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.wifi_tethering_rounded),
            title: const Text('Offline queue'),
            subtitle: const Text('Manage cached sync operations'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OfflineStatusPage()),
              );
            },
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('Campus code'),
            subtitle: Text(themeProvider.themeStatusLabel),
          ),
        ],
      ),
    );
  }
}
