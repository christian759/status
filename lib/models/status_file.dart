class StatusFile {
  final String path;
  final bool isVideo;

  StatusFile({
    required this.path,
    required this.isVideo,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusFile && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}
