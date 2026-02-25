class FolderModel {
  const FolderModel({
    required this.id,
    required this.name,
    this.contactName,
    required this.createdAt,
    this.isProOnly = false,
  });

  final String id;
  final String name;
  final String? contactName;
  final DateTime createdAt;
  final bool isProOnly;
}
