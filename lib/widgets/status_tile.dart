import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/status_item.dart';

class StatusTile extends StatelessWidget {
  final StatusItem status;
  final bool saved;
  final VoidCallback onSave;

  const StatusTile({
    super.key,
    required this.status,
    required this.saved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, MMM d').format(status.modifiedAt);

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(status.path),
                fit: BoxFit.cover,
                errorBuilder: (_, error, stackTrace) {
                  debugPrint('Status preview failed for ${status.name}: $error');
                  debugPrintStack(stackTrace: stackTrace);
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 48),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black54,
                    ],
                    stops: [0, 0.6, 1],
                  ),
                ),
              ),
            ),
            if (status.isVideo)
              const Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black45,
                  child: Icon(Icons.videocam, size: 20, color: Colors.white),
                ),
              ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: saved ? Colors.white70 : Colors.white,
                          foregroundColor: saved ? Colors.black87 : Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: saved ? null : onSave,
                        icon: Icon(
                          saved ? Icons.check_circle : Icons.download,
                          size: 18,
                        ),
                        label: Text(saved ? 'Saved' : 'Save'),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.isVideo ? 'Video' : 'Image',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
