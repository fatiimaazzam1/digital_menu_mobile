import 'package:digital_menu_mobile/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home filters items by category in place', (tester) async {
    await tester.pumpWidget(const DigitalMenuApp());

    expect(find.text('Digital Menu'), findsOneWidget);
    expect(find.text('Drinks'), findsOneWidget);
    expect(find.text('Starters'), findsOneWidget);
    expect(find.text('Mains'), findsOneWidget);
    expect(find.text('Desserts'), findsOneWidget);

    const categoryExamples = {
      'drinks': ('Citrus Sparkler', 'Burrata & Garden'),
      'starters': ('Burrata & Garden', 'Citrus Sparkler'),
      'mains': ('Duck Breast', 'Citrus Sparkler'),
      'desserts': ('Chocolate Tart', 'Citrus Sparkler'),
    };

    for (final entry in categoryExamples.entries) {
      await tester.tap(find.byKey(Key('category-${entry.key}')));
      await tester.pumpAndSettle();

      expect(find.text(entry.value.$1), findsOneWidget);
      expect(find.text(entry.value.$2), findsNothing);
    }
  });

  testWidgets('All Items opens matching details and returns with back', (
    tester,
  ) async {
    await tester.pumpWidget(const DigitalMenuApp());

    final allItemsButton = find.byKey(const Key('open-all-items'));
    await tester.ensureVisible(allItemsButton);
    await tester.tap(allItemsButton);
    await tester.pumpAndSettle();

    expect(find.text('All Items'), findsOneWidget);
    expect(
      find.byKey(const Key('menu-item-drink-citrus-sparkler')),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Apple Crumble'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(
      find.byKey(const Key('menu-item-dessert-apple-crumble')),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.text('Duck Breast'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    final item = find.byKey(const Key('menu-item-main-duck-breast'));
    await tester.tap(item);
    await tester.pumpAndSettle();

    expect(find.text('Duck Breast'), findsNWidgets(2));
    expect(find.text('\$28.00 USD'), findsOneWidget);
    expect(
      find.text('Seared duck breast with seasonal vegetables.'),
      findsOneWidget,
    );
    expect(find.text('Finished with a savory pan sauce'), findsOneWidget);
    expect(find.text('Image pending verified menu assets'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('All Items'), findsOneWidget);
  });

  testWidgets('Search trims input, shows no matches, and clears query', (
    tester,
  ) async {
    await tester.pumpWidget(const DigitalMenuApp());

    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();

    final searchField = find.byKey(const Key('menu-search-field'));
    await tester.enterText(searchField, '  cItRuS sPaRkLeR  ');
    await tester.pumpAndSettle();

    expect(find.text('Citrus Sparkler'), findsOneWidget);
    expect(find.text('Duck Breast'), findsNothing);

    await tester.enterText(searchField, 'no such menu item');
    await tester.pumpAndSettle();
    expect(find.text('No menu items match your search.'), findsOneWidget);

    await tester.enterText(searchField, 'berry lemonade');
    await tester.pumpAndSettle();
    final clearButton = find.byKey(const Key('clear-search'));
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('Citrus Sparkler'), findsOneWidget);
  });

  testWidgets('Search result opens its own details and back restores Search', (
    tester,
  ) async {
    await tester.pumpWidget(const DigitalMenuApp());
    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('menu-search-field')),
      'mushroom risotto',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mushroom Risotto'));
    await tester.pumpAndSettle();

    expect(find.text('Mushroom Risotto'), findsNWidgets(2));
    expect(find.text('\$21.00 USD'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-search-field')), findsOneWidget);
  });
}
