import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../data/menu_item.dart';
import '../data/menu_repository.dart';
import '../widgets/menu_item_card.dart';
import 'all_items_screen.dart';
import 'item_detail_screen.dart';
import '../../qr_scanner/screens/qr_scanner_screen.dart';

class MenuHomeScreen extends StatefulWidget {
  const MenuHomeScreen({
    required this.repository,
    required this.onSearchTap,
    this.scannerPreviewBuilder,
    super.key,
  });

  final MenuRepository repository;
  final VoidCallback onSearchTap;
  final QrScannerPreviewBuilder? scannerPreviewBuilder;

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final largeText = MediaQuery.textScalerOf(context).scale(14) >= 18;
    final crossAxisCount = screenWidth >= 340 && !largeText ? 2 : 1;
    final menuItems = crossAxisCount == 1
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = visibleItems[index];
              return _menuItemCard(context, item, isGrid: false);
            }, childCount: visibleItems.length),
          )
        : SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.controlGap,
              mainAxisSpacing: AppSpacing.controlGap,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = visibleItems[index];
              return _menuItemCard(context, item, isGrid: true);
            }, childCount: visibleItems.length),
          );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                key: const Key('ardo-menu-logo'),
                'assets/branding/ardo_menu_icon.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ARDO',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFFFFFDF8),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'MENU',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFE5CF9D),
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentInset,
              20,
              AppSpacing.contentInset,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Semantics(
                button: true,
                label: 'Search the menu',
                child: Material(
                  color: const Color(0xFFFFFDF8),
                  borderRadius: BorderRadius.circular(AppRadii.surface),
                  child: InkWell(
                    key: const Key('home-search-shortcut'),
                    borderRadius: BorderRadius.circular(AppRadii.surface),
                    onTap: widget.onSearchTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.surface),
                        border: Border.all(color: const Color(0xFFE6E0D5)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFF73788A)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search the menu',
                              style: TextStyle(color: Color(0xFF73788A)),
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Color(0xFF1D3764)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentInset,
              AppSpacing.section,
              AppSpacing.contentInset,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF172034),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    key: const Key('open-all-items'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              AllItemsScreen(repository: widget.repository),
                        ),
                      );
                    },
                    child: const Text('All Items'),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.contentInset,
            ),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 112,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final category in widget.repository.categories)
                      _categoryButton(
                        label: category.name,
                        categoryId: category.id,
                        isSelected: _selectedCategoryId == category.id,
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentInset,
              AppSpacing.controlGap,
              AppSpacing.contentInset,
              AppSpacing.compact,
            ),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('open-qr-scanner'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.surface),
                    ),
                  ),
                  onPressed: () => _openQrScanner(context),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Menu QR'),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentInset,
              AppSpacing.controlGap,
              AppSpacing.contentInset,
              AppSpacing.compact,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategoryId == null
                          ? 'Menu'
                          : widget.repository.categories
                                .firstWhere(
                                  (category) =>
                                      category.id == _selectedCategoryId,
                                )
                                .name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF172034),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${visibleItems.length} items',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF73788A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentInset,
              0,
              AppSpacing.contentInset,
              28,
            ),
            sliver: menuItems,
          ),
        ],
      ),
    );
  }

  Widget _categoryButton({
    required String label,
    required String? categoryId,
    required bool isSelected,
  }) {
    final icon = switch (categoryId) {
      'drinks' => Icons.local_cafe_outlined,
      'starters' => Icons.restaurant_outlined,
      'mains' => Icons.dinner_dining_outlined,
      'desserts' => Icons.cake_outlined,
      _ => Icons.restaurant_menu,
    };

    return SizedBox(
      width: 82,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: '$label category',
        excludeSemantics: true,
        child: InkWell(
          key: Key('category-${categoryId ?? 'all'}'),
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => _selectedCategoryId = categoryId),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF101D36)
                      : const Color(0xFFFFFDF8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFC9A75C)
                        : const Color(0xFFE6E0D5),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xFFE5CF9D)
                      : const Color(0xFF1D3764),
                  semanticLabel: label,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF172034),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItemCard(
    BuildContext context,
    MenuItem item, {
    required bool isGrid,
  }) {
    return MenuItemCard(
      item: item,
      isGrid: isGrid,
      onTap: () => _openItemDetails(context, item.id),
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

  Future<void> _openQrScanner(BuildContext context) async {
    final recognized = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            QrScannerScreen(previewBuilder: widget.scannerPreviewBuilder),
      ),
    );

    if (!context.mounted || recognized != true) {
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AllItemsScreen(repository: widget.repository),
      ),
    );
  }
}
