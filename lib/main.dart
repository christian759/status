import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/providers/status_provider.dart';
import 'src/screens/status_vault_home.dart';
import 'src/theme/app_theme.dart';

void main() {
  runApp(const StatusVaultApp());
}

class StatusVaultApp extends StatelessWidget {
  const StatusVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StatusProvider())],
      child: MaterialApp(
        title: 'StatusVault',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const StatusVaultHome(),
      ),
    );
  }
}
