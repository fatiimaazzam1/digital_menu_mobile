import 'package:flutter/material.dart';

import '../data/menu_repository.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({
    required this.repository,
    required this.itemId,
    super.key,
  });

  final MenuRepository repository;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    final item = repository.itemById(itemId);

    return Scaffold(
      appBar: AppBar(title: Text(item?.name ?? 'Item Details')),
      body: item == null
          ? const Center(child: Text('Menu item not found.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.imageAssetPath == null
                        ? 'Image pending verified menu assets'
                        : 'Image: ${item.imageAssetPath}',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('\$${item.priceUsd.toStringAsFixed(2)} USD'),
                const SizedBox(height: 16),
                Text(item.description),
                const SizedBox(height: 12),
                Text(item.displayNote),
              ],
            ),
    );
  }
}
