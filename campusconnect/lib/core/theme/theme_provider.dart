import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// Manages app theme mode with the Group 5 unique constraint:
/// Dark mode is automatically enforced from 8PM (20:00) to 6AM (06:00).
/// During those hours, users cannot switch to light mode.
class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'user_theme_preference';

  final AppConfig _config;
  ThemeMode _currentMode = ThemeMode.system;
  bool _userPrefersLight = false;
  Timer? _themeTimer;

  ThemeProvider(this._config) {
    _initialize();
  }

  // ── Public API ──────────────────────────────────────────────────────────

  ThemeMode get themeMode => _currentMode;

  /// True when dark mode is being enforced by the schedule rule.
  bool get isDarkModeEnforced => _isEnforcedHour(DateTime.now());

  /// True when the app is currently in dark mode for any reason.
  bool get isDarkMode => _currentMode == ThemeMode.dark;

  /// Human-readable label for the current theme state.
  String get themeStatusLabel {
    if (isDarkModeEnforced) {
      return 'Dark mode (auto — active until 6:00 AM)';
    }
    return _userPrefersLight ? 'Light mode' : 'Dark mode';
  }

  /// Attempts to set the theme. Silently enforces dark mode if currently in
  /// restricted hours — the UI should check [isDarkModeEnforced] before
  /// offering the toggle.
  Future<void> setTheme(ThemeMode requested) async {
    final now = DateTime.now();
    if (_isEnforcedHour(now)) {
      // Policy: cannot override during enforced hours.
      // Dark mode stays. Persist no preference change.
      _currentMode = ThemeMode.dark;
      notifyListeners();
      return;
    }

    _userPrefersLight = requested == ThemeMode.light;
    _currentMode = requested;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _userPrefersLight);

    notifyListeners();
  }

  /// Toggle between light and dark. Respects enforcement window.
  Future<void> toggleTheme() async {
    if (isDarkModeEnforced) return;
    await setTheme(_userPrefersLight ? ThemeMode.dark : ThemeMode.light);
  }

  // ── Private ─────────────────────────────────────────────────────────────

  Future<void> _initialize() async {
    // Load saved preference
    final prefs = await SharedPreferences.getInstance();
    _userPrefersLight = prefs.getBool(_prefKey) ?? false;

    // Apply correct mode based on current time
    _applyScheduleRule();

    // Re-evaluate every minute so the transition happens on the minute
    _themeTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _applyScheduleRule();
    });
  }

  void _applyScheduleRule() {
    final now = DateTime.now();
    if (_isEnforcedHour(now)) {
      if (_currentMode != ThemeMode.dark) {
        _currentMode = ThemeMode.dark;
        notifyListeners();
      }
    } else {
      final desired =
          _userPrefersLight ? ThemeMode.light : ThemeMode.dark;
      if (_currentMode != desired) {
        _currentMode = desired;
        notifyListeners();
      }
    }
  }

  /// Returns true if the current hour falls within the enforced dark window.
  /// Window: [darkModeStartHour, 24) ∪ [0, darkModeEndHour)
  /// With config defaults: [20, 24) ∪ [0, 6)
  bool _isEnforcedHour(DateTime time) {
    final hour = time.hour;
    final start = _config.darkModeStartHour; // 20
    final end = _config.darkModeEndHour;     // 6
    // Overnight window: start > end means it wraps midnight
    if (start > end) {
      return hour >= start || hour < end;
    }
    // Same-day window (e.g., 8–18)
    return hour >= start && hour < end;
  }

  @override
  void dispose() {
    _themeTimer?.cancel();
    super.dispose();
  }
}
