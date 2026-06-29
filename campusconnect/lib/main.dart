import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/error/fatal_error_screen.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  String _status = 'Verifying configuration…';

  @override
  void initState() {
    super.initState();
    _startup();
  }

  Future<void> _startup() async {
    // Step 1: Brief startup pause to show splash (Firebase init will live here)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _status = 'Loading campus data…');

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _status = 'Ready';
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SplashScreen();
    }

    // TODO(Milestone 2): Replace with AuthGate that checks Firebase auth state
    return const _PlaceholderHomeShell();
  }
}

/// Temporary home shell shown after successful startup in Milestone 1.
/// Replaced entirely in Milestone 3 (navigation shell).
class _PlaceholderHomeShell extends StatelessWidget {
  const _PlaceholderHomeShell();

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfig>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final isEnforced = themeProvider.isDarkModeEnforced;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
        actions: [
          // Theme toggle — greyed out when dark mode is enforced
          IconButton(
            onPressed: isEnforced ? null : themeProvider.toggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isEnforced
                ? 'Dark mode enforced (8PM–6AM)'
                : isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Config verification success banner
            _ConfigBanner(config: config),
            const SizedBox(height: 20),

            // Theme status card
            _ThemeStatusCard(
              isDark: isDark,
              isEnforced: isEnforced,
              label: themeProvider.themeStatusLabel,
            ),
            const SizedBox(height: 20),

            // Milestone tracker
            _MilestoneTracker(),
          ],
        ),
      ),
    );
  }
}

class _ConfigBanner extends StatelessWidget {
  final AppConfig config;
  const _ConfigBanner({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00897B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00897B), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: Color(0xFF00897B), size: 20),
              SizedBox(width: 8),
              Text(
                'Configuration Verified',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00897B),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ConfigRow('Campus Code', config.campusCode),
          _ConfigRow('Group', config.groupNumber.toString()),
          _ConfigRow('API Base Path', config.apiBasePath),
          _ConfigRow('API Version', config.apiVersion),
          _ConfigRow('Campus', config.campusName),
          _ConfigRow('Modules', config.featureModules.join(', ')),
        ],
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String value;
  const _ConfigRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF757575),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeStatusCard extends StatelessWidget {
  final bool isDark;
  final bool isEnforced;
  final String label;

  const _ThemeStatusCard({
    required this.isDark,
    required this.isEnforced,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEnforced
            ? const Color(0xFF1A1A2E).withOpacity(0.8)
            : AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnforced ? const Color(0xFF4A4A8A) : AppColors.primary,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEnforced
                ? Icons.nights_stay_rounded
                : isDark
                    ? Icons.dark_mode
                    : Icons.light_mode,
            color: isEnforced
                ? const Color(0xFF9FA8DA)
                : AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Engine — Group 5 Constraint',
                  style: TextStyle(
                    fontSize: 11,
                    color: isEnforced
                        ? const Color(0xFF9FA8DA)
                        : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneTracker extends StatelessWidget {
  final List<_Milestone> _milestones = const [
    _Milestone(1, 'Project scaffold + config + theme engine', true),
    _Milestone(2, 'Firebase Auth + biometric login', false),
    _Milestone(3, 'Core navigation shell', false),
    _Milestone(4, 'Real-time messaging (WebSocket)', false),
    _Milestone(5, 'Location services + geofencing', false),
    _Milestone(6, 'Push notifications (FCM)', false),
    _Milestone(7, 'Offline support + background sync', false),
    _Milestone(8, 'Smart Scheduling (Module A)', false),
    _Milestone(9, 'Campus Marketplace (Module C)', false),
    _Milestone(10, 'Emergency Alert (Module D)', false),
    _Milestone(11, 'Seed data + final polish', false),
  ];

  const _MilestoneTracker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BUILD PROGRESS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 12),
        ..._milestones.map((m) => _MilestoneRow(milestone: m)),
      ],
    );
  }
}

class _Milestone {
  final int number;
  final String title;
  final bool done;
  const _Milestone(this.number, this.title, this.done);
}

class _MilestoneRow extends StatelessWidget {
  final _Milestone milestone;
  const _MilestoneRow({required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: milestone.done
                  ? const Color(0xFF00897B)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: milestone.done
                    ? const Color(0xFF00897B)
                    : const Color(0xFF424242),
                width: 1.5,
              ),
            ),
            child: Center(
              child: milestone.done
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '${milestone.number}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              milestone.title,
              style: TextStyle(
                fontSize: 13,
                color: milestone.done
                    ? null
                    : const Color(0xFF757575),
                fontWeight:
                    milestone.done ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
