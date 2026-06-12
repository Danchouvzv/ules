import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UlesColors {
  static const primary = Color(0xFF0A84FF);
  static const electric = Color(0xFF3B82F6);
  static const lime = Color(0xFF84CC16);
  static const green = Color(0xFF34C759);
  static const danger = Color(0xFFFF3B30);
  static const lightBg = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const glass = Color(0xCCFFFFFF);
  static const darkBg = Color(0xFF0D0D14);
  static const darkCard = Color(0xFF1A1A24);
  static const ink = Color(0xFF0B1220);
  static const muted = Color(0xFF667085);
  static const hairline = Color(0xFFDDE3EA);
  static const softBlue = Color(0xFFE8F3FF);
  static const softGreen = Color(0xFFE9FBEF);
  static const canvas = Color(0xFFF3F6FA);
  static const elevated = Color(0xFFFFFFFF);
  static const slate = Color(0xFF182235);
  static const amber = Color(0xFFFFB020);
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
        surface: isDark ? UlesColors.darkCard : UlesColors.lightCard,
      ),
    );
    final text = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: isDark ? UlesColors.darkBg : UlesColors.canvas,
      textTheme: text.apply(
        bodyColor: isDark ? Colors.white : UlesColors.ink,
        displayColor: isDark ? Colors.white : UlesColors.ink,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: isDark ? UlesColors.darkCard : UlesColors.lightCard,
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
          backgroundColor: UlesColors.ink,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle:
              GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(.06)
            : Colors.white.withOpacity(.75),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
                color: isDark ? Colors.white12 : UlesColors.hairline)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide:
                const BorderSide(color: UlesColors.primary, width: 1.4)),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
      ),
    );
  }
}

class Glass extends StatelessWidget {
  const Glass({
    required this.child,
    this.padding,
    this.radius = 24,
    this.opacity,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: isDark ? 18 : 4, sigmaY: isDark ? 18 : 4),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(opacity ?? .08)
                : UlesColors.elevated.withOpacity(opacity ?? 1),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color:
                  isDark ? Colors.white.withOpacity(.12) : UlesColors.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? .22 : .06),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class IosPageBackground extends StatelessWidget {
  const IosPageBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), UlesColors.canvas],
        ),
      ),
      child: child,
    );
  }
}
