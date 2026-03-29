import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Swiss Minimalist Palette
  static const Color primaryColor = Color(0xFFE07A5F); // Burnt Sienna
  static const Color backgroundDark = Color(0xFF050505); // Inky Black
  static const Color surfaceDark = Color(0xFF101010); // Graphite
  static const Color textPrimary = Color(0xFFF4F1DE); // Cloud White
  static const Color textSecondary = Color(0xFF8D99AE); // Slate Grey

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: -1.5),
        displayMedium: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -1.0),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: textPrimary, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: textSecondary),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundDark,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sharpest
          ),
          textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
          elevation: 0,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white12,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
