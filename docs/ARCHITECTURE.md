# Digital Menu Mobile Architecture

## Overview

The project is a Flutter/Dart mobile app targeting Android and iOS. The current core implementation uses local Dart data, bundled images, Flutter widgets, and Navigator; it has no backend, database, network API, or scanner package.

The three mandatory VioletPro core menu features are category browsing, **All Items**, and item details. Approved additions include local Search and Home/Search/Orders/Profile navigation, with notice-only Orders/Profile tabs. A disabled **Scan Menu QR** integration point appears on Home; real QR scanning is not implemented on the core branch and must be completed separately.

The app opens to Menu Home. Selecting one of four circular icon categories filters Home in place. The 12 local sample items have stable IDs, category associations, names, descriptions, display notes, USD prices, and bundled local images. Search and menu data access call the local repository only.

## Implemented project structure

```text
assets/
  images/
    menu/                              # Twelve bundled sample photos
lib/
  main.dart                            # Flutter entry point
  app/
    app.dart                           # Theme, Home/Search shell, four-tab navigation
  features/
    menu/
      data/
        menu_category.dart
        menu_item.dart
        sample_menu_data.dart
        menu_repository.dart
      screens/
        menu_home_screen.dart          # Category icons, search shortcut, responsive grid
        all_items_screen.dart          # Category-grouped complete menu
        item_detail_screen.dart        # Selected item details and category
      widgets/
        menu_item_card.dart
        menu_item_image.dart
    search/
      screens/
        search_screen.dart
test/
  features/menu/data/menu_repository_test.dart
  widget_test.dart
```

`assets/images/menu/` is registered in `pubspec.yaml`. The implementation uses native Flutter widgets; Tailwind CSS is not part of the mobile app.

### Component responsibilities

- **`app.dart`:** Configures the app theme, holds Home/Search in an `IndexedStack`, and keeps four destinations visible. Orders/Profile display a dismissible notice without changing the functional tab.
- **`menu_item.dart` and `menu_category.dart`:** Immutable local value models. Menu items include their display note and required bundled image path.
- **`sample_menu_data.dart` and `menu_repository.dart`:** Hold the four categories and 12 sample records; provide local filtering, lookup, and search.
- **`menu_home_screen.dart`:** Displays the ARDO-inspired header, Search shortcut, horizontal category icons, All Items route, disabled QR integration point, and responsive item grid. Category selection filters Home in place.
- **`all_items_screen.dart`:** Displays repository records grouped by category.
- **`item_detail_screen.dart`:** Looks up the selected ID and displays its image, name, category, description, display note, and USD price. An invalid ID displays a safe not-found message.
- **`menu_item_card.dart` and `menu_item_image.dart`:** Share list/grid presentation and bundled image rendering; image errors have a fallback.
- **`search_screen.dart`:** Maintains the query locally and renders repository results, an empty-results message, and a clear action. Item routes are pushed over the current tab.

## Data flow

1. `DigitalMenuApp` constructs a `MenuShell`; the shell selects Home or Search and retains both tab states.
2. Home reads the local repository, filters by selected category, and pushes All Items or item details through `Navigator`.
3. All Items and Search push the same ID-based Item Details screen; pop/back restores the underlying list or tab.
4. Search trims and lowercases the query and checks item name, category name, description, and display note. Empty queries return all 12 items.
5. Orders/Profile open a dialog containing only “Not included in this version.” Dismissing it leaves the previous functional tab selected.
6. Data and images are bundled with the app. This establishes no runtime network dependency by implementation inspection; physical airplane-mode behavior still requires device verification.

## State management and navigation

Flutter's built-in `StatefulWidget`, `setState`, and `TextEditingController` handle local UI state. Menu data is immutable. No state-management package, database, or controller package is used.

Home and Search remain the only functional tabs. Pushed All Items/Details routes preserve the prior screen's state. There is no named-route table or third-party router.

## QR scanner status

The Home QR control is disabled and explicitly states that scanning is not included in this core build. No scanner package, camera preview, payload parser, or camera permission configuration is present. The QR feature is planned for a separate feature branch; the accepted payload is `digital-menu:sample-01`.

The implementation must remain a real in-app camera scanner when added. It must accept only the approved local payload, handle invalid/denied/unavailable states, avoid duplicate navigation, and never open an arbitrary link. No QR behavior is claimed as implemented or tested here.

## Android and iOS considerations

Android and iOS platform projects are present. This Windows environment has no connected Android device or online emulator; the configured emulator remained offline after launch. Native iOS build/runtime verification requires macOS/Xcode and has not been performed. Platform targets are not proof of physical-device compatibility.

## Testing strategy

- **Automated tests:** Repository tests cover the sample data, asset paths, category filtering, lookup, and Search behavior. Widget tests cover category filtering, All Items/details/back, Search/clear/no-match, notice-only tabs, Home-to-Search navigation, semantics, and narrow/larger-text layouts. The current test record is in `docs/QA.md`.
- **Remaining device tests:** Install and exercise the Android release build, verify offline mode and physical rendering, and test real QR flows after scanner implementation. iOS requires an Apple build/runtime environment. Record only actual observations in `docs/QA.md`.
