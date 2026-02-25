import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/status_item.dart';
import '../providers/status_provider.dart';
import '../widgets/status_grid_item.dart';

class StatusFeedScreen extends StatelessWidget {
  const StatusFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, provider, _) {
        final statuses = provider.detectedStatuses;
        if (statuses.isEmpty) {
          return const Center(child: Text('No statuses detected yet.'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GridView.builder(
            itemCount: statuses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final status = statuses[index];
              return StatusGridItem(
                status: status,
                onTap: () => _showPreview(context, status),
                onLongPress: () => _showActionSheet(context, status),
              );
            },
          ),
        );
      },
    );
  }

  void _showPreview(BuildContext context, StatusItem status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(status.contactName),
          content: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.network(
              status.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showActionSheet(BuildContext context, StatusItem status) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Save to folder'),
                onTap: () {
                  Provider.of<StatusProvider>(context, listen: false)
                      .toggleSave(status);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(status.isVaulted ? 'Remove from Vault' : 'Save to Vault'),
                onTap: () {
                  Provider.of<StatusProvider>(context, listen: false)
                      .moveToVault(status);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share status'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing is not implemented yet.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
