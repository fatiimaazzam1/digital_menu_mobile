# Digital Menu Mobile Architecture

## 1. Overview

The project is a Flutter/Dart mobile application targeting Android and iOS. It uses local Dart data, bundled images, native Flutter widgets, Flutter Navigator, and `mobile_scanner` for in-app QR scanning. It has no backend, database, or menu network API.

The three mandatory menu features are category browsing, **All Items**, and item details. Approved additions include local Search and four-tab navigation: Home, Search, Orders, and Profile. Orders and Profile display a notice stating that they are not included in this version. Home also provides a **Scan Menu QR** action that opens the in-app camera scanner.

The app opens directly to Menu Home. Selecting one of four circular category icons filters the Home screen in place. The 12 local sample menu items have stable IDs, category associations, names, descriptions, display notes, USD prices, and bundled local images. Menu browsing and search use the local repository.

## 2. Implemented Project Structure

```text
assets/
  branding/
    ardo_menu_icon.png
  images/
    menu/
      # Twelve bundled sample menu images

lib/
  main.dart
  app/
    app.dart
    design_tokens.dart
  features/
    menu/
      data/
        menu_category.dart
        menu_item.dart
        sample_menu_data.dart
        menu_repository.dart
      screens/
        menu_home_screen.dart
        all_items_screen.dart
        item_detail_screen.dart
      widgets/
        menu_item_card.dart
        menu_item_image.dart
    qr_scanner/
      data/
        qr_payload_parser.dart
      screens/
        qr_scanner_screen.dart
    search/
      screens/
        search_screen.dart

test/
  features/
    menu/
      data/
        menu_repository_test.dart
    qr_scanner/
      data/
        qr_payload_parser_test.dart
  widget_test.dart
```

The menu images under `assets/images/menu/` are registered in `pubspec.yaml`. The branding assets provide the app's logo and launcher artwork. The mobile application uses native Flutter widgets; Tailwind CSS is not part of the Flutter implementation.

## 3. Component Responsibilities

- **`app.dart`:** Configures the app theme and the main navigation shell. Home and Search are retained in an `IndexedStack`; Orders and Profile display a notice without implementing additional business features.
- **`menu_category.dart` and `menu_item.dart`:** Define the local data models. Menu items include their display note and bundled image path.
- **`sample_menu_data.dart` and `menu_repository.dart`:** Provide the four categories and 12 sample menu records, along with local filtering, item lookup, and search operations.
- **`menu_home_screen.dart`:** Displays the ARDO Menu branding, Search shortcut, category icons, All Items route, QR scanner entry, and responsive item listing. Selecting a category filters Home in place. Shared spacing values are defined in `design_tokens.dart`. The layout uses a two-column grid at widths of 340 logical pixels or more and a list layout for narrower or applicable large-text layouts.
- **`design_tokens.dart`:** Defines shared spacing and corner-radius constants used by app surfaces, Home, Search, and menu images.
- **`all_items_screen.dart`:** Displays all repository records grouped by category.
- **`qr_payload_parser.dart` and `qr_scanner_screen.dart`:** Validate the supported QR payload, display the live camera preview and scan frame, handle scanner errors, and provide an explicit Continue action after successful recognition.
- **`item_detail_screen.dart`:** Looks up a selected item by ID and displays its image, name, category, description, display note, and USD price. An invalid ID displays a safe not-found message.
- **`menu_item_card.dart` and `menu_item_image.dart`:** Share menu-card presentation and bundled image rendering. Grid cards use constrained text layouts, prices remain visible, and image failures have a fallback.
- **`search_screen.dart`:** Maintains the local search query and displays matching results, an empty-results message, and a clear action. Item details are opened through Navigator.

## 4. Data Flow

1. `DigitalMenuApp` creates the main navigation shell, which switches between Home and Search while retaining their tab state.
2. Home reads the local repository, filters items by the selected category, and opens All Items, item details, or the QR scanner through Navigator.
3. All Items and Search open the shared Item Details screen using the selected item's ID. Popping a route returns the user to the underlying screen.
4. Search trims and lowercases the query and checks the item name, category name, description, and display note. An empty query returns all 12 items.
5. Orders and Profile display a notice stating **"Not included in this version."** Dismissing the notice does not implement or navigate to a business feature.
6. Menu data and images are bundled with the app. No runtime menu API is implemented. Offline behavior should be verified on a device before it is claimed as device-tested.

## 5. State Management and Navigation

The application uses Flutter's built-in `StatefulWidget`, `setState`, and `TextEditingController` for local UI state. Menu data is local and is not modified by the user. No third-party state-management package or database is used. Camera scanning is provided by `mobile_scanner`.

Home and Search are the functional tabs. All Items, Item Details, and the QR scanner are pushed as routes, preserving the previous screen's state. The app does not use a named-route table or a third-party router.

The scanner requires three consecutive detections of the exact supported payload, with consecutive detections no more than 700 milliseconds apart. After recognition, it stops scanning and displays **"Menu recognized"** with a Continue action. Continue returns a success result to Home, which opens the existing All Items screen. Back navigation from All Items returns to the original Home route.

## 6. QR Scanner

The Home screen's **Scan Menu QR** action opens an in-app camera preview provided by `mobile_scanner`. A centered bracket frame and shaded overlay guide the user during scanning.

The parser accepts only this exact payload:

`digital-menu:sample-01`

Unsupported payloads, including URLs, must not trigger external navigation. Recognition requires three consecutive matching detections within the defined interval. Once recognized, the scanner stops and displays a success state. The user must select Continue before the app returns a successful result and opens All Items.

Android declares camera permission, and iOS provides a camera usage description. Permission-denied and unavailable-camera states are designed to explain the issue and provide a way back to the menu. Late scanner callbacks after screen disposal must not trigger navigation.

Automated tests cover QR parsing and scanner-related behavior, including stable recognition, duplicate detections, navigation, late callbacks, and error recovery, as represented in the test suite. The user has also reported a physical-device scan in which the supported menu was recognized and Continue opened the menu. Complete platform compatibility and every camera-permission scenario have not been independently verified.

## 7. Android and iOS Considerations

Android and iOS platform project files are present. This does not by itself prove that the app has been successfully built and tested on both platforms.

The development environment is Windows. Native iOS build and runtime verification require a compatible Apple development environment, including macOS and Xcode. iOS runtime compatibility has not been verified.

Android release-build behavior, device-specific rendering, offline operation, and camera permission flows should be recorded in the QA documentation only after the corresponding checks have actually been performed.

## 8. Testing Strategy

### Automated tests

The automated test suite includes coverage for:

- Local sample data, image asset paths, category filtering, item lookup, and Search behavior.
- Accepted and rejected QR payloads.
- Home and menu navigation, category selection, All Items, item details, and back navigation.
- Search results, clearing the query, and no-match behavior.
- Orders and Profile notice-only behavior.
- Scanner recognition, duplicate detections, navigation, and relevant error and disposal cases.
- UI layout and semantics, including constrained text, image presentation, and responsive layouts.

The exact test results for the current code should be recorded in `docs/QA.md`. A test being present in the suite does not, by itself, establish that the latest version has passed it.

### Remaining verification

The following checks should be marked as pending until completed and recorded:

- Android release build and installation on a device.
- Physical-device rendering and offline behavior.
- Real camera scanning and camera permission-denial recovery.
- Camera-unavailable behavior on the intended devices.
- iOS build and runtime verification in a compatible Apple development environment.

Only observed results should be reported as passed in `docs/QA.md` and summarized in `docs/REVIEW.md`.
