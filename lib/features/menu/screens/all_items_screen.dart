import 'package:flutter/material.dart';

import '../data/menu_repository.dart';
import '../widgets/menu_item_card.dart';
import 'item_detail_screen.dart';

class AllItemsScreen extends StatelessWidget {
  const AllItemsScreen({required this.repository, super.key});

  final MenuRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Items')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final item in repository.items)
            MenuItemCard(
              item: item,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ItemDetailScreen(
                      repository: repository,
                      itemId: item.id,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
