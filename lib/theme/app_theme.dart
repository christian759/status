import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF4B3EFF);
  static const Color primaryAccent = Color(0xFF3dd8ff);
  static const Color background = Color(0xFFF4F7FB);
  static const Color surface = Colors.white;

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF3B2EFF), Color(0xFF17D8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData data = ThemeData(
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primaryAccent,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Colors.black45,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  );
}
