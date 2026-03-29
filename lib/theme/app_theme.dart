import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color obsidian = Color(0xFF050505);
  static const Color graphite = Color(0xFF101010);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color cloudWhite = Color(0xFFF4F1DE);

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: obsidian,
      primaryColor: bronze,
      colorScheme: const ColorScheme.dark(
        primary: bronze,
        secondary: bronze,
        surface: graphite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: obsidian,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: bronze, size: 24),
        titleTextStyle: GoogleFonts.staatliches(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: bronze,
          letterSpacing: 2.0,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.staatliches(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          color: bronze,
          letterSpacing: 4.0,
        ),
        displayMedium: GoogleFonts.staatliches(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: cloudWhite,
          letterSpacing: 2.0,
          height: 1.1,
        ),
        headlineMedium: GoogleFonts.staatliches(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: bronze,
          letterSpacing: 1.5,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          color: cloudWhite,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: Colors.white60,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: bronze,
        unselectedLabelColor: Colors.white24,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.staatliches(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        unselectedLabelStyle: GoogleFonts.staatliches(fontSize: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bronze,
          foregroundColor: obsidian,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.staatliches(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
          elevation: 10,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white10,
        thickness: 2,
        space: 2,
      ),
    );
  }
}
