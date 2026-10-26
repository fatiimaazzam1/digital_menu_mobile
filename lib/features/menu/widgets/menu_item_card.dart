import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
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
      final textScaler = MediaQuery.textScalerOf(context);
      final titleStyle =
          Theme.of(context).textTheme.titleSmall?.copyWith(
            color: const Color(0xFF172034),
            fontWeight: FontWeight.w700,
            height: 1.25,
          ) ??
          const TextStyle(
            color: Color(0xFF172034),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.25,
          );
      final noteStyle =
          Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF73788A),
            height: 1.3,
          ) ??
          const TextStyle(color: Color(0xFF73788A), fontSize: 12, height: 1.3);

      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('menu-item-${item.id}'),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox.expand(child: MenuItemImage(item: item)),
                ),
                const SizedBox(height: AppSpacing.compact),
                SizedBox(
                  height:
                      2 *
                      textScaler.scale(titleStyle.fontSize ?? 14) *
                      (titleStyle.height ?? 1.2),
                  child: Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),
                const SizedBox(height: AppSpacing.tight),
                SizedBox(
                  height:
                      2 *
                      textScaler.scale(noteStyle.fontSize ?? 12) *
                      (noteStyle.height ?? 1.3),
                  child: Text(
                    item.displayNote,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: noteStyle,
                  ),
                ),
                const SizedBox(height: AppSpacing.tight),
                Text(
                  '\$${item.priceUsd.toStringAsFixed(2)} USD',
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
        title: Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          item.displayNote,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 96),
          child: Text(
            '\$${item.priceUsd.toStringAsFixed(2)} USD',
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Color(0xFF1D3764),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
