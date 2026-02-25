import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import 'pro_features_screen.dart';
import 'saved_folders_screen.dart';
import 'settings_screen.dart';
import 'status_feed_screen.dart';
import 'vault_screen.dart';

class StatusVaultHome extends StatefulWidget {
  const StatusVaultHome({super.key});

  @override
  State<StatusVaultHome> createState() => _StatusVaultHomeState();
}

class _StatusVaultHomeState extends State<StatusVaultHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    StatusFeedScreen(),
    SavedFoldersScreen(),
    VaultScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    AppStrings.homeTitle,
    AppStrings.savedTitle,
    AppStrings.vaultTitle,
    AppStrings.settingsTitle,
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLinkDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Download from link'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Instagram / X / TikTok share URL'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download queued for link.')),
                );
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  void _openProScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProFeaturesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search placeholder')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pro') {
                _openProScreen();
              } else if (value == 'links') {
                _showLinkDialog();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'links', child: Text('Download from link')),
              PopupMenuItem(value: 'pro', child: Text('Auto rules / Pro')),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showLinkDialog,
        child: const Icon(Icons.link),
      ),
    );
  }
}
