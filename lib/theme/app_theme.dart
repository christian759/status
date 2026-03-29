import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Tactical Colors
  static const Color primaryColor = Color(0xFFFE5000); // Tactical Orange
  static const Color primaryDark = Color(0xFFCC4000);
  static const Color accentColor = Color(0xFF00BFA5); // Tactical Teal (secondary)

  // Background Colors (Matte Stealth)
  static const Color backgroundDark = Color(0xFF000000); // Pure Black
  static const Color surfaceDark = Color(0xFF0A0A0A); // Matte Black
  static const Color surfaceLight = Color(0xFF111111);

  // Text Colors (High Contrast)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        centerTitle: false, // Tactical aligned
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
        titleTextStyle: GoogleFonts.shareTechMono(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          letterSpacing: 2.0,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.shareTechMono(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
        displayMedium: GoogleFonts.shareTechMono(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
        bodyLarge: GoogleFonts.jetBrainsMono(fontSize: 14, color: textPrimary, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.jetBrainsMono(fontSize: 12, color: textSecondary),
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.shareTechMono(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.shareTechMono(fontSize: 14, fontWeight: FontWeight.normal),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Tactical sharp
            side: const BorderSide(color: primaryColor, width: 2),
          ),
          textStyle: GoogleFonts.shareTechMono(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          elevation: 0,
        ),
      ),
    );
  }
}
