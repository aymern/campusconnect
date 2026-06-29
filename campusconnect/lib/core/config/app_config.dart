import 'dart:convert';
import 'package:flutter/services.dart';

/// Immutable configuration loaded from assets/data/config.json.
/// All Group 5 parameters are validated here before the app proceeds.
class AppConfig {
  // ── Required Group 5 constants ──────────────────────────────────────────
  static const String _expectedCampusCode = 'CAM-PHX-05';
  static const String _expectedApiVersion = 'v2';
  static const String _expectedApiBasePath = '/api/v2/phx/';

  // ── Parsed fields ───────────────────────────────────────────────────────
  final String campusCode;
  final int groupNumber;
  final String primaryColor;
  final String secondaryColor;
  final String apiBasePath;
  final String apiVersion;
  final String campusName;
  final String campusTimezone;
  final String uniqueConstraint;
  final List<String> featureModules;
  final int maxConcurrentChats;
  final int darkModeStartHour;
  final int darkModeEndHour;
  final List<String> buildings;
  final int emergencyCountdownSeconds;
  final int marketplaceTransactionFeePercent;
  final List<String> marketplaceProhibitedItems;
  final Map<String, dynamic> schedulingConflictRules;
  final String beaconUuidPrefix;

  const AppConfig._({
    required this.campusCode,
    required this.groupNumber,
    required this.primaryColor,
    required this.secondaryColor,
    required this.apiBasePath,
    required this.apiVersion,
    required this.campusName,
    required this.campusTimezone,
    required this.uniqueConstraint,
    required this.featureModules,
    required this.maxConcurrentChats,
    required this.darkModeStartHour,
    required this.darkModeEndHour,
    required this.buildings,
    required this.emergencyCountdownSeconds,
    required this.marketplaceTransactionFeePercent,
    required this.marketplaceProhibitedItems,
    required this.schedulingConflictRules,
    required this.beaconUuidPrefix,
  });

  /// Loads config from the bundled asset file.
  /// Returns [AppConfigLoadResult] containing either a valid [AppConfig]
  /// or a [ConfigValidationError] with a human-readable reason.
  static Future<AppConfigLoadResult> load() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/config.json');
      final Map<String, dynamic> json = jsonDecode(jsonString);

      final config = AppConfig._(
        campusCode: json['campus_code'] as String? ?? '',
        groupNumber: json['group_number'] as int? ?? 0,
        primaryColor: json['primary_color'] as String? ?? '',
        secondaryColor: json['secondary_color'] as String? ?? '',
        apiBasePath: json['api_base_path'] as String? ?? '',
        apiVersion: json['api_version'] as String? ?? '',
        campusName: json['campus_name'] as String? ?? '',
        campusTimezone: json['campus_timezone'] as String? ?? '',
        uniqueConstraint: json['unique_constraint'] as String? ?? '',
        featureModules:
            List<String>.from(json['feature_modules'] as List? ?? []),
        maxConcurrentChats: json['max_concurrent_chats'] as int? ?? 5,
        darkModeStartHour: json['dark_mode_start_hour'] as int? ?? 20,
        darkModeEndHour: json['dark_mode_end_hour'] as int? ?? 6,
        buildings: List<String>.from(json['buildings'] as List? ?? []),
        emergencyCountdownSeconds:
            json['emergency_countdown_seconds'] as int? ?? 20,
        marketplaceTransactionFeePercent:
            json['marketplace_transaction_fee_percent'] as int? ?? 3,
        marketplaceProhibitedItems: List<String>.from(
            json['marketplace_prohibited_items'] as List? ?? []),
        schedulingConflictRules: Map<String, dynamic>.from(
            json['scheduling_conflict_rules'] as Map? ?? {}),
        beaconUuidPrefix: json['beacon_uuid_prefix'] as String? ?? '',
      );

      final validationError = config._validate();
      if (validationError != null) {
        return AppConfigLoadResult.failure(validationError);
      }

      return AppConfigLoadResult.success(config);
    } catch (e) {
      return AppConfigLoadResult.failure(
        ConfigValidationError(
          field: 'config_file',
          expected: 'Valid JSON at assets/data/config.json',
          actual: e.toString(),
        ),
      );
    }
  }

  /// Validates all critical fields. Returns null if valid, error otherwise.
  ConfigValidationError? _validate() {
    if (campusCode != _expectedCampusCode) {
      return ConfigValidationError(
        field: 'campus_code',
        expected: _expectedCampusCode,
        actual: campusCode,
      );
    }

    if (apiVersion != _expectedApiVersion) {
      return ConfigValidationError(
        field: 'api_version',
        expected: _expectedApiVersion,
        actual: apiVersion,
      );
    }

    if (apiBasePath != _expectedApiBasePath) {
      return ConfigValidationError(
        field: 'api_base_path',
        expected: _expectedApiBasePath,
        actual: apiBasePath,
      );
    }

    if (groupNumber != 5) {
      return ConfigValidationError(
        field: 'group_number',
        expected: '5',
        actual: groupNumber.toString(),
      );
    }

    return null; // All good
  }

  /// Full API base URL — used by the HTTP layer.
  String get fullApiBaseUrl => 'https://api.campusconnect.edu$apiBasePath';

  @override
  String toString() =>
      'AppConfig(campusCode: $campusCode, apiBasePath: $apiBasePath)';
}

// ── Result type ─────────────────────────────────────────────────────────────

class AppConfigLoadResult {
  final AppConfig? config;
  final ConfigValidationError? error;
  final bool isSuccess;

  const AppConfigLoadResult._({
    this.config,
    this.error,
    required this.isSuccess,
  });

  factory AppConfigLoadResult.success(AppConfig config) =>
      AppConfigLoadResult._(config: config, isSuccess: true);

  factory AppConfigLoadResult.failure(ConfigValidationError error) =>
      AppConfigLoadResult._(error: error, isSuccess: false);
}

// ── Validation error ─────────────────────────────────────────────────────────

class ConfigValidationError {
  final String field;
  final String expected;
  final String actual;

  const ConfigValidationError({
    required this.field,
    required this.expected,
    required this.actual,
  });

  String get message =>
      'Configuration mismatch in "$field".\n'
      'Expected: $expected\n'
      'Received: $actual\n\n'
      'This application is configured for Group 5 (CAM-PHX-05) only. '
      'Attempting to run with incorrect parameters is not permitted.';

  @override
  String toString() => 'ConfigValidationError($field: $actual != $expected)';
}
