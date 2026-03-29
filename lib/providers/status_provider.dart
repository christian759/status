import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/status_file.dart';
import '../utils/permission_util.dart';

class StatusProvider with ChangeNotifier {
  List<StatusFile> _images = [];
  List<StatusFile> _videos = [];
  List<StatusFile> _savedStatuses = [];
  List<String> _selectedPaths = [];
  final Map<String, String> _thumbnailCache = {};
  bool _isLoading = false;
  bool _permissionGranted = false;
  String _errorMessage = '';

  List<StatusFile> get images => _images;
  List<StatusFile> get videos => _videos;
  List<StatusFile> get savedStatuses => _savedStatuses;
  List<String> get selectedPaths => _selectedPaths;
  bool get isLoading => _isLoading;
  bool get permissionGranted => _permissionGranted;
  String get errorMessage => _errorMessage;
  bool get isSelectionMode => _selectedPaths.isNotEmpty;

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
      // Background these so the UI can show immediately
      Future.wait([
        fetchStatuses(),
        fetchSavedStatuses(),
      ]);
    } else {
      _errorMessage = 'Storage permission is required to view statuses.';
    }
    notifyListeners();
  }


  Future<void> requestPermission() async {
    _permissionGranted = await PermissionUtil.requestStoragePermission();
    if (_permissionGranted) {
      _errorMessage = '';
      await Future.wait([
        fetchStatuses(),
        fetchSavedStatuses(),
      ]);
    }
    notifyListeners();
  }

  Future<void> fetchStatuses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _images = [];
    _videos = [];

    await Future.wait(_whatsappPaths.map((path) async {
      final directory = Directory(path);
      if (directory.existsSync()) {
        try {
          final items = directory.list();
          await for (var item in items) {
            if (item is File) {
              final fileName = item.path.toLowerCase();
              if (fileName.endsWith('.mp4')) {
                _videos.add(StatusFile(path: item.path, isVideo: true));
              } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png')) {
                _images.add(StatusFile(path: item.path, isVideo: false));
              }
            }
          }
        } catch (e) {
          debugPrint('Error listing directory $path: $e');
        }
      }
    }));


    if (_images.isEmpty && _videos.isEmpty) {
      _errorMessage = 'No statuses found. Please view some in WhatsApp first.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSavedStatuses() async {
    final directory = Directory('/storage/emulated/0/Pictures/StatusSaver');
    _savedStatuses = [];
    if (directory.existsSync()) {
      try {
        final items = directory.list();
        await for (var item in items) {
          if (item is File && !item.path.contains('.nomedia')) {
            final fileName = item.path.toLowerCase();
            if (fileName.endsWith('.mp4')) {
              _savedStatuses.add(StatusFile(path: item.path, isVideo: true));
            } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg') || fileName.endsWith('.png')) {
              _savedStatuses.add(StatusFile(path: item.path, isVideo: false));
            }
          }
        }
      } catch (e) {
        debugPrint('Error listing saved statuses: $e');
      }
    }
    notifyListeners();
  }

  Future<String?> getThumbnail(String videoPath) async {
    if (_thumbnailCache.containsKey(videoPath)) {
      return _thumbnailCache[videoPath];
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 256,
        quality: 50,
      );

      if (thumbnail != null) {
        _thumbnailCache[videoPath] = thumbnail;
        return thumbnail;
      }
    } catch (e) {
      debugPrint('Error generating thumbnail: $e');
    }
    return null;
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
      
      await fetchSavedStatuses();
      return true;
    } catch (e) {
      return false;
    }
  }

  void toggleSelection(String path) {
    if (_selectedPaths.contains(path)) {
      _selectedPaths.remove(path);
    } else {
      _selectedPaths.add(path);
    }
    notifyListeners();
  }

  bool isSelected(String path) {
    return _selectedPaths.contains(path);
  }

  void clearSelection() {
    _selectedPaths.clear();
    notifyListeners();
  }

  Future<int> saveMultipleStatuses() async {
    int savedCount = 0;
    _isLoading = true;
    notifyListeners();

    try {
      final directory = Directory('/storage/emulated/0/Pictures/StatusSaver');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      for (String path in _selectedPaths) {
        final fileName = path.split('/').last;
        final savedFilePath = '${directory.path}/$fileName';
        final sourceFile = File(path);
        if (sourceFile.existsSync()) {
          await sourceFile.copy(savedFilePath);
          savedCount++;
        }
      }
      
      _selectedPaths.clear();
      await fetchSavedStatuses();
    } catch (e) {
      debugPrint('Error saving multiple statuses: $e');
    }

    _isLoading = false;
    notifyListeners();
    return savedCount;
  }
}
