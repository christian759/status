class StatusItem {
  final String name;
  final String path;
  final DateTime modifiedAt;
  final bool isVideo;

  const StatusItem({
    required this.name,
    required this.path,
    required this.modifiedAt,
    required this.isVideo,
  });
}
