import 'package:flutter/material.dart';

import '../models/status_item.dart';

class StatusProvider extends ChangeNotifier {
  StatusProvider() {
    _seedDetectedStatuses();
  }

  final List<StatusItem> _detected = [];
  final List<StatusItem> _vault = [];

  List<StatusItem> get detected => List.unmodifiable(_detected);
  List<StatusItem> get saved => _detected.where((item) => item.isSaved).toList();
  List<StatusItem> get vault => List.unmodifiable(_vault);

  void _seedDetectedStatuses() {
    final now = DateTime.now();
    _detected.addAll(List.generate(6, (index) {
      final isVideo = index % 3 == 0;
      return StatusItem(
        id: 'status_$index',
        contact: 'Contact ${index + 1}',
        timestamp: now.subtract(Duration(minutes: 5 * index)),
        mediaType: isVideo ? StatusMediaType.video : StatusMediaType.image,
        thumbnailUrl:
            'https://dummyimage.com/450/1a1a1a/ffffff&text=${isVideo ? 'Video' : 'Image'}+${index + 1}',
        filePath: '/storage/WhatsApp/Statuses/status_$index.${isVideo ? 'mp4' : 'jpg'}',
      );
    }));
  }

  void toggleSave(StatusItem item) {
    item.isSaved = !item.isSaved;
    if (!item.isSaved) {
      item.folder = 'Detected';
    } else {
      item.folder = 'Saved ${item.contact}';
    }
    notifyListeners();
  }

  void moveToVault(StatusItem item) {
    if (item.isVaulted) {
      item.isVaulted = false;
      _vault.removeWhere((vaultItem) => vaultItem.id == item.id);
    } else {
      item.isVaulted = true;
      _vault.add(item);
    }
    notifyListeners();
  }
}
