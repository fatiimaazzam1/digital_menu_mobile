import 'package:flutter/material.dart';

import '../data/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({required this.item, required this.onTap, super.key});

  final MenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: ValueKey('menu-item-${item.id}'),
        onTap: onTap,
        title: Text(item.name),
        subtitle: Text(item.displayNote),
        trailing: Text('\$${item.priceUsd.toStringAsFixed(2)}'),
      ),
    );
  }
}
