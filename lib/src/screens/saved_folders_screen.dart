import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/status_item.dart';
import '../providers/status_provider.dart';
import '../widgets/status_grid_item.dart';

class SavedFoldersScreen extends StatefulWidget {
  const SavedFoldersScreen({super.key});

  @override
  State<SavedFoldersScreen> createState() => _SavedFoldersScreenState();
}

class _SavedFoldersScreenState extends State<SavedFoldersScreen> {
  String? _focusFolderId;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(
      builder: (context, provider, _) {
        final folderList = provider.folders;
        final filteredList = folderList
            .where((folder) => folder.name.toLowerCase().contains(_searchTerm.toLowerCase()))
            .toList();

        final savedStatuses = provider.detectedStatuses.where((status) => status.isSaved).toList();
        final visibleStatuses = _focusFolderId == null
            ? savedStatuses
            : savedStatuses.where((status) => status.folderId == _focusFolderId).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search folders or contacts',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() {
                  _searchTerm = value;
                }),
              ),
              const SizedBox(height: 12),
              const Text('Folders', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final folder = filteredList[index];
                    final count = savedStatuses.where((status) => status.folderId == folder.id).length;
                    final selected = folder.id == _focusFolderId;
                    return ListTile(
                      tileColor: selected ? const Color(0x1A2196F3) : null,
                      leading: const Icon(Icons.folder),
                      title: Text(folder.name),
                      subtitle: Text('$count saved statuses'),
                      trailing: selected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                      onTap: () => setState(() {
                        _focusFolderId = selected ? null : folder.id;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Text('Saved statuses', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: visibleStatuses.isEmpty
                    ? const Center(child: Text('No statuses to show in this folder.'))
                    : GridView.builder(
                        itemCount: visibleStatuses.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final status = visibleStatuses[index];
                          return StatusGridItem(
                            status: status,
                            onTap: () {},
                            onLongPress: () => _showActionMenu(context, status),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showActionMenu(BuildContext context, StatusItem status) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_move),
                title: const Text('Move to folder'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
