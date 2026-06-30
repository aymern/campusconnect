import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/services/auth_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/auth_gate.dart';
import 'features/error/fatal_error_screen.dart';
import 'features/main/presentation/pages/main_shell.dart';
<<<<<<< HEAD
import 'features/notifications/data/repositories/notification_repository.dart';
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/notifications/services/fcm_service.dart';
import 'features/notifications/services/local_notification_service.dart';
import 'features/offline/data/repositories/offline_cache_repository.dart';
import 'features/offline/presentation/providers/offline_provider.dart';
import 'features/offline/services/connectivity_monitor.dart';
import 'features/offline/services/sync_service.dart';
=======
import 'features/notifications/presentation/providers/notification_provider.dart';
import 'features/offline/presentation/providers/offline_sync_provider.dart';
import 'features/scheduling/presentation/providers/scheduling_provider.dart';
>>>>>>> dc4cda3 (Configure Firebase and complete milestones 8-10)
import 'features/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load and validate configuration BEFORE showing any app UI.
  // This satisfies the assignment requirement: if campus_code or api_version
  // are incorrect, a fatal error screen is shown and the app cannot proceed.
  final configResult = await AppConfig.load();

  runApp(
    CampusConnectApp(configResult: configResult),
  );
}

class CampusConnectApp extends StatelessWidget {
  final AppConfigLoadResult configResult;

  const CampusConnectApp({super.key, required this.configResult});

  @override
  Widget build(BuildContext context) {
    // Config failed validation — show fatal error, no providers needed
    if (!configResult.isSuccess) {
      return MaterialApp(
        title: 'CampusConnect — Fatal Error',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        home: FatalErrorScreen(error: configResult.error!),
      );
    }

    // Config is valid — wire up providers and launch the full app
    final config = configResult.config!;
    return MultiProvider(
      providers: [
        // ThemeProvider must come first as other providers may read it
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(config),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
<<<<<<< HEAD
          create: (_) => NotificationProvider(
            repository: SqliteNotificationRepository(),
            fcmService: kIsWeb || kDebugMode
                ? DemoFcmService()
                : FirebaseCloudMessagingService(),
            localNotificationService: LocalNotificationService(),
            demoMode: kIsWeb || kDebugMode,
          ),
        ),
        ChangeNotifierProvider<OfflineProvider>(
          create: (_) => OfflineProvider(
            cacheRepository: SqliteOfflineCacheRepository(),
            connectivityMonitor: ConnectivityMonitor(),
            syncService: SyncService(
              queueRepository: SqliteOfflineCacheRepository(),
            ),
          ),
=======
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<OfflineSyncProvider>(
          create: (_) => OfflineSyncProvider(),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
>>>>>>> dc4cda3 (Configure Firebase and complete milestones 8-10)
        ),
        // AppConfig is provided as a plain value — it's immutable
        Provider<AppConfig>.value(value: config),
      ],
      child: const _AppRoot(),
    );
  }
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'CampusConnect',
      debugShowCheckedModeBanner: false,

      // Themes derived from Group 5 color palette
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,

      // Initial route shows splash while Firebase initialises (Milestone 2)
      home: const _StartupGate(),
    );
  }
}

/// Handles the startup sequence after config validation passes.
/// In Milestone 1 this shows the splash and transitions to a placeholder.
/// In Milestone 2 this will initialise Firebase and check auth state.
class _StartupGate extends StatefulWidget {
  const _StartupGate();

  @override
  State<_StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<_StartupGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _startup();
  }

  Future<void> _startup() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.initialize();

    final notificationProvider = context.read<NotificationProvider>();
    await notificationProvider.initialize();

    final offlineProvider = context.read<OfflineProvider>();
    await offlineProvider.initialize();

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SplashScreen();
    }

    return const AuthGate(child: MainShell());
  }
}

