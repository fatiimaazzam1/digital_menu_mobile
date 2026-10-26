import 'package:flutter/material.dart';

import '../data/menu_repository.dart';
import '../widgets/menu_item_image.dart';

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
    String? categoryName;
    if (item != null) {
      for (final category in repository.categories) {
        if (category.id == item.categoryId) {
          categoryName = category.name;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(item?.name ?? 'Item Details')),
      body: item == null
          ? const Center(child: Text('Menu item not found.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                MenuItemImage(item: item, height: 240),
                const SizedBox(height: 20),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (categoryName != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(label: Text(categoryName)),
                  ),
                ],
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
