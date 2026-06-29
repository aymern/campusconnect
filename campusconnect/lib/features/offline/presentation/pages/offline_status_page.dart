import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/offline_provider.dart';

class OfflineStatusPage extends StatelessWidget {
  const OfflineStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OfflineProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Offline status')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(provider.isOnline ? Icons.wifi : Icons.wifi_off),
              title: Text(provider.isOnline ? 'Online' : 'Offline mode'),
              subtitle: Text(provider.isOnline ? 'Connected' : 'Using cached data'),
            ),
            const SizedBox(height: 12),
            if (provider.showOfflineBanner)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.cloud_off_rounded),
                  title: const Text('Offline banner active'),
                  subtitle: const Text('Connectivity is unavailable. Cached content is in use.'),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: provider.syncNow,
              icon: const Icon(Icons.sync),
              label: const Text('Sync now'),
            ),
            const SizedBox(height: 12),
            Text('Pending sync queue: ${provider.pendingOperations.length}'),
          ],
        ),
      ),
    );
  }
}
