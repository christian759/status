import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/status_provider.dart';
import '../widgets/status_grid_item.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    final vaultItems = _unlocked ? context.watch<StatusProvider>().vault : [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vault',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _unlocked ? 'Protected items appear below.' : 'Unlock vault with PIN or biometrics.',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          if (_unlocked)
            Expanded(
              child: vaultItems.isEmpty
                  ? const Center(child: Text('No private statuses yet.'))
                  : GridView.builder(
                      itemCount: vaultItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final status = vaultItems[index];
                        return StatusGridItem(
                          status: status,
                          onTap: () {},
                          onLongPress: () {},
                        );
                      },
                    ),
            )
          else
            const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _unlocked = !_unlocked;
              });
            },
            icon: const Icon(Icons.fingerprint),
            label: Text(_unlocked ? 'Lock Vault' : 'Unlock with PIN/biometrics'),
          ),
        ],
      ),
    );
  }
}
