import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData data = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade50,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.white,
      elevation: 1,
    ),
  );
}
