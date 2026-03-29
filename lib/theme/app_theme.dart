import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFFD32F2F); // Bold Crimson
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color accentColor = Color(0xFFFF5252);

  // Background Colors (Dark Theme focus)
  static const Color backgroundDark = Color(0xFF000000); // Pitch Black
  static const Color surfaceDark = Color(0xFF121212); // Deep Charcoal
  static const Color surfaceLight = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);

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
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w900, // Extra bold
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w900, color: textPrimary),
        displayMedium: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w800, color: textPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: textPrimary, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: textSecondary),
      ),
      tabBarTheme: TabBarTheme(
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        labelStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Sharper edges for bold look
          ),
          textStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
          elevation: 0,
        ),
      ),
    );
  }
}
