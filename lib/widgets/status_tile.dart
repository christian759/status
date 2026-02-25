import 'package:flutter/material.dart';
import '../models/status_item.dart';

class StatusTile extends StatelessWidget {
  const StatusTile({
    super.key,
    required this.status,
    required this.onTap,
    required this.onSavePressed,
    required this.onVaultPressed,
  });

  final StatusItem status;
  final VoidCallback onTap;
  final VoidCallback onSavePressed;
  final VoidCallback onVaultPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  status.thumbnailUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: Icon(
                      status.mediaType == StatusMediaType.video ? Icons.play_circle : Icons.image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(status.contact, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    status.timestamp.toLocal().toIso8601String().split('T').first,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: onSavePressed,
                        icon: Icon(status.isSaved ? Icons.check : Icons.download),
                        label: Text(status.isSaved ? 'Saved' : 'Save'),
                      ),
                      IconButton(
                        onPressed: onVaultPressed,
                        icon: Icon(status.isVaulted ? Icons.lock_open : Icons.lock),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
