import 'package:campusconnect/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen renders the app identity', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.text('CampusConnect'), findsOneWidget);
    expect(find.text('CAM-PHX-05 · Phoenix Campus'), findsOneWidget);
  });
}
