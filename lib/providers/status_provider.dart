import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/status_file.dart';
import '../utils/permission_util.dart';

class StatusProvider with ChangeNotifier {
  List<StatusFile> _images = [];
  List<StatusFile> _videos = [];
  List<StatusFile> _savedStatuses = [];
  bool _isLoading = false;
  bool _permissionGranted = false;
  String _errorMessage = '';

  List<StatusFile> get images => _images;
  List<StatusFile> get videos => _videos;
  List<StatusFile> get savedStatuses => _savedStatuses;
  bool get isLoading => _isLoading;
  bool get permissionGranted => _permissionGranted;
  String get errorMessage => _errorMessage;

  // Paths for WhatsApp Statuses
  final List<String> _whatsappPaths = [
    '/storage/emulated/0/WhatsApp/Media/.Statuses',
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses',
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses',
    '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
  ];

  Future<void> init() async {
    _permissionGranted = await PermissionUtil.requestStoragePermission();
    if (_permissionGranted) {
      await fetchStatuses();
      await fetchSavedStatuses();
    } else {
      _errorMessage = 'Storage permission is required to view statuses.';
    }
    notifyListeners();
  }

  Future<void> requestPermission() async {
    _permissionGranted = await PermissionUtil.requestStoragePermission();
    if (_permissionGranted) {
      _errorMessage = '';
      await fetchStatuses();
      await fetchSavedStatuses();
    }
    notifyListeners();
  }

  Future<void> fetchStatuses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _images = [];
    _videos = [];

    for (String path in _whatsappPaths) {
      final directory = Directory(path);
      if (directory.existsSync()) {
        final items = directory.listSync();
        for (var item in items) {
          if (item is File) {
            if (item.path.endsWith('.mp4')) {
              _videos.add(StatusFile(path: item.path, isVideo: true));
            } else if (item.path.endsWith('.jpg') || item.path.endsWith('.jpeg') || item.path.endsWith('.png')) {
              _images.add(StatusFile(path: item.path, isVideo: false));
            }
          }
        }
      }
    }

    if (_images.isEmpty && _videos.isEmpty) {
      _errorMessage = 'No statuses found. Please view some statuses in WhatsApp first.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSavedStatuses() async {
    final directory = Directory('/storage/emulated/0/Pictures/StatusSaver');
    _savedStatuses = [];
    if (directory.existsSync()) {
      final items = directory.listSync();
      for (var item in items) {
        if (item is File && !item.path.contains('.nomedia')) {
          if (item.path.endsWith('.mp4')) {
            _savedStatuses.add(StatusFile(path: item.path, isVideo: true));
          } else if (item.path.endsWith('.jpg') || item.path.endsWith('.jpeg') || item.path.endsWith('.png')) {
            _savedStatuses.add(StatusFile(path: item.path, isVideo: false));
          }
        }
      }
    }
    notifyListeners();
  }

  Future<bool> saveStatus(String sourcePath) async {
    try {
      final directory = Directory('/storage/emulated/0/Pictures/StatusSaver');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      
      final fileName = sourcePath.split('/').last;
      final savedFilePath = '${directory.path}/$fileName';
      
      final sourceFile = File(sourcePath);
      await sourceFile.copy(savedFilePath);
      
      await fetchSavedStatuses(); // Refresh saved list
      return true;
    } catch (e) {
      return false;
    }
  }
}
