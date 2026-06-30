import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

const bool kDemoMode = false;
/// Central authentication service for CampusConnect.
///
/// The provider keeps the app state in sync with Firebase Auth, persists a
/// lightweight session marker for secure re-entry, and exposes a small API for
/// login, registration, password reset, Google Sign-In, and biometric unlock.
/// When [kDemoMode] is true, this provider switches to a development-only mock
/// authentication flow without changing the public API.
class AuthProvider extends ChangeNotifier {
  AuthProvider({bool demoMode = kDemoMode}) {
    _demoMode = demoMode;
    _hydratePersistedSession();
  }

  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late bool _demoMode;
  CampusUser? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  String? _errorMessage;
  String? _lastSignedInEmail;

  CampusUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;
  bool get isBiometricAvailable => _isBiometricAvailable;
  bool get isBiometricEnabled => _isBiometricEnabled;
  String? get errorMessage => _errorMessage;
  String? get lastSignedInEmail => _lastSignedInEmail;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _setLoading(true);

    try {
      if (_demoMode) {
        _user = const CampusUser(
          uid: 'demo-user',
          email: 'demo@campusconnect.dev',
          displayName: 'Demo User',
        );
        _isBiometricAvailable = true;
        _isBiometricEnabled = true;
        _lastSignedInEmail = 'demo@campusconnect.dev';
        await _persistSession(
          email: _lastSignedInEmail!,
          password: 'demo-password',
        );
      } else {
        _auth = FirebaseAuth.instance;
        _googleSignIn = GoogleSignIn();

        final firebaseUser = _auth!.currentUser;
        _user = firebaseUser == null ? null : CampusUser.fromFirebase(firebaseUser);
        _auth!.authStateChanges().listen((User? nextUser) {
          _user = nextUser == null ? null : CampusUser.fromFirebase(nextUser);
          if (nextUser == null) {
            _clearPersistedSession();
          }
          notifyListeners();
        });

        _isBiometricAvailable = await _localAuth.canCheckBiometrics;
        _isBiometricEnabled =
            await _secureStorage.read(key: 'biometric_enabled') == 'true';
        _lastSignedInEmail = await _secureStorage.read(key: 'last_signed_in_email');
      }
    } catch (_) {
      _errorMessage = _demoMode
          ? 'Demo authentication is unavailable.'
          : 'Firebase could not be initialized on this device.';
    } finally {
      _isInitialized = true;
      _setLoading(false);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (_demoMode) {
        _user = CampusUser(
          uid: 'demo-user',
          email: email.trim().isEmpty ? 'demo@campusconnect.dev' : email.trim(),
          displayName: 'Demo User',
        );
        await _persistSession(email: _user!.email ?? 'demo@campusconnect.dev', password: password);
        notifyListeners();
        return;
      }

      final auth = _auth;
      if (auth == null) {
        _errorMessage = 'Authentication is unavailable.';
        return;
      }

      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _user = CampusUser.fromFirebase(credential.user!);
      await _persistSession(email: email.trim(), password: password);
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? 'Unable to sign in.';
    } catch (_) {
      _errorMessage = 'Unable to sign in right now.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (_demoMode) {
        _user = CampusUser(
          uid: 'demo-user',
          email: email.trim().isEmpty ? 'demo@campusconnect.dev' : email.trim(),
          displayName: 'Demo User',
        );
        await _persistSession(email: _user!.email ?? 'demo@campusconnect.dev', password: password);
        notifyListeners();
        return;
      }

