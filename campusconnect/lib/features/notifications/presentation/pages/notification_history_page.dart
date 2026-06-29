import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});

  @override
  State<NotificationHistoryPage> createState() => _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification history'),
        actions: [
          TextButton(
            onPressed: provider.notifications.isEmpty ? null : provider.markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.notifications.isEmpty
              ? const Center(child: Text('No notifications yet.'))
              : ListView.builder(
                  itemCount: provider.notifications.length,
                  itemBuilder: (context, index) {
                    final item = provider.notifications[index];
                    return ListTile(
                      leading: Icon(
                        item.isRead ? Icons.mark_email_read_outlined : Icons.notifications_active,
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.body),
                      trailing: Text(
                        '${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}',
                      ),
                      onTap: () async {
                        if (!item.isRead) {
                          await provider.markAsRead(item.id);
                        }
                      },
                    );
                  },
                ),
    );
  }
}
