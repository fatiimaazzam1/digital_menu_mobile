import 'package:flutter/material.dart';

import '../data/menu_repository.dart';
import '../widgets/menu_item_card.dart';
import 'all_items_screen.dart';
import 'item_detail_screen.dart';

class MenuHomeScreen extends StatefulWidget {
  const MenuHomeScreen({required this.repository, super.key});

  final MenuRepository repository;

  @override
  State<MenuHomeScreen> createState() => _MenuHomeScreenState();
}

class _MenuHomeScreenState extends State<MenuHomeScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final visibleItems = _selectedCategoryId == null
        ? widget.repository.items
        : widget.repository.itemsForCategory(_selectedCategoryId!);

    return Scaffold(
      appBar: AppBar(title: const Text('Digital Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Categories', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _categoryChip(
                label: 'All',
                categoryId: null,
                isSelected: _selectedCategoryId == null,
              ),
              for (final category in widget.repository.categories)
                _categoryChip(
                  label: category.name,
                  categoryId: category.id,
                  isSelected: _selectedCategoryId == category.id,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              key: const Key('open-all-items'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        AllItemsScreen(repository: widget.repository),
                  ),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('All Items'),
            ),
          ),
          const SizedBox(height: 8),
          for (final item in visibleItems)
            MenuItemCard(
              item: item,
              onTap: () => _openItemDetails(context, item.id),
            ),
        ],
      ),
    );
  }

  Widget _categoryChip({
    required String label,
    required String? categoryId,
    required bool isSelected,
  }) {
    return FilterChip(
      key: Key('category-${categoryId ?? 'all'}'),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedCategoryId = categoryId;
        });
      },
    );
  }

  void _openItemDetails(BuildContext context, String itemId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ItemDetailScreen(repository: widget.repository, itemId: itemId),
      ),
    );
  }
}
