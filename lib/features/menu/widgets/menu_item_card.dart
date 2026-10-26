import 'package:flutter/material.dart';

import '../data/menu_item.dart';
import 'menu_item_image.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    required this.item,
    required this.onTap,
    this.isGrid = false,
    super.key,
  });

  final MenuItem item;
  final VoidCallback onTap;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('menu-item-${item.id}'),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: MenuItemImage(item: item),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF172034),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.displayNote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF73788A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.priceUsd.toStringAsFixed(2)} USD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF1D3764),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        key: ValueKey('menu-item-${item.id}'),
        onTap: onTap,
        leading: MenuItemImage(item: item, width: 64, height: 64),
        title: Text(item.name),
        subtitle: Text(item.displayNote),
        trailing: Text(
          '\$${item.priceUsd.toStringAsFixed(2)} USD',
          style: const TextStyle(
            color: Color(0xFF1D3764),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
