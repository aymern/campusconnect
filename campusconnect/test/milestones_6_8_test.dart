import 'package:flutter_test/flutter_test.dart';

import 'package:campusconnect/features/notifications/presentation/providers/notification_provider.dart';
import 'package:campusconnect/features/offline/presentation/providers/offline_sync_provider.dart';
import 'package:campusconnect/features/scheduling/presentation/providers/scheduling_provider.dart';

void main() {
  group('Milestone 6 notifications', () {
    test('tracks unread notifications and marks them read', () {
      final provider = NotificationProvider();
      expect(provider.unreadCount, greaterThan(0));

      final first = provider.notifications.first;
      provider.markAsRead(first.id);

      expect(provider.notifications.firstWhere((item) => item.id == first.id).isRead, isTrue);
      expect(provider.unreadCount, lessThanOrEqualTo(1));
    });
  });

  group('Milestone 7 offline sync', () {
    test('queues work while offline and clears after sync', () async {
      final provider = OfflineSyncProvider();
      provider.setOnlineStatus(false);
      provider.queueOperation('sync messages');

      expect(provider.pendingCount, 1);

      provider.setOnlineStatus(true);
      await provider.syncPendingItems();

      expect(provider.pendingCount, 0);
      expect(provider.lastSyncedOperation, 'sync messages');
    });
  });

  group('Milestone 8 scheduling', () {
    test('detects conflicting schedule entries', () {
      final provider = SchedulingProvider();
      final conflict = provider.entries.first;
      final duplicate = conflict.copyWith(id: 'conflict-test');

      expect(provider.hasConflict(duplicate), isTrue);
    });
  });
}
