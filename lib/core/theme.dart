import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UlesColors {
  static const primary = Color(0xFF4F46E5);
  static const electric = Color(0xFF3D5AFE);
  static const lime = Color(0xFFA3E635);
  static const green = Color(0xFF00E676);
  static const danger = Color(0xFFFF4D5E);
  static const lightBg = Color(0xFFFAFAFA);
  static const darkBg = Color(0xFF0D0D14);
  static const darkCard = Color(0xFF1A1A24);
  static const ink = Color(0xFF1A1A1A);
  static const muted = Color(0xFF6B7280);
}

class UlesTheme {
  static ThemeData dark() => _theme(Brightness.dark);
  static ThemeData light() => _theme(Brightness.light);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: UlesColors.primary,
        brightness: brightness,
        primary: UlesColors.primary,
        secondary: UlesColors.green,
        surface: isDark ? UlesColors.darkCard : Colors.white,
      ),
    );
    final text = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: isDark ? UlesColors.darkBg : UlesColors.lightBg,
      textTheme: text.apply(
        bodyColor: isDark ? Colors.white : UlesColors.ink,
        displayColor: isDark ? Colors.white : UlesColors.ink,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? UlesColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : UlesColors.ink,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : UlesColors.ink,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: UlesColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
      ),
    );
  }
}

class Glass extends StatelessWidget {
  const Glass({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withOpacity(isDark ? .08 : .04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(isDark ? .12 : .5)),
          ),
          child: child,
        ),
      ),
    );
  }
}
