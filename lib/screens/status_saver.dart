import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/status_provider.dart';
import '../widgets/status_tile.dart';

class StatusSaverScreen extends StatelessWidget {
  const StatusSaverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = context.watch<StatusProvider>().detected;
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Status Saver'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing statuses... (stub)')),
              );
            },
          )
        ],
      ),
      body: statuses.isEmpty
          ? const Center(child: Text('No statuses detected yet.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: statuses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final status = statuses[index];
                return StatusTile(
                  status: status,
                  onTap: () {},
                  onSavePressed: () => context.read<StatusProvider>().toggleSave(status),
                  onVaultPressed: () => context.read<StatusProvider>().moveToVault(status),
                );
              },
            ),
    );
  }
}
