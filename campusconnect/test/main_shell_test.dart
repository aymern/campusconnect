import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:campusconnect/core/config/app_config.dart';
import 'package:campusconnect/core/services/auth_provider.dart';
import 'package:campusconnect/core/theme/theme_provider.dart';
import 'package:campusconnect/features/main/presentation/pages/main_shell.dart';
<<<<<<< HEAD
import 'package:campusconnect/features/notifications/data/repositories/notification_repository.dart';
import 'package:campusconnect/features/notifications/presentation/providers/notification_provider.dart';
import 'package:campusconnect/features/notifications/services/fcm_service.dart';
import 'package:campusconnect/features/notifications/services/local_notification_service.dart';
import 'package:campusconnect/features/offline/data/repositories/offline_cache_repository.dart';
import 'package:campusconnect/features/offline/presentation/providers/offline_provider.dart';
import 'package:campusconnect/features/offline/services/connectivity_monitor.dart';
import 'package:campusconnect/features/offline/services/sync_service.dart';
=======
import 'package:campusconnect/features/notifications/presentation/providers/notification_provider.dart';
import 'package:campusconnect/features/offline/presentation/providers/offline_sync_provider.dart';
import 'package:campusconnect/features/scheduling/presentation/providers/scheduling_provider.dart';
>>>>>>> dc4cda3 (Configure Firebase and complete milestones 8-10)

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('MainShell shows the dashboard and bottom navigation', (tester) async {
    final configResult = await AppConfig.load();
    expect(configResult.isSuccess, isTrue);

    final config = configResult.config!;
    final themeProvider = ThemeProvider(config);
    final authProvider = AuthProvider();
<<<<<<< HEAD
    final notificationProvider = NotificationProvider(
      repository: SqliteNotificationRepository(),
      fcmService: DemoFcmService(),
      localNotificationService: LocalNotificationService(),
      demoMode: true,
    );
    final offlineProvider = OfflineProvider(
      cacheRepository: SqliteOfflineCacheRepository(),
      connectivityMonitor: ConnectivityMonitor(),
      syncService: SyncService(
        queueRepository: SqliteOfflineCacheRepository(),
      ),
    );
=======
    final notificationProvider = NotificationProvider();
    final offlineSyncProvider = OfflineSyncProvider();
    final schedulingProvider = SchedulingProvider();
>>>>>>> dc4cda3 (Configure Firebase and complete milestones 8-10)

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppConfig>.value(value: config),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
<<<<<<< HEAD
          ChangeNotifierProvider<OfflineProvider>.value(value: offlineProvider),
=======
          ChangeNotifierProvider<OfflineSyncProvider>.value(value: offlineSyncProvider),
          ChangeNotifierProvider<SchedulingProvider>.value(value: schedulingProvider),
>>>>>>> dc4cda3 (Configure Firebase and complete milestones 8-10)
        ],
        child: const MaterialApp(home: MainShell()),
      ),
    );

    await tester.pump();

    expect(find.text('CampusConnect'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
  });
}
