import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/services/auth_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../offline/presentation/providers/offline_sync_provider.dart';

/// Dashboard page shown as the landing page in the main application shell.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfig>();
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final offlineProvider = context.watch<OfflineSyncProvider>();
    final userEmail = authProvider.user?.email ?? 'Signed out';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(userEmail, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Campus code: ${config.campusCode}'),
                const SizedBox(height: 8),
                Text(themeProvider.themeStatusLabel),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text('Quick access', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _QuickCard(title: 'Messages', icon: Icons.chat_bubble_rounded),
            _QuickCard(title: 'Marketplace', icon: Icons.storefront_rounded),
            _QuickCard(title: 'Schedule', icon: Icons.event_rounded),
            _QuickCard(title: 'Emergency', icon: Icons.emergency_rounded),
          ],
        ),
        const SizedBox(height: 20),
        Text('Recent notifications', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _NotificationTile(
          title: 'Unread alerts',
          subtitle: '${notificationProvider.unreadCount} new updates ready',
        ),
        _NotificationTile(
          title: 'Offline sync',
          subtitle: offlineProvider.isOnline ? 'Connected and ready to sync' : 'Offline mode active',
        ),
        const SizedBox(height: 20),
        Text('Upcoming events', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const _NotificationTile(title: 'Campus mixer', subtitle: '6:30 PM · Phoenix Center'),
        const _NotificationTile(title: 'Library workshop', subtitle: '4:00 PM · South Mountain Library'),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_rounded),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
