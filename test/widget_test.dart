import 'package:digital_menu_mobile/app/app.dart';
import 'package:digital_menu_mobile/features/menu/data/menu_item.dart';
import 'package:digital_menu_mobile/features/menu/widgets/menu_item_card.dart';
import 'package:digital_menu_mobile/features/menu/widgets/menu_item_image.dart';
import 'package:digital_menu_mobile/features/qr_scanner/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  testWidgets('Home filters items by category in place', (tester) async {
    await tester.pumpWidget(const DigitalMenuApp());

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).title,
      'ARDO Menu',
    );
    expect(find.byKey(const Key('ardo-menu-logo')), findsOneWidget);
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

  testWidgets('Home grid aligns content and keeps cards evenly sized', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DigitalMenuApp());

    final searchRect = tester.getRect(
      find.byKey(const Key('home-search-shortcut')),
    );
    final searchShortcut = find.byKey(const Key('home-search-shortcut'));
    final scanButtonFinder = find.byKey(const Key('open-qr-scanner'));
    final scanRect = tester.getRect(scanButtonFinder);
    final menuHeadingRect = tester.getRect(find.text('Menu'));
    final categoryRect = tester.getRect(
      find.byKey(const Key('category-drinks')),
    );
    final firstCardFinder = find.ancestor(
      of: find.byKey(const Key('menu-item-drink-citrus-sparkler')),
      matching: find.byType(Card),
    );
    final secondCardFinder = find.ancestor(
      of: find.byKey(const Key('menu-item-drink-iced-coffee')),
      matching: find.byType(Card),
    );
    final firstCardRect = tester.getRect(firstCardFinder);
    final secondCardRect = tester.getRect(secondCardFinder);

    expect(searchRect.left, 16);
    expect(
      tester.widget<InkWell>(searchShortcut).borderRadius,
      BorderRadius.circular(16),
    );
    expect(scanRect.left, searchRect.left);
    expect(scanRect.right, searchRect.right);
    final scanButton = tester.widget<OutlinedButton>(scanButtonFinder);
    final scanShape = scanButton.style!.shape!.resolve({});
    expect(scanShape, isA<RoundedRectangleBorder>());
    expect(
      (scanShape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(16),
    );
    expect(menuHeadingRect.left, searchRect.left);
    expect(categoryRect.left, searchRect.left);
    expect(firstCardRect.left, searchRect.left);
    expect(firstCardRect.height, closeTo(secondCardRect.height, 0.1));
    expect(firstCardRect.bottom, closeTo(secondCardRect.bottom, 0.1));

    final firstImage = find.descendant(
      of: firstCardFinder,
      matching: find.byType(Image),
    );
    final firstImageRect = tester.getRect(firstImage);
    expect(firstImageRect.left, greaterThanOrEqualTo(firstCardRect.left + 12));
    expect(firstImageRect.right, lessThanOrEqualTo(firstCardRect.right - 12));
    expect(
      firstImageRect.width / firstImageRect.height,
      inInclusiveRange(0.8, 1.8),
    );

    final firstPrice = tester.widget<Text>(find.text('\$5.50 USD'));
    final secondPrice = tester.widget<Text>(find.text('\$4.75 USD'));
    final firstNameRect = tester.getRect(find.text('Citrus Sparkler'));
    final firstPriceRect = tester.getRect(find.text('\$5.50 USD'));
    final secondPriceRect = tester.getRect(find.text('\$4.75 USD'));
    expect(firstNameRect.left, greaterThanOrEqualTo(firstCardRect.left + 12));
    expect(firstPriceRect.right, lessThanOrEqualTo(firstCardRect.right - 12));
    expect(firstPrice.maxLines, isNull);
    expect(firstPrice.overflow, isNull);
    expect(secondPrice.maxLines, isNull);
    expect(firstPriceRect.bottom, closeTo(secondPriceRect.bottom, 0.1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('grid cards constrain long text without truncating prices', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const longItem = MenuItem(
      id: 'long-item',
      categoryId: 'mains',
      name: 'A Very Long Seasonal Main Course',
      description: 'A test description.',
      displayNote:
          'Prepared slowly with seasonal vegetables, herbs, and a house sauce.',
      priceUsd: 128,
      imageAssetPath: 'assets/images/menu/main-duck-breast.jpg',
    );
    const shortItem = MenuItem(
      id: 'short-item',
      categoryId: 'drinks',
      name: 'Tea',
      description: 'A test description.',
      displayNote: 'Freshly brewed',
      priceUsd: 4,
      imageAssetPath: 'assets/images/menu/drink-iced-coffee.jpg',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            children: const [
              MenuItemCard(item: longItem, isGrid: true, onTap: _doNothing),
              MenuItemCard(item: shortItem, isGrid: true, onTap: _doNothing),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final longCard = find.ancestor(
      of: find.byKey(const Key('menu-item-long-item')),
      matching: find.byType(Card),
    );
    final shortCard = find.ancestor(
      of: find.byKey(const Key('menu-item-short-item')),
      matching: find.byType(Card),
    );
    expect(
      tester.getRect(longCard).height,
      closeTo(tester.getRect(shortCard).height, 0.1),
    );

    final name = tester.widget<Text>(
      find.descendant(
        of: longCard,
        matching: find.text('A Very Long Seasonal Main Course'),
      ),
    );
    final note = tester.widget<Text>(
      find.descendant(
        of: longCard,
        matching: find.text(
          'Prepared slowly with seasonal vegetables, herbs, and a house sauce.',
        ),
      ),
    );
    final price = tester.widget<Text>(
      find.descendant(of: longCard, matching: find.text('\$128.00 USD')),
    );
    expect(name.maxLines, 2);
    expect(name.overflow, TextOverflow.ellipsis);
    expect(note.maxLines, 2);
    expect(note.overflow, TextOverflow.ellipsis);
    expect(price.maxLines, isNull);
    expect(price.overflow, isNull);
    expect(tester.takeException(), isNull);
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
    await tester.drag(find.byType(ListView).last, const Offset(0, 160));
    await tester.pumpAndSettle();
    await tester.ensureVisible(item);
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
    final searchDecoration = tester.widget<TextField>(searchField).decoration!;
    expect(searchDecoration.border, isA<OutlineInputBorder>());
    expect(
      (searchDecoration.border! as OutlineInputBorder).borderRadius,
      BorderRadius.circular(16),
    );
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
          .widget<OutlinedButton>(find.byKey(const Key('open-qr-scanner')))
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byKey(const Key('home-search-shortcut')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('menu-search-field')), findsOneWidget);
  });

  testWidgets(
    'QR scanner requires stable detection then opens All Items once',
    (tester) async {
      late ValueChanged<String?> injectDetection;

      await tester.pumpWidget(
        DigitalMenuApp(
          scannerPreviewBuilder: (context, onDetected, errorBuilder) {
            injectDetection = onDetected;
            return Column(
              children: [
                TextButton(
                  key: const Key('inject-invalid-qr'),
                  onPressed: () => onDetected('https://example.com/menu'),
                  child: const Text('Inject invalid QR'),
                ),
                TextButton(
                  key: const Key('inject-valid-qr'),
                  onPressed: () => onDetected('digital-menu:sample-01'),
                  child: const Text('Inject valid QR'),
                ),
              ],
            );
          },
        ),
      );

      final scannerButton = find.byKey(const Key('open-qr-scanner'));
      await tester.ensureVisible(scannerButton);
      await tester.tap(scannerButton);
      await tester.pumpAndSettle();

      expect(find.text('Scan Menu QR'), findsOneWidget);
      expect(find.byKey(const Key('qr-scanning-frame')), findsOneWidget);
      expect(find.text('Place the QR code inside the frame'), findsOneWidget);
      await tester.tap(find.byKey(const Key('inject-invalid-qr')));
      await tester.pump();
      expect(
        find.text('This QR code is not supported. Try the prepared menu code.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('qr-scanner-status')), findsOneWidget);
      expect(find.text('All Items'), findsNothing);

      final validButton = find.byKey(const Key('inject-valid-qr'));
      await tester.tap(validButton);
      await tester.pump();
      await tester.tap(validButton);
      await tester.pump();

      expect(find.text('Menu recognized'), findsNothing);
      expect(find.text('All Items'), findsNothing);

      await tester.pump(const Duration(milliseconds: 701));
      await tester.tap(validButton);
      await tester.pump();
      expect(find.text('Menu recognized'), findsNothing);
      await tester.tap(validButton);
      await tester.pump();
      expect(find.text('Menu recognized'), findsNothing);
      await tester.tap(validButton);
      await tester.pump();

      expect(find.byKey(const Key('qr-menu-recognized')), findsOneWidget);
      expect(find.byKey(const Key('continue-to-all-items')), findsOneWidget);
      expect(find.text('All Items'), findsNothing);

      injectDetection('digital-menu:sample-01');
      injectDetection('digital-menu:sample-01');
      await tester.pump();
      expect(find.byKey(const Key('qr-menu-recognized')), findsOneWidget);
      expect(find.text('All Items'), findsNothing);

      await tester.tap(find.byKey(const Key('continue-to-all-items')));
      await tester.pumpAndSettle();
      expect(find.text('All Items'), findsOneWidget);
      expect(find.text('Citrus Sparkler'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('ARDO'), findsOneWidget);
      expect(find.text('All Items'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('late valid scan callback after disposal does not stop camera', (
    tester,
  ) async {
    late ValueChanged<String?> onDetected;
    var stopCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                key: const Key('open-scanner-for-disposal-test'),
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => QrScannerScreen(
                        previewBuilder: (context, detected, errorBuilder) {
                          onDetected = detected;
                          return const SizedBox.expand();
                        },
                        stopCamera: () async {
                          stopCalls++;
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Open scanner'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('open-scanner-for-disposal-test')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    onDetected('digital-menu:sample-01');
    await tester.pump();

    expect(stopCalls, 0);
    expect(find.text('Open scanner'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('camera permission error provides menu recovery', (tester) async {
    await tester.pumpWidget(
      DigitalMenuApp(
        scannerPreviewBuilder: (context, onDetected, errorBuilder) => Center(
          child: errorBuilder(
            context,
            const MobileScannerException(
              errorCode: MobileScannerErrorCode.permissionDenied,
            ),
          ),
        ),
      ),
    );

    final scannerButton = find.byKey(const Key('open-qr-scanner'));
    await tester.ensureVisible(scannerButton);
    await tester.tap(scannerButton);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Camera permission was denied. You can still browse the local menu.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Back to menu'));
    await tester.pumpAndSettle();

    expect(find.text('ARDO'), findsOneWidget);
    expect(
      find.text(
        'Camera permission was denied. You can still browse the local menu.',
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('unavailable camera error provides menu recovery', (
    tester,
  ) async {
    await tester.pumpWidget(
      DigitalMenuApp(
        scannerPreviewBuilder: (context, onDetected, errorBuilder) => Center(
          child: errorBuilder(
            context,
            const MobileScannerException(
              errorCode: MobileScannerErrorCode.unsupported,
            ),
          ),
        ),
      ),
    );

    final scannerButton = find.byKey(const Key('open-qr-scanner'));
    await tester.ensureVisible(scannerButton);
    await tester.tap(scannerButton);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'A camera is unavailable on this device. You can still browse the local menu.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Back to menu'));
    await tester.pumpAndSettle();

    expect(find.text('ARDO'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home layout avoids overflow at narrow and larger text sizes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DigitalMenuApp());
    expect(find.byType(SliverGrid), findsNothing);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(360, 800);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: const MenuShell(),
        ),
      ),
    );
    expect(find.byType(SliverGrid), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

void _doNothing() {}
