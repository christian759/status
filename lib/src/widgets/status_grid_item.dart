import 'package:flutter/material.dart';

import '../models/status_item.dart';

class StatusGridItem extends StatelessWidget {
  const StatusGridItem({
    super.key,
    required this.status,
    required this.onTap,
    required this.onLongPress,
  });

  final StatusItem status;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final borderColor = status.isSaved ? Colors.green : Colors.transparent;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                status.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      status.isVideo ? Icons.play_circle_fill : Icons.image,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x99000000),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.contactName,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
            if (status.isVaulted)
              const Positioned(
                bottom: 8,
                left: 8,
                child: Icon(Icons.lock, size: 18, color: Colors.white),
              )
          ],
        ),
      ),
    );
  }
}
