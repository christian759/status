import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/status_provider.dart';
import 'screens/home_screen.dart';
import 'screens/permission_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatusProvider()),
      ],
      child: const StatusSaverApp(),
    ),
  );
}

class StatusSaverApp extends StatefulWidget {
  const StatusSaverApp({super.key});

  @override
  State<StatusSaverApp> createState() => _StatusSaverAppState();
}

class _StatusSaverAppState extends State<StatusSaverApp> {
  @override
  void initState() {
    super.initState();
    // Initialize provider when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StatusProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Status Saver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(),
      home: Consumer<StatusProvider>(
        builder: (context, provider, child) {
          // While checking permission, show a loader or directly the permission screen
          // If true, show HomeScreen, else PermissionScreen
          return provider.permissionGranted ? const HomeScreen() : const PermissionScreen();
        },
      ),
    );
  }
}
