# Digital Menu Mobile Architecture

## Overview

The application is a Flutter/Dart mobile app targeting Android and iOS. A shallow feature-oriented structure keeps local menu data, browsing, search, and camera scanning understandable without introducing backend infrastructure or unnecessary architectural layers.

The three mandatory VioletPro core menu features are category browsing, **All Items**, and item details. The approved app also includes local Search, the Home/Search/Orders/Profile bottom navigation, notice-only Orders/Profile tabs, and an in-app QR scanner. Search and the placeholder tabs are user-approved additions/design decisions, not additional mandatory VioletPro features. Orders and Profile have no functional pages or business behavior.

The app opens to Menu Home. Selecting a category chip filters the items on Menu Home itself. Four local categories contain 12 sample menu items, each with a stable ID, category association, name, description, USD price, and bundled local image. Menu and Search work offline. There is no backend, database, remote API, or web app.

## Proposed project structure

```text
assets/
  images/
    menu/                              # Bundled menu item images
lib/
  main.dart                            # Flutter entry point
  app/
    app.dart                           # MaterialApp, theme, root tab shell
    routes.dart                        # Push-route names and argument handling
  features/
    menu/
      data/
        menu_category.dart             # Category model and identifiers
        menu_item.dart                 # Immutable item model, including display note
        sample_menu_data.dart          # Four categories and 12 local items
        menu_repository.dart           # Local menu reads and search
      screens/
        menu_home_screen.dart          # Categories, filtered items, All Items/QR entry
        all_items_screen.dart          # Complete menu list
        item_detail_screen.dart        # Selected item's complete details
      widgets/
        category_selector.dart         # Home category chips
        menu_item_card.dart            # Reusable item summary and selection UI
    search/
      screens/
        search_screen.dart             # Local menu search and result presentation
    navigation/
      widgets/
        bottom_navigation.dart         # Home/Search/Orders/Profile destinations
        not_included_notice.dart       # Shared Orders/Profile informational notice
    qr_scanner/
      screens/
        qr_scanner_screen.dart         # Real camera preview and scan lifecycle
      services/
        menu_qr_parser.dart            # Validates the single supported demo value
test/
  ...                                  # Unit and widget tests
```

The image directory is at the project root, outside `lib/`. Register it in `pubspec.yaml` when assets are added. Tailwind CSS is used only by the Figma web prototype; production mobile UI is implemented with Flutter widgets and native Flutter styling.

### Component responsibilities

- **`main.dart` and `app/`:** Start the application, configure `MaterialApp` and the theme, host the root tab shell, and centralize push-route names and arguments where that is clearer than direct route construction.
- **`menu_category.dart` and `menu_item.dart`:** Define immutable category and item data. Each item carries its stable ID, category association, name, description, display note, USD price, and bundled asset path. The display note is menu content and is included in Search matching.
- **`sample_menu_data.dart`:** Define the four categories—Drinks, Starters, Mains, Desserts—and 12 sample items locally, with three items per category. Each item's record includes its display note.
- **`menu_repository.dart`:** Provide read access to categories/items, category filtering, item lookup by ID, and case-insensitive local search across item name, category, description, and display note. Trim surrounding query whitespace before matching. An empty query returns all 12 items; clearing the query therefore restores all items. It has no network or persistence dependency.
- **`menu_home_screen.dart`:** Initial browsing screen. It displays categories and item cards, keeps the selected category, filters the visible list in place, and exposes the All Items and Scan Menu QR actions.
- **`all_items_screen.dart`:** Displays the full 12-item menu, regardless of the selected Home category.
- **`item_detail_screen.dart`:** Displays the selected item's matching image, name, description, USD price, and a visible back action.
- **`search_screen.dart`:** Reads the query, requests matching menu items from the repository, displays selectable results, and presents an understandable empty-results state when there are no matches. Empty query displays all 12 items; clearing the query restores them. Search selection opens the matching Item Details. Query/result state is local to the screen; the menu remains usable offline.
- **`category_selector.dart` and `menu_item_card.dart`:** Reusable presentation widgets. The category selector reports chip selection to Menu Home; cards display item data and report item selection. Neither owns canonical data.
- **`bottom_navigation.dart`:** Provides the approved Home, Search, Orders, and Profile destinations. Home and Search select their corresponding app surfaces. Orders and Profile only invoke the shared “Not included in this version” notice and never navigate to a business page.
- **`not_included_notice.dart`:** Presents the informational notice for either placeholder destination and a clear dismissal/return interaction. It contains no order/profile data or actions.
- **`qr_scanner_screen.dart` and `menu_qr_parser.dart`:** Keep the scanner package/camera preview and scan lifecycle isolated. Use a real camera scanner in the Flutter MVP. The parser accepts only `digital-menu:sample-01`; unsupported data is never opened as a URL.

