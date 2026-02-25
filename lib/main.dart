import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/status_provider.dart';
import 'screens/status_saver.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const StatusVaultApp());
}

class StatusVaultApp extends StatelessWidget {
  const StatusVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatusProvider(),
      child: MaterialApp(
        title: 'WhatsApp Status Saver',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.data,
        home: const StatusSaverScreen(),
      ),
    );
  }
}
