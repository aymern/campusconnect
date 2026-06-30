import 'package:flutter_test/flutter_test.dart';

import 'package:campusconnect/core/services/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('demo mode authenticates any email and password', () async {
    final provider = AuthProvider();

    await provider.initialize();
    await provider.signInWithEmailAndPassword(email: 'anyone@example.com', password: 'secret');

    expect(provider.isAuthenticated, isTrue);
    expect(provider.user?.email, 'anyone@example.com');
  });

  test('demo mode simulates Google and biometric sign-in', () async {
    final provider = AuthProvider();

    await provider.initialize();
    await provider.signInWithGoogle();
    expect(provider.isAuthenticated, isTrue);

    final biometricResult = await provider.signInWithBiometrics();
    expect(biometricResult, isTrue);
  });
}