The scanner package is a technical implementation choice for the implementation phase. Select a maintained package with Android and iOS support, confirm its permission/configuration requirements, and keep package APIs inside the QR scanner feature.

## Data flow

1. The app starts in the root shell with Home selected. The bottom navigation is visible on Home and Search. Menu Home reads categories and all items from `menu_repository.dart`, which uses bundled local sample records.
2. A category-chip selection updates Menu Home's selected-category state and filters its displayed list through the repository. It does not push a separate category route.
3. All Items obtains the complete item collection. Selecting a card on Home, All Items, or Search passes an item ID/model to Item Details, which displays the corresponding fields and bundled image. Back returns to the previous browsing context.
4. Search trims surrounding whitespace and evaluates the query case-insensitively against each item's name, category, description, and display note. An empty query returns all 12 items. Matching results are rendered in Search; no matches show the empty-results state; clearing restores all items. Selecting a result opens its matching details. No network request is made.
5. Selecting Orders or Profile invokes the notice-only interaction; dismissing it returns to the previous tab context. No order/profile business data exists.
6. Image asset paths resolve to files packaged with the app, so menu and search content work without internet access.

## State management and navigation

Use Flutter's built-in `StatefulWidget` and `setState` for small local UI state: selected bottom tab, selected Home category, Search query/results, notice visibility, and scanner lifecycle/one-shot handling. Menu records are immutable local data. No global state-management framework, database, or unnecessary controller is required.

Use a simple root tab shell with visible bottom navigation on Home and Search. Home and Search show their respective app surfaces; Orders/Profile remain visible notice-only tabs and show only “Not included in this version,” never routes to functional pages. Use Flutter's built-in `Navigator` for All Items, Item Details, and the QR Scanner. These pushed screens provide appropriate back/exit navigation to the preceding browsing context (including the originating Home or Search tab); the bottom navigation need not appear on them. A small route table or direct `MaterialPageRoute` pushes are both sufficient; no routing package is needed.

## In-app QR scanner

The Scan Menu QR action opens a real camera-based scanner inside the installed app. Request camera access when scanning is opened and access is needed. The menu and Search must remain available when permission is denied or the camera is unavailable.

Pass detected values to `menu_qr_parser.dart`. Accept only `digital-menu:sample-01` and return to/open the same local menu without a network request. Unsupported values show a clear message with retry or exit; never open arbitrary links. Handle permission denial and camera unavailability without crashing. Stop/pause scanning or guard the callback after one successful result so repeated frame detections cannot cause duplicate navigation.

The prepared QR image is generated outside the application. Scanning it with the phone's normal camera does not launch the app; use the installed app's scanner. Prototype simulation controls are not a substitute for the Flutter camera flow.

## Android and iOS considerations

The Flutter UI and local menu/search logic are shared across Android and iOS. Configure the platform-specific camera permission and iOS camera usage description required by the selected scanner package, and request access in context. Keep ordinary menu use independent of camera permission.

Adapt the Figma visual reference to responsive native layouts rather than carrying fixed web-prototype dimensions into Flutter. Respect system safe areas and insets; allow content to scroll; account for keyboard insets on Search; avoid overflow at narrow phone widths; support larger text scaling; and maintain readable cards, category chips, navigation labels, and details on wider phones. Use flexible constraints rather than fixed screen-sized dimensions, and preserve the approved visual identity while adapting image crops and spacing to available space. Tailwind CSS remains prototype-only and is not used by the Flutter application.

Android and iOS are targets, not evidence of completed verification. Test the Android release build and core flows on a physical Android device. Native iOS build/runtime verification requires an Apple environment, including macOS/Xcode; availability is not established. **iOS compatibility has not been verified.** Record only actual platform/device results and disclose any unperformed testing.

## Testing strategy

Tests listed here are planned checks, not claims that they have passed.

- **Unit tests:** Verify local data invariants (12 unique item IDs, the categories Drinks, Starters, Mains, and Desserts with three associated items each, required fields including display note, and valid asset paths), repository category filtering and item lookup, Search matching by all four fields, case-insensitivity, whitespace trimming, empty/cleared query and no-match behavior, and QR parser acceptance/rejection.
- **Widget tests:** Verify initial Home content, in-place category filtering, All Items completeness, correct item details and back navigation, Search input/results/empty state and selection, bottom navigation destinations, notice-only Orders/Profile interaction and dismissal, and scanner invalid/error states. Verify one valid QR callback causes only one navigation action using a testable scanner boundary.
- **Device/platform tests:** On a physical Android device, build/install the release app and exercise Home/category filtering, All Items/details/back, Search, placeholder notices, offline behavior, scanner valid/invalid flows, and camera denial/unavailability. Check responsive behavior at a narrow phone width (about 360 logical pixels), a wider phone, safe areas, scrolling, and larger text. Test iOS only in an available Apple environment and record the actual device/simulator, build, and results. Document acceptance evidence and defects in `docs/QA.md` when QA is performed.
