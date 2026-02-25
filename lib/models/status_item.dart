enum StatusMediaType { image, video }

class StatusItem {
  StatusItem({
    required this.id,
    required this.contact,
    required this.timestamp,
    required this.mediaType,
    required this.thumbnailUrl,
    required this.filePath,
    this.isSaved = false,
    this.isVaulted = false,
    this.folder = 'Detected',
  });

  final String id;
  final String contact;
  final DateTime timestamp;
  final StatusMediaType mediaType;
  final String thumbnailUrl;
  final String filePath;
  bool isSaved;
  bool isVaulted;
  String folder;
}
