import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/status_item.dart';

class StatusProvider extends ChangeNotifier {
  final List<StatusItem> _statuses = [];
  final Set<String> _savedPaths = {};
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastSync;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastSync => _lastSync;
  List<StatusItem> get statuses => List.unmodifiable(_statuses);
  int get savedCount => _savedPaths.length;
  int get videoCount =>
      _statuses.where((status) => status.isVideo).length;
  bool isSaved(StatusItem status) => _savedPaths.contains(status.path);

  static const List<String> _supportedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.mp4',
    '.mov',
    '.webm',
    '.avi',
    '.mkv',
  ];

  static const List<String> _videoExtensions = [
    '.mp4',
    '.mov',
    '.webm',
    '.avi',
    '.mkv',
  ];

  Future<void> loadStatuses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final permissionGranted = await _requestStoragePermission();
      if (!permissionGranted) {
        _errorMessage =
            'Storage access is denied. Grant permissions to scan WhatsApp statuses.';
        return;
      }

      final directories = await _collectStatusDirectories();
      final foundStatuses = <StatusItem>[];

      for (final directory in directories) {
        if (!await directory.exists()) {
          continue;
        }

        await for (final entity in directory.list()) {
          if (entity is! File) {
            continue;
          }

          final extension = p.extension(entity.path).toLowerCase();
          if (!_supportedExtensions.contains(extension)) {
            continue;
          }

          final modified = await entity.lastModified();
          foundStatuses.add(StatusItem(
            name: p.basename(entity.path),
            path: entity.path,
            modifiedAt: modified,
            isVideo: _videoExtensions.contains(extension),
          ));
        }
      }

      foundStatuses.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      _statuses
        ..clear()
        ..addAll(foundStatuses);
      _lastSync = DateTime.now();
    } on FileSystemException catch (error) {
      _errorMessage = 'Unable to read statuses: ${error.message}';
    } catch (_) {
      _errorMessage = 'Something went wrong while scanning statuses.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> saveStatus(StatusItem status) async {
    final targetDir = await _buildSaveDirectory();
    final destination = File(p.join(targetDir.path, p.basename(status.path)));

    if (await destination.exists()) {
      _savedPaths.add(status.path);
      notifyListeners();
      return destination.path;
    }

    final savedFile = await File(status.path).copy(destination.path);
    _savedPaths.add(status.path);
    notifyListeners();
    return savedFile.path;
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      return true;
    }

    final permissionsToRequest = <Permission>[Permission.storage];

    if (await Permission.manageExternalStorage.isDenied ||
        await Permission.manageExternalStorage.isRestricted) {
      permissionsToRequest.add(Permission.manageExternalStorage);
    }

    final statuses = await permissionsToRequest.request();
    return statuses.values.any((status) => status.isGranted);
  }

  Future<List<Directory>> _collectStatusDirectories() async {
    if (!Platform.isAndroid) {
      return [];
    }

    const String base = '/storage/emulated/0';
    return [
      Directory('$base/WhatsApp/Media/.Statuses'),
      Directory('$base/WhatsApp Business/Media/.Statuses'),
      Directory('$base/Android/media/com.whatsapp/WhatsApp/Media/.Statuses'),
      Directory(
          '$base/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses'),
    ];
  }

  Future<Directory> _buildSaveDirectory() async {
    Directory baseDir;

    if (Platform.isAndroid) {
      baseDir = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    final targetDir = Directory(p.join(baseDir.path, 'StatusVault'));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    return targetDir;
  }
}
