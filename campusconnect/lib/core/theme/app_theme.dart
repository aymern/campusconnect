import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Group 5 color palette
/// Primary:   #E65100 (Deep Orange — Phoenix desert heat)
/// Secondary: #2979FF (Blue — sky contrast)
class AppColors {
  AppColors._();

  // Primary — Deep Orange
  static const Color primary = Color(0xFFE65100);
  static const Color primaryLight = Color(0xFFFF833A);
  static const Color primaryDark = Color(0xFFAC1900);
  static const Color onPrimary = Colors.white;

  // Secondary — Blue
  static const Color secondary = Color(0xFF2979FF);
  static const Color secondaryLight = Color(0xFF75A7FF);
  static const Color secondaryDark = Color(0xFF004ECB);
  static const Color onSecondary = Colors.white;

  // Surface — Light mode
  static const Color surfaceLight = Color(0xFFFFFBF8);
  static const Color surfaceVariantLight = Color(0xFFFBE9E7);
  static const Color backgroundLight = Color(0xFFFFF8F5);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);

  // Surface — Dark mode
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color onSurfaceDark = Color(0xFFECECEC);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);

  // Semantic
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF00897B);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF0288D1);

  // Dividers
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2C2C2C);
}

class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Roboto';

  // ── Light Theme ────────────────────────────────────────────────────────

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: Colors.white,
      tertiary: AppColors.success,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFB2DFDB),
      onTertiaryContainer: const Color(0xFF004D40),
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6),
      onErrorContainer: const Color(0xFF410002),
      background: AppColors.backgroundLight,
      onBackground: AppColors.onSurfaceLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceVariant: AppColors.surfaceVariantLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight,
      outline: const Color(0xFF79747E),
      outlineVariant: const Color(0xFFCAC4D0),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: const Color(0xFF313033),
      onInverseSurface: const Color(0xFFF4EFF4),
      inversePrimary: AppColors.primaryLight,
      surfaceTint: AppColors.primary,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // ── Dark Theme ─────────────────────────────────────────────────────────

  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: Colors.black,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondaryLight,
      onSecondary: Colors.black,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: Colors.white,
      tertiary: const Color(0xFF4DB6AC),
      onTertiary: Colors.black,
      tertiaryContainer: const Color(0xFF004D40),
      onTertiaryContainer: const Color(0xFFB2DFDB),
      error: const Color(0xFFCF6679),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      background: AppColors.backgroundDark,
      onBackground: AppColors.onSurfaceDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceVariant: AppColors.surfaceVariantDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      outline: const Color(0xFF938F99),
      outlineVariant: const Color(0xFF49454F),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: const Color(0xFFE6E1E5),
      onInverseSurface: const Color(0xFF313033),
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primaryLight,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ── Shared build logic ─────────────────────────────────────────────────

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _fontFamily,
      brightness: brightness,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor:
            isLight ? AppColors.primary : AppColors.surfaceVariantDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isLight ? Brightness.light : Brightness.light,
          statusBarBrightness:
              isLight ? Brightness.dark : Brightness.dark,
        ),
        titleTextStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.15,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            isLight ? AppColors.surfaceLight : AppColors.surfaceVariantDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor:
            isLight ? AppColors.onSurfaceVariantLight : AppColors.onSurfaceVariantDark,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? AppColors.surfaceVariantLight
            : AppColors.surfaceVariantDark,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: isLight
              ? AppColors.onSurfaceVariantLight
              : AppColors.onSurfaceVariantDark,
        ),
        hintStyle: TextStyle(
          color: isLight
              ? AppColors.onSurfaceVariantLight.withOpacity(0.6)
              : AppColors.onSurfaceVariantDark.withOpacity(0.6),
        ),
      ),

      // Card
      cardTheme: CardTheme(
        elevation: isLight ? 1 : 4,
        color: isLight ? AppColors.surfaceLight : AppColors.surfaceVariantDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: isLight
            ? AppColors.surfaceVariantLight
            : AppColors.surfaceVariantDark,
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: const TextStyle(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Text Theme
      textTheme: _buildTextTheme(isLight),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor:
            isLight ? AppColors.surfaceLight : AppColors.surfaceVariantDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isLight ? AppColors.onSurfaceLight : AppColors.onSurfaceDark,
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            isLight ? const Color(0xFF323232) : AppColors.surfaceVariantDark,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: _fontFamily,
        ),
        actionTextColor: AppColors.primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(bool isLight) {
    final baseColor =
        isLight ? AppColors.onSurfaceLight : AppColors.onSurfaceDark;
    final subtleColor = isLight
        ? AppColors.onSurfaceVariantLight
        : AppColors.onSurfaceVariantDark;

    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 57,
          fontWeight: FontWeight.w300,
          color: baseColor,
          letterSpacing: -0.25),
      displayMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 45,
          fontWeight: FontWeight.w300,
          color: baseColor),
      displaySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: baseColor),
      headlineLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: baseColor),
      headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: baseColor),
      headlineSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: baseColor),
      titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: baseColor,
          letterSpacing: 0.15),
      titleMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: baseColor,
          letterSpacing: 0.15),
      titleSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: baseColor,
          letterSpacing: 0.1),
      bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: baseColor,
          letterSpacing: 0.5),
      bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: baseColor,
          letterSpacing: 0.25),
      bodySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: subtleColor,
          letterSpacing: 0.4),
      labelLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: baseColor,
          letterSpacing: 1.25),
      labelMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: subtleColor,
          letterSpacing: 1.5),
      labelSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: subtleColor,
          letterSpacing: 1.5),
    );
  }
}
