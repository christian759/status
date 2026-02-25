import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: Colors.black,
      elevation: 1.0,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    cardColor: AppColors.surface,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      selectedItemColor: AppColors.primary,
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accent,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent, brightness: Brightness.dark),
    cardColor: const Color(0xFF1E1E1E),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 10,
      selectedItemColor: Colors.white,
    ),
  );
}
