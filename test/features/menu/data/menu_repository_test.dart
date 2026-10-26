import 'dart:io';

import 'package:digital_menu_mobile/features/menu/data/menu_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = MenuRepository();

  test('sample data has 12 distinct items in four categories of three', () {
    expect(repository.items, hasLength(12));
    expect(repository.categories, hasLength(4));
    expect(repository.items.map((item) => item.id).toSet(), hasLength(12));
    expect(repository.categories.map((category) => category.id).toSet(), {
      'drinks',
      'starters',
      'mains',
      'desserts',
    });
    expect(repository.categories.map((category) => category.name).toSet(), {
      'Drinks',
      'Starters',
      'Mains',
      'Desserts',
    });
    expect(
      repository.items.map((item) => item.imageAssetPath).toSet(),
      hasLength(12),
    );

    for (final category in repository.categories) {
      expect(repository.itemsForCategory(category.id), hasLength(3));
    }
  });

  test('sample records have required values and bundled image files', () {
    for (final item in repository.items) {
      expect(item.id.trim(), isNotEmpty);
      expect(item.categoryId.trim(), isNotEmpty);
      expect(item.name.trim(), isNotEmpty);
      expect(item.description.trim(), isNotEmpty);
      expect(item.displayNote.trim(), isNotEmpty);
      expect(item.priceUsd, greaterThan(0));
      expect(item.imageAssetPath, startsWith('assets/images/menu/'));
      expect(File(item.imageAssetPath).existsSync(), isTrue);
    }
  });

  test('category filtering returns only items in the selected category', () {
    for (final category in repository.categories) {
      final filteredItems = repository.itemsForCategory(category.id);
      expect(filteredItems, hasLength(3));
      expect(
        filteredItems.every((item) => item.categoryId == category.id),
        isTrue,
      );
    }
  });

  test('search matches name, category, description, and display note', () {
    expect(repository.search('CITRUS SPARKLER').map((item) => item.id), [
      'drink-citrus-sparkler',
    ]);
    expect(repository.search('drinks'), hasLength(3));
    expect(repository.search('sparkling water').map((item) => item.id), [
      'drink-citrus-sparkler',
    ]);
    expect(repository.search('bright and refreshing').map((item) => item.id), [
      'drink-citrus-sparkler',
    ]);
  });

  test('search trims whitespace and returns all items for empty query', () {
    expect(repository.search('  citrus sparkler  ').map((item) => item.id), [
      'drink-citrus-sparkler',
    ]);
    expect(repository.search(''), hasLength(12));
    expect(repository.search('  '), hasLength(12));
    expect(repository.search('no matching item'), isEmpty);
  });

  test('short query "el" matches the actual fixture substring', () {
    expect(repository.search('el').map((item) => item.id), [
      'dessert-chocolate-tart',
    ]);
  });

  test('short query "cr" matches all and only actual fixture substrings', () {
    expect(repository.search('cr').map((item) => item.id), [
      'starter-burrata',
      'starter-crispy-calamari',
      'main-mushroom-risotto',
      'dessert-chocolate-tart',
      'dessert-apple-crumble',
    ]);
  });

  test('item lookup returns the matching item or null', () {
    expect(repository.itemById('main-duck-breast')?.name, 'Duck Breast');
    expect(repository.itemById('unknown-item'), isNull);
  });
}
