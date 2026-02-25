enum MediaType { image, video }

class StatusItem {
  StatusItem({
    required this.id,
    required this.contactName,
    required this.timestamp,
    required this.thumbnail,
    required this.mediaType,
    required this.sourceApp,
    required this.filePath,
    this.isSaved = false,
    this.folderId,
    this.isVaulted = false,
  });

  final String id;
  final String contactName;
  final DateTime timestamp;
  final String thumbnail;
  final MediaType mediaType;
  final String sourceApp;
  final String filePath;
  String? folderId;
  bool isSaved;
  bool isVaulted;

  bool get isVideo => mediaType == MediaType.video;
}
