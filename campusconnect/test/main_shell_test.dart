import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:campusconnect/core/config/app_config.dart';
import 'package:campusconnect/core/services/auth_provider.dart';
import 'package:campusconnect/core/theme/theme_provider.dart';
import 'package:campusconnect/features/main/presentation/pages/main_shell.dart';

void main() {
  testWidgets('MainShell shows the dashboard and bottom navigation', (tester) async {
    final configResult = await AppConfig.load();
    expect(configResult.isSuccess, isTrue);

    final config = configResult.config!;
    final themeProvider = ThemeProvider(config);
    final authProvider = AuthProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AppConfig>.value(value: config),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: const MaterialApp(home: MainShell()),
      ),
    );

    await tester.pump();

    expect(find.text('CampusConnect'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
  });
}
