import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color pureBlack = Color(0xFF000000);
  static const Color charcoal = Color(0xFF121212);
  static const Color electricOrange = Color(0xFFFF6B00);
  static const Color pureWhite = Color(0xFFFFFFFF);

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: pureBlack,
      primaryColor: electricOrange,
      colorScheme: const ColorScheme.dark(
        primary: electricOrange,
        secondary: electricOrange,
        surface: charcoal,
        onSurface: pureWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pureBlack,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: pureWhite, size: 24),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: pureWhite,
          letterSpacing: 1.0,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: pureWhite,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: pureWhite,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: electricOrange,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: pureWhite,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: electricOrange,
        unselectedLabelColor: Colors.white24,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: electricOrange,
          foregroundColor: pureBlack,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
          elevation: 0,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white10,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
