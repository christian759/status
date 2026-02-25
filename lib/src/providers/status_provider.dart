import 'package:flutter/material.dart';

import '../models/folder_model.dart';
import '../models/status_item.dart';

class StatusProvider extends ChangeNotifier {
  StatusProvider() {
    _initializeMockData();
  }

  final List<StatusItem> _detected = [];
  final List<FolderModel> _folders = [];
  final List<StatusItem> _vault = [];

  bool _autoDownloadEnabled = false;
  bool _expiryAlerts = false;
  bool _hasPro = false;

  List<StatusItem> get detectedStatuses => List.unmodifiable(_detected);
  List<FolderModel> get folders => List.unmodifiable(_folders);
  List<StatusItem> get vault => List.unmodifiable(_vault);

  bool get autoDownloadEnabled => _autoDownloadEnabled;
  bool get expiryAlerts => _expiryAlerts;
  bool get hasPro => _hasPro;

  void _initializeMockData() {
    final now = DateTime.now();
    _detected.addAll([
      StatusItem(
        id: 'status-1',
        contactName: 'Aisha Kumar',
        timestamp: now.subtract(const Duration(minutes: 20)),
        thumbnail: 'https://dummyimage.com/400x400/0f4c81/ffffff&text=Image+1',
        mediaType: MediaType.image,
        sourceApp: 'WhatsApp',
        filePath: '/storage/emulated/0/WhatsApp/Media/.Statuses/image_1.jpg',
        isSaved: true,
        folderId: 'folder-default-1',
      ),
      StatusItem(
        id: 'status-2',
        contactName: 'Mario Silva',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 5)),
        thumbnail: 'https://dummyimage.com/400x400/1d7a8c/ffffff&text=Video',
        mediaType: MediaType.video,
        sourceApp: 'WhatsApp',
        filePath: '/storage/emulated/0/WhatsApp/Media/.Statuses/video_2.mp4',
        isSaved: true,
        folderId: 'folder-default-2',
      ),
      StatusItem(
        id: 'status-3',
        contactName: 'TikTok Trends',
        timestamp: now.subtract(const Duration(hours: 2)),
        thumbnail: 'https://dummyimage.com/400x400/ab003c/ffffff&text=Image+3',
        mediaType: MediaType.image,
        sourceApp: 'WhatsApp',
        filePath: '/storage/emulated/0/WhatsApp/Media/.Statuses/image_3.jpg',
      ),
    ]);
    _folders.addAll([
      FolderModel(
        id: 'folder-default-1',
        name: 'Aisha Kumar · Today',
        contactName: 'Aisha Kumar',
        createdAt: now,
      ),
      FolderModel(
        id: 'folder-default-2',
        name: 'Mario Silva · Yesterday',
        contactName: 'Mario Silva',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  void toggleSave(StatusItem status, {String? folderId}) {
    final index = _detected.indexWhere((item) => item.id == status.id);
    if (index == -1) return;

    final updated = _detected[index];
    updated.isSaved = !updated.isSaved;
    updated.folderId = updated.isSaved ? (folderId ?? updated.folderId) : null;

    if (updated.isSaved) {
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void moveToVault(StatusItem status) {
    final index = _detected.indexWhere((item) => item.id == status.id);
    if (index == -1) return;

    final item = _detected[index];
    item.isVaulted = !item.isVaulted;
    if (item.isVaulted) {
      _vault.add(item);
    } else {
      _vault.removeWhere((vaultItem) => vaultItem.id == item.id);
    }
    notifyListeners();
  }

  void toggleAutoDownload(bool enabled) {
    _autoDownloadEnabled = enabled;
    notifyListeners();
  }

  void toggleExpiryAlerts(bool enabled) {
    _expiryAlerts = enabled;
    notifyListeners();
  }

  void unlockPro() {
    if (!_hasPro) {
      _hasPro = true;
      notifyListeners();
    }
  }

  void addFolder(FolderModel folder) {
    _folders.add(folder);
    notifyListeners();
  }
}
