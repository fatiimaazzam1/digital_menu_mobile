import 'menu_category.dart';
import 'menu_item.dart';
import 'sample_menu_data.dart';

class MenuRepository {
  const MenuRepository({
    List<MenuCategory> categories = sampleMenuCategories,
    List<MenuItem> items = sampleMenuItems,
  }) : _categories = categories,
       _items = items;

  final List<MenuCategory> _categories;
  final List<MenuItem> _items;

  List<MenuCategory> get categories => List.unmodifiable(_categories);
  List<MenuItem> get items => List.unmodifiable(_items);

  List<MenuItem> itemsForCategory(String categoryId) {
    return _items.where((item) => item.categoryId == categoryId).toList();
  }

  MenuItem? itemById(String id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  List<MenuItem> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return items;
    }

    final categoryNames = {
      for (final category in _categories) category.id: category.name,
    };

    return _items.where((item) {
      final searchableText = [
        item.name,
        categoryNames[item.categoryId] ?? '',
        item.description,
        item.displayNote,
      ].join(' ').toLowerCase();
      return searchableText.contains(normalizedQuery);
    }).toList();
  }
}
