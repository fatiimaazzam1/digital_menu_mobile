import 'package:flutter/material.dart';

import '../data/menu_item.dart';

class MenuItemImage extends StatelessWidget {
  const MenuItemImage({
    required this.item,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });

  final MenuItem item;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        item.imageAssetPath,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: item.name,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Semantics(
            label: 'Image unavailable for ${item.name}',
            child: const Icon(Icons.image_not_supported_outlined),
          ),
        ),
      ),
    );
  }
}
