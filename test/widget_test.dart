import 'package:digital_menu_mobile/app/app.dart';
import 'package:digital_menu_mobile/features/menu/data/menu_item.dart';
import 'package:digital_menu_mobile/features/menu/widgets/menu_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home filters items by category in place', (tester) async {
    await tester.pumpWidget(const DigitalMenuApp());

    expect(find.text('ARDO'), findsOneWidget);
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

  testWidgets('Home item details return to the selected category', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DigitalMenuApp());

    await tester.tap(find.byKey(const Key('category-mains')));
    await tester.pumpAndSettle();
    final duckBreastCard = find.byKey(const Key('menu-item-main-duck-breast'));
    await tester.ensureVisible(duckBreastCard);
    await tester.tap(duckBreastCard);
    await tester.pumpAndSettle();

    expect(find.text('Duck Breast'), findsNWidgets(2));
    expect(find.text('Mains'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-item-main-duck-breast')), findsOneWidget);
    expect(
      find.byKey(const Key('menu-item-drink-citrus-sparkler')),
      findsNothing,
    );
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
    expect(find.text('Mains'), findsOneWidget);
    expect(
      find.text('Seared duck breast with seasonal vegetables.'),
      findsOneWidget,
    );
    expect(find.text('Finished with a savory pan sauce'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('All Items'), findsOneWidget);
  });

  testWidgets('menu image shows a safe fallback when an asset is missing', (
    tester,
  ) async {
    const item = MenuItem(
      id: 'missing-image',
      categoryId: 'drinks',
      name: 'Missing Image',
      description: 'Test description',
      displayNote: 'Test note',
      priceUsd: 1,
      imageAssetPath: 'assets/images/menu/missing.jpg',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MenuItemImage(item: item, width: 100, height: 100),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
  });

  testWidgets('Search trims input, shows no matches, and clears query', (
    tester,
  ) async {
    await tester.pumpWidget(const DigitalMenuApp());

    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('search-result-count'))).data,
      '12 items',
    );

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
    expect(
      tester.widget<Text>(find.byKey(const Key('search-result-count'))).data,
      '12 items',
    );
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

  testWidgets('Orders and Profile show notice without leaving current tab', (
    tester,
  ) async {
    await tester.pumpWidget(const DigitalMenuApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('Not included in this version'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('ARDO'), findsOneWidget);

    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Not included in this version'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-search-field')), findsOneWidget);
  });

  testWidgets('Home search shortcut opens Search and categories are semantic', (
    tester,
  ) async {
    await tester.pumpWidget(const DigitalMenuApp());

    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Drinks category'), findsOneWidget);
    semantics.dispose();
    expect(find.text('Scan Menu QR'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Scan Menu QR'),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const Key('home-search-shortcut')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('menu-search-field')), findsOneWidget);
  });

  testWidgets('Home layout avoids overflow at narrow and larger text sizes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DigitalMenuApp());
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: const MenuShell(),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
