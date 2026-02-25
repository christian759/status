import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        const Text('StatusVault Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Backup / restore'),
          subtitle: const Text('Create a backup or restore from device storage.'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          subtitle: const Text('Toggle push alerts for detection and expiry.'),
          trailing: Switch(value: true, onChanged: (_) {}),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.upgrade),
          title: const Text('Upgrade to Pro'),
          subtitle: const Text('Unlock Auto-download and custom folders.'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('App version'),
          subtitle: const Text('1.0.0'),
        ),
      ],
    );
  }
}
