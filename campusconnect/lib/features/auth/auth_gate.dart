import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_provider.dart';
import 'login_screen.dart';

/// Auth gate that routes unauthenticated users to the auth experience and
/// authenticated users to the application shell.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isInitialized && authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.isAuthenticated) {
      return child;
    }

    return const LoginScreen();
  }
}
