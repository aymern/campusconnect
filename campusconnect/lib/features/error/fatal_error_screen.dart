import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/config/app_config.dart';

/// Displayed instead of the normal app when [AppConfig] validation fails.
/// Per the assignment: "The app must crash or show a fatal error screen
/// if started with incorrect campus code or API version mismatch."
///
/// This screen:
///  - Cannot be dismissed
///  - Shows exactly which config field failed and why
///  - Blocks all other navigation
class FatalErrorScreen extends StatelessWidget {
  final ConfigValidationError error;

  const FatalErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    // Force status bar to match the error screen
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF1A0000),
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFF1A0000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0000).withOpacity(0.4),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFCF6679),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFCF6679),
                  size: 52,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'FATAL CONFIGURATION ERROR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFCF6679),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'CampusConnect cannot start',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFB0B0B0),
                ),
              ),
              const SizedBox(height: 40),

              // Error detail card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C0000),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B0000),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      label: 'FIELD',
                      value: error.field,
                      valueColor: const Color(0xFFFFAB91),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'EXPECTED',
                      value: error.expected,
                      valueColor: const Color(0xFF80CBC4),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'RECEIVED',
                      value: error.actual,
                      valueColor: const Color(0xFFCF6679),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Explanation
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'This application is exclusively configured for Group 5 '
                  '(CAM-PHX-05). The configuration constants are verified at '
                  'runtime. Incorrect values indicate tampering or cross-group '
                  'code use, which makes this build functionally incompatible.\n\n'
                  'Please restore the original config.json and rebuild.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Group stamp
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4A4A4A)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'GROUP 5 · CAM-PHX-05 · Phoenix Campus',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    color: Color(0xFF616161),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF757575),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
