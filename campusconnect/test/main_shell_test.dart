import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:campusconnect/core/config/app_config.dart';
import 'package:campusconnect/core/services/auth_provider.dart';
import 'package:campusconnect/core/theme/theme_provider.dart';
import 'package:campusconnect/features/main/presentation/pages/main_shell.dart';
import 'package:campusconnect/features/notifications/data/repositories/notification_repository.dart';
import 'package:campusconnect/features/notifications/presentation/providers/notification_provider.dart';
import 'package:campusconnect/features/notifications/services/fcm_service.dart';
import 'package:campusconnect/features/notifications/services/local_notification_service.dart';
import 'package:campusconnect/features/offline/data/repositories/offline_cache_repository.dart';
import 'package:campusconnect/features/offline/presentation/providers/offline_provider.dart';
import 'package:campusconnect/features/offline/services/connectivity_monitor.dart';
import 'package:campusconnect/features/offline/services/sync_service.dart';

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

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppConfig>.value(value: config),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<NotificationProvider>.value(value: notificationProvider),
          ChangeNotifierProvider<OfflineProvider>.value(value: offlineProvider),
        ],
        child: const MaterialApp(home: MainShell()),
      ),
    );

    await tester.pump();

    expect(find.text('CampusConnect'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
  });
}
