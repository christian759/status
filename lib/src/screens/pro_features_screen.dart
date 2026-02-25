import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/folder_model.dart';
import '../providers/status_provider.dart';

class ProFeaturesScreen extends StatefulWidget {
  const ProFeaturesScreen({super.key});

  @override
  State<ProFeaturesScreen> createState() => _ProFeaturesScreenState();
}

class _ProFeaturesScreenState extends State<ProFeaturesScreen> {
  final _folderController = TextEditingController();

  @override
  void dispose() {
    _folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatusProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        children: [
          const Text('Pro features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          SwitchListTile(
            value: provider.autoDownloadEnabled,
            onChanged: provider.hasPro ? provider.toggleAutoDownload : null,
            title: const Text('Auto-download new statuses'),
            subtitle: const Text('Detected statuses are saved automatically in background.'),
          ),
          SwitchListTile(
            value: provider.expiryAlerts,
            onChanged: provider.hasPro ? provider.toggleExpiryAlerts : null,
            title: const Text('Expiry alerts'),
            subtitle: const Text('Get notified when a saved status is about to expire.'),
          ),
          const SizedBox(height: 16),
          const Text('Folders', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (provider.hasPro)
            TextField(
              controller: _folderController,
              decoration: InputDecoration(
                labelText: 'Create custom folder',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_folderController.text.isEmpty) return;
                    provider.addFolder(
                      FolderModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        name: _folderController.text,
                        createdAt: DateTime.now(),
                      ),
                    );
                    _folderController.clear();
                  },
                ),
              ),
            )
          else
            const Text('Unlock Pro to create and manage custom folders.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: provider.hasPro ? null : provider.unlockPro,
            child: Text(provider.hasPro ? 'Pro enabled' : 'Upgrade to Pro'),
          ),
        ],
      ),
    );
  }
}