      final auth = _auth;
      if (auth == null) {
        _errorMessage = 'Authentication is unavailable.';
        return;
      }

      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _user = CampusUser.fromFirebase(credential.user!);
      await _persistSession(email: email.trim(), password: password);
      notifyListeners();
    } on FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? 'Unable to create an account.';
    } catch (_) {
      _errorMessage = 'Unable to create an account right now.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (_demoMode) {
        _user = const CampusUser(
          uid: 'demo-google-user',
          email: 'demo@campusconnect.dev',
          displayName: 'Demo Google User',
        );
        await _persistSession(email: _user!.email ?? 'demo@campusconnect.dev');
        notifyListeners();
        return;
      }

      if (kIsWeb) {
        _errorMessage = 'Google Sign-In is available on supported mobile builds.';
        return;
      }

      final googleSignIn = _googleSignIn;
      if (googleSignIn == null) {
        _errorMessage = 'Google Sign-In is unavailable.';
        return;
      }

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _errorMessage = 'Google sign-in was cancelled.';
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final auth = _auth;
      if (auth == null) {
        _errorMessage = 'Authentication is unavailable.';
        return;
      }

      final authCredential = await auth.signInWithCredential(credential);
      _user = CampusUser.fromFirebase(authCredential.user!);
      await _persistSession(email: _user?.email ?? 'google-user');
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Google sign-in is unavailable right now.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword({required String email}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      if (_demoMode) {
        await _persistSession(email: email.trim(), password: 'demo-password');
        return;
      }

      final auth = _auth;
      if (auth == null) {
        _errorMessage = 'Authentication is unavailable.';
        return;
      }

      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      _errorMessage = error.message ?? 'Unable to send a reset email.';
    } catch (_) {
      _errorMessage = 'Unable to send a reset email right now.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithBiometrics() async {
    if (_demoMode) {
      _user = const CampusUser(
        uid: 'demo-biometrics-user',
        email: 'demo@campusconnect.dev',
        displayName: 'Demo Biometric User',
      );
      _isBiometricEnabled = true;
      await _persistSession(email: _user!.email ?? 'demo@campusconnect.dev');
      notifyListeners();
      return true;
    }

    if (!_isBiometricEnabled || !_isBiometricAvailable) return false;

    final authenticated = await _localAuth.authenticate(
      localizedReason: 'Unlock CampusConnect with biometrics',
      options: const AuthenticationOptions(stickyAuth: true),
    );

    if (!authenticated) return false;

    final storedPassword = await _secureStorage.read(
      key: 'password_${_lastSignedInEmail ?? 'campusconnect'}',
    );
    if (storedPassword == null || storedPassword.isEmpty) return false;

    await signInWithEmailAndPassword(
      email: _lastSignedInEmail ?? '',
      password: storedPassword,
    );
    return isAuthenticated;
  }

  Future<void> enableBiometricLogin({
    required String email,
    required String password,
  }) async {
    await _persistSession(email: email, password: password);
    await _secureStorage.write(key: 'biometric_enabled', value: 'true');
    _isBiometricEnabled = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      if (!_demoMode) {
        await _auth?.signOut();
        await _googleSignIn?.signOut();
      }
      await _clearPersistedSession();
      _user = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _hydratePersistedSession() async {
    if (_demoMode) {
      _isBiometricAvailable = true;
      _isBiometricEnabled = true;
      _lastSignedInEmail = 'demo@campusconnect.dev';
      notifyListeners();
      return;
    }

    final storedEmail = await _secureStorage.read(key: 'last_signed_in_email');
    final storedSession = await _secureStorage.read(key: 'session_present');
    _lastSignedInEmail = storedEmail;
    _isBiometricEnabled =
        await _secureStorage.read(key: 'biometric_enabled') == 'true';
    if (storedSession == 'true' && storedEmail != null && storedEmail.isNotEmpty) {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics;
    }
    notifyListeners();
  }

  Future<void> _persistSession({
    required String email,
    String? password,
  }) async {
    _lastSignedInEmail = email;
    if (_demoMode) {
      notifyListeners();
      return;
    }

    await _secureStorage.write(key: 'last_signed_in_email', value: email);
    await _secureStorage.write(key: 'session_present', value: 'true');
    if (password != null && password.isNotEmpty) {
      await _secureStorage.write(
        key: 'password_${email.trim()}',
        value: password,
      );
    }
    notifyListeners();
  }

  Future<void> _clearPersistedSession() async {
    if (_demoMode) {
      _isBiometricEnabled = false;
      _lastSignedInEmail = null;
      notifyListeners();
      return;
    }

    await _secureStorage.delete(key: 'session_present');
    await _secureStorage.delete(key: 'last_signed_in_email');
    await _secureStorage.delete(key: 'biometric_enabled');
    _isBiometricEnabled = false;
    _lastSignedInEmail = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

class CampusUser {
  const CampusUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  factory CampusUser.fromFirebase(User user) {
    return CampusUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
