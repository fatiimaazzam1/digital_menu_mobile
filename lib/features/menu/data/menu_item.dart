class MenuItem {
  const MenuItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.displayNote,
    required this.priceUsd,
    required this.imageAssetPath,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String displayNote;
  final double priceUsd;

  /// Null until a verified, bundled menu image is available.
  final String? imageAssetPath;
}
