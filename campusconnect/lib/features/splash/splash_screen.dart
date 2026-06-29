import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Displayed while [AppConfig] is loading and being validated at startup.
/// Uses only core Flutter widgets — no dependency on the config being loaded yet.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _pulseScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated logo mark
              ScaleTransition(
                scale: _pulseScale,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // App name
              const Text(
                'CampusConnect',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Campus identifier
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'CAM-PHX-05 · Phoenix Campus',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Loading indicator
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Verifying configuration…',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
