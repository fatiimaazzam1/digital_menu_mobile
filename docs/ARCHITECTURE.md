# Digital Menu Mobile Architecture

## Overview

The application is a Flutter/Dart mobile app for Android and iOS. A shallow, feature-oriented structure keeps menu data, browsing UI, and the optional QR workflow easy to find without introducing layers or infrastructure the first version does not need.

The app opens directly to menu browsing. Four sample categories contain 12 menu items, including a stable ID, category, name, description, USD price, and bundled image for each item. The menu works offline. There is no backend, database, remote API, account system, or web app.

The three core features are category browsing, an All Items page, and item details. The in-app QR scanner is an additional approved feature. Scanning is optional for customers because normal menu browsing remains available. The category interaction may filter Menu Home or open a category browsing view; the final UI choice belongs to the Figma design stage.

## Proposed project structure

```text
assets/
  images/
    menu/                         # Bundled menu item images
lib/
  main.dart                       # Flutter entry point
  app/
    app.dart                      # MaterialApp, theme, initial screen
    routes.dart                   # Route names and route argument handling
  features/
    menu/
      data/
        menu_category.dart        # Category model and identifiers
        menu_item.dart            # Immutable menu item model
        sample_menu_data.dart     # Four categories and 12 local items
        menu_repository.dart      # Read access to local menu data
      screens/
        menu_home_screen.dart     # Initial menu browsing screen
        all_items_screen.dart     # Complete menu list
        category_screen.dart      # Optional if Figma selects a separate category view
        item_detail_screen.dart   # Selected item's complete details
      widgets/
        category_selector.dart    # Reusable category selection UI
        menu_item_card.dart       # Reusable item summary and selection UI
    qr_scanner/
      screens/
        qr_scanner_screen.dart    # Scanner UI and scan lifecycle
      services/
        menu_qr_parser.dart       # Validates the supported demo QR value
test/
  ...                             # Unit and widget tests
```

`assets/images/menu/` is at the project root, outside `lib/`. Register the image directory in `pubspec.yaml` when assets are added. Actual menu names, descriptions, prices, and image files are to be finalized as part of the sample-data work.

### Component responsibilities

- **`main.dart` and `app/`:** Start the Flutter app, configure its theme and initial Menu Home screen, and keep route names and navigation arguments consistent.
- **`menu_category.dart` and `menu_item.dart`:** Represent category and item data as immutable Dart objects. An item carries its stable ID, category association, name, description, price, and local image path.
- **`sample_menu_data.dart`:** Define the four categories and 12 sample items as local data, with three items assigned to each category.
- **`menu_repository.dart`:** Provide a small read interface for categories, all items, items in a category, and lookup of an item by ID. It reads the local sample data directly; no storage or network layer is needed.
- **Menu screens:** Menu Home presents categories and items and provides routes to All Items and Scan Menu QR. All Items shows the entire menu. Item Detail displays the selected item's correct image, name, description, and USD price, with a visible way back to browsing. Category selection can filter Menu Home or use the optional Category screen depending on the Figma decision; it must show only that category's items.
- **Reusable widgets:** `category_selector.dart` and `menu_item_card.dart` hold UI reused by the relevant screens. They display data and report user selections; they do not own the canonical menu data.
- **QR scanner screen and parser:** The screen owns scanner presentation, permission/error states, retry or exit behavior, and handling of scan callbacks. The parser accepts only `digital-menu:sample-01`; unsupported values are not treated as links or external destinations.

The scanner package is not selected in this architecture document. Choose one Android/iOS-compatible package during implementation, after checking its current platform support and permission behavior, and keep package-specific code inside the scanner feature.

## Data flow

1. The app starts at Menu Home. The screen obtains categories and items from `menu_repository.dart`, which reads the in-memory sample records.
2. The user selects a category or All Items. The relevant screen requests or filters repository data and renders the matching items. All Items uses the complete item list.
3. When the user selects an item, its ID or model is passed through `Navigator` to Item Detail. The screen obtains the matching item and displays all required fields, including its bundled image. Back navigation returns to the previous browsing screen.
4. Image paths resolve to local assets packaged with the app, so menu content does not require internet access.

## State management and navigation

Use Flutter's built-in `StatefulWidget` and `setState` for small, short-lived UI state, such as the currently selected category or scanner status. The menu records are immutable local sample data, so they do not require global state, persistence, or a state-management framework. Avoid unnecessary controllers.

Use Flutter's built-in `Navigator` and the normal route stack for Menu Home, All Items, Item Detail, and the scanner. A small route table can centralize route names and argument handling; direct `MaterialPageRoute` navigation is also sufficient if it keeps the flow clearer. No routing package is needed. Pass stable IDs or item models rather than duplicating item content in screen state.

## In-app QR scanner

The visible **Scan Menu QR** action opens the scanner inside the installed app. Request camera access when the scanner is opened and access is needed; ordinary menu browsing must remain available whether or not camera permission is granted.

The scanner sends detected values to the parser. Only `digital-menu:sample-01` is recognized, and it returns the user to or opens the same locally stored menu. Unsupported values show a clear message with retry or exit; they never open arbitrary URLs. Handle denied or unavailable camera access with an understandable state and a way back to normal browsing. Stop or guard scan handling after the first successful value so repeated camera frames cannot trigger duplicate navigation.

Generate the prepared QR image outside the app, as required for the demo. Scanning it with the phone's normal camera does not launch the app; the installed app's scanner is the supported flow.

## Android and iOS considerations

The Flutter code and local menu data are shared across Android and iOS. The selected scanner package may require platform-specific camera configuration: add only the required Android camera permission and iOS camera usage description, and request permission in context. Verify the package's current requirements during implementation rather than assuming a particular plugin configuration.

Android and iOS are product targets, not evidence of completed platform verification. The Android release build and core device flow should be tested on a physical Android phone. Native iOS build and runtime testing require an appropriate Apple environment, including macOS/Xcode; availability is not established here. **iOS compatibility has not been verified.** Record any unperformed iOS testing as a limitation, not as a pass. On both platforms, check narrow and wider phone layouts, safe areas, scrolling, and larger text where devices/environments are available.

## Testing strategy

Tests are work to perform; this document does not claim they have passed.

- **Unit tests:** Check local data invariants (12 distinct stable item IDs, four categories with three associated items each, required item fields, and valid image asset paths), repository filtering and lookups, and QR parser acceptance of the one demo identifier and rejection of unsupported values.
- **Widget tests:** Check the initial menu, category filtering as designed, All Items completeness, correct item details, and back navigation. Exercise invalid QR and scanner error states through a testable scanner boundary where practical; verify that a valid scan triggers one navigation action.
- **Device/platform tests:** On a physical Android device, build/install the release app and exercise browsing, details, back navigation, valid and invalid QR scans, and camera denial/unavailability. Check offline operation and responsive layout, including a narrow phone width and larger text. Test iOS on an Apple environment and suitable device or simulator only when available; record the actual environment and results. Document acceptance-criteria results and defects in `docs/QA.md` when QA is performed.
