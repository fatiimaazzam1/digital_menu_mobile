# Digital Menu Mobile Design

## 1. Overview and source references

This document translates the approved product scope into screen-level design guidance for the native Flutter application. The **PRD is the product source of truth**; [ARCHITECTURE.md](./ARCHITECTURE.md) describes the implemented Flutter structure, local data flow, and navigation. The approved ARDO Figma Make design evidence is a visual reference, not proof of implementation.

### Evidence and limitations

- The Figma Make project is identified by file key `KewPu6ikVpqYgj8hitWJqu`.
- A user-provided, read-only CSS attachment from the Make project is available as design evidence. It contains ARDO-related styles, typography imports, color tokens, component selectors, scanner/search styles, image URL references, and responsive CSS breakpoints. The values below are transcribed from that attachment, not independently checked against current Figma MCP source.
- `src/App.tsx`, `src/index.css`, and the actual `public/menu/` files were not available for direct inspection when this document was prepared. The exact component hierarchy, full interaction logic, image inventory, and image licensing/provenance therefore remain unverified.
- Twelve sample menu photos are now bundled under `assets/images/menu/`; their Commons source and license details are recorded in [MVP.md](./MVP.md). They are not verified ARDO/Figma assets.
- The current Flutter UI implements the palette, a dark ARDO header, a Search shortcut, circular category icons, and responsive item cards. The exact Figma component structure and original Figma images remain unverified.

## 2. ARDO visual system

The visual direction is a refined restaurant menu: ARDO branding, deep navy surfaces, warm ivory/cream content areas, restrained gold accents, and food photography. Preserve this identity when adapting the prototype to Flutter.

### Palette evidenced in the supplied CSS attachment

| Token | Value | Intended use indicated by token/style references |
|---|---|---|
| `navy-950` | `#091326` | Deep app/header/scanner background |
| `navy-900` | `#101d36` | Navigation, cards, and dark controls |
| `navy-800` | `#1d3764` | Secondary navy surfaces/gradients |
| `navy-700` | `#284a7d` | Links, prices, and supporting emphasis |
| `gold-500` | `#c9a75c` | Accent rules and active indicators |
| `gold-300` | `#e5cf9d` | Gold highlights on dark surfaces |
| `ivory` | `#f7f3ea` | Main screen background |
| `paper` | `#fffdf8` | Cards and light surfaces |
| `ink` | `#172034` | Primary text |
| `muted` | `#73788a` | Secondary text |
| `line` | `#e6e0d5` | Light dividers/borders |
| `error` | `#b44b45` | Error token |
| `success` | `#3b755d` | Success token |

The CSS also sets a shadow token `0 20px 60px rgba(7, 17, 38, 0.16)`. These are prototype design references; verify final contrast and rendering in Flutter, especially muted text and gold on light backgrounds.

### Typography

The supplied CSS imports:

- **Cormorant Garamond** weights 500, 600, 700 for editorial headings, item names, and brand lettering.
- **Manrope** weights 400, 500, 600, 700 for body copy, controls, navigation labels, and supporting text.

The font files and their offline availability are not present in project assets. The current Flutter implementation uses the platform system font; it does not claim to bundle Cormorant Garamond or Manrope. Preserve readable system text scaling unless licensed local font files are approved and added.

### Components, spacing, imagery, and controls

The supplied CSS indicates rounded menu cards, category chips, compact list cards, navy/gold controls, subtle borders/shadows, and a four-destination bottom navigation. Treat those as visual references rather than reusable Flutter components.

Prototype examples include a 20–24 px content inset, 6 px category-chip spacing, 12 px featured-card spacing, rounded card corners around 14–18 px, and a 72 px bottom-navigation surface. These are starting references only; adapt them to Flutter constraints, platform safe areas, and readable touch targets instead of copying fixed sizes indiscriminately.

Food photography is central to the visual direction. The CSS references `/menu/duck-breast.jpg` in the Home hero and `/menu/burrata-garden.jpg` in a scanner background. This does **not** confirm that these files exist or are approved item assets. See [Images and assets](#7-images-and-assets).

## 3. Screen-by-screen specifications

### Menu Home

**Purpose:** Initial destination; supports the mandatory category-browsing feature.

**Content and behavior**

- ARDO-branded header and menu introduction using the approved dark/light visual system.
- Horizontally scrollable circular icon controls for the four approved groups: **Drinks, Starters, Mains, Desserts**. A selected control filters the item content directly on Menu Home; do not push a separate category screen.
- Menu item cards with the item’s image, name, price, and display note where the approved visual layout provides it. Selecting a card opens that item’s Item Details.
- Tapping the Home Search shortcut selects the Search tab. It does not prefill or automatically focus the search field; the user enters a query separately on Search.
- A reachable **All Items** action. The current core branch includes a disabled **Scan Menu QR** integration point labelled as unavailable; real scanning belongs to the separate QR feature branch.
- Bottom navigation visible on this screen: Home, Search, Orders, Profile.
- Orders/Profile selection shows only the “Not included in this version” notice, with a clear dismissal/return interaction; no business page is opened.

**States**

- Normal: initial category/menu view is immediately available from local data.
- Selected category: chip selection is visibly distinct and the displayed items are filtered.
- Empty category results are not expected for the approved sample distribution; do not invent such a state unless data validation exposes a real case.
- No network loading state is required for local menu data.

### Search

**Purpose:** User-approved additional feature; searches the local menu without a backend.

**Content and behavior**

- Search field and result count/summary styled consistently with ARDO.
- Trim surrounding query whitespace and search case-insensitively over each item’s **name, category, description, and display note**.
- Empty query shows all 12 items. Clearing a query restores all 12 items.
- Matching results display the existing menu-item presentation; selecting a result opens its correct Item Details.
- A query with no matches shows an understandable empty-results message. Exact copy should follow verified Figma source if available.
- Bottom navigation remains visible on Search: Home, Search, Orders, Profile. Orders/Profile retain the notice-only interaction.
- Do not add advanced filters, remote suggestions, or remote search.

**States**

- Empty query/all items.
- Non-empty query with results.
- No matches/empty results.
- Query being edited; keyboard visible and content remains usable above it.
- Clear action restores the all-items state.
- No asynchronous network loading state is required; show a loading indicator only if a real implementation operation introduces a noticeable delay.

### All Items

**Purpose:** Mandatory dedicated listing of the full menu.

**Content and behavior**

- Show all 12 items grouped by their four category headings.
- Display item name and price in the list; retain associated image and display note where the approved card treatment includes them.
- Selecting any item opens its matching Item Details.
- Provide a visible back action to the originating browsing context. The bottom tab bar is not required on this pushed screen.
- Data and imagery are bundled/local; no network loading state.

### Item Details

**Purpose:** Mandatory item-detail feature.

**Content and behavior**

- Correct selected item’s image, name, nonempty description, USD price, and category association; show the display note as item content when present in the approved data/design.
- A visible back action returns to the preceding Home, All Items, or Search context.
- Do not mix details from different item selections.
- Avoid adding order/cart actions; those features are outside the approved scope.

**States**

- Normal with selected item data.
- Invalid/missing item reference should follow a clear safe fallback/back path in implementation; exact error presentation is not specified by the PRD and should remain minimal.
- Local image failure should not crash the screen; the replacement/fallback treatment needs a design decision after the actual image set is known.

### QR Scanner

**Purpose:** Approved additional feature using a real camera in the installed Flutter app.

**Content and behavior**

- Open from the Menu Home **Scan Menu QR** action.
- Use a real Android/iOS camera preview and scanner integration; prototype simulation buttons or decorative-only scanning are not acceptable as production behavior.
- Recognize only `digital-menu:sample-01`, then return to/open the same locally stored menu without a network request.
- Pause/guard scan handling after the first valid result to prevent duplicate navigation.
- Provide an exit/back action to the originating browsing context. Bottom navigation is not required on this pushed screen.
- The prepared QR is generated outside the app. Scanning it with the phone’s default camera is not an app-launch route.

**States**

- Camera permission requested when scanner access is needed.
- Active camera preview/scanning state.
- Valid scan: one navigation action to the existing local menu.
- Invalid QR: understandable error with retry or exit; never open arbitrary links.
- Camera denied/unavailable: clear explanation and route back to normal browsing without crash.
- Camera initialization indicator only if startup is perceptibly delayed; local menu screens do not need loading indicators.

### Orders and Profile notice-only tabs

Orders and Profile remain visible in the bottom navigation on Home and Search. Selecting either displays only **“Not included in this version”** and a clear dismissal/return interaction. They are not separate business screens and must not expose order/profile data, forms, actions, account functionality, or navigation into such flows.

## 4. Navigation and interactions

```text
App launch
  └─ Home (bottom navigation visible)
       ├─ Select category chip → Home remains open; item list filters in place
       ├─ Select item → Item Details → Back → originating Home
       ├─ All Items → Back → originating Home
       │    └─ Select item → Item Details → Back → All Items
       ├─ Scan Menu QR → Scanner → Back/exit → originating Home
       │    ├─ valid demo value → same local menu (once only)
       │    ├─ invalid value → retry or exit
       │    └─ denied/unavailable camera → exit to normal browsing
       ├─ Search tab → Search (bottom navigation visible)
       │    └─ select result → Item Details → Back → Search
       ├─ Orders tab → “Not included in this version” notice → dismiss → prior tab
       └─ Profile tab → “Not included in this version” notice → dismiss → prior tab
```

Home and Search retain the bottom navigation. All Items, Item Details, and QR Scanner are pushed experiences with an appropriate back/exit action; do not require the tab bar on them. Preserve originating browsing context when returning. Orders/Profile are notice interactions, not routes to functional pages.

## 5. Responsive Android/iOS design

The Figma Make design is a web prototype; its CSS includes a centered mobile shell capped around 390 px, a minimum screen height of 844 px, fixed-height visual regions, and breakpoints around 420 px and 365 px. These constraints are not the Flutter layout specification. The Flutter Home grid uses two columns from 340 logical pixels when text scaling is standard and switches to one column for larger text or narrower widths. A widget test exercises 360 logical pixels and larger text; physical-device behavior remains unverified.

For native Flutter:

- Use available screen constraints and flexible layouts rather than a fixed 390 × 844 viewport.
- Respect Android and iOS safe areas, system bars, and bottom insets. Keep bottom navigation clear of system gesture areas.
- On narrow phones, allow horizontal category-chip scrolling, wrap long labels/content, and avoid card/detail overflow. Reflow content rather than shrinking text below comfortable readability.
- On wider phones, retain a phone-oriented reading width and use deliberate margins; avoid stretching text and card content across the full width.
- Make long Home, Search, All Items, and Detail content vertically scrollable. Keep controls reachable when content scrolls.
- Handle Search keyboard insets so the field/results remain visible and the keyboard does not cover the active result/content.
- Support larger system text scaling, multiline names/descriptions, and price layouts without clipping or overlap.
- In landscape where practical, preserve usable scanner framing and scrollable menu/detail content; do not assume a portrait-only fixed height.
- Keep image crops intentional across aspect ratios, using the approved source image and a consistent fit/crop treatment.
- Verify layouts on narrow and wider Android/iOS phone configurations. PRD specifically calls for a narrow layout around 360 logical pixels, safe areas, larger text, and physical Android device testing.

These are implementation/design requirements, not claims that responsive behavior has already been tested. Native iOS build/runtime verification remains unconfirmed until actually exercised in an Apple environment.

## 6. Accessibility

- Use readable text sizes and preserve Flutter system text scaling; avoid hard-coded prototype font sizes that prevent enlargement.
- Ensure sufficient foreground/background contrast, especially muted text on ivory and gold accents on light surfaces.
- Provide semantic labels for category chips, item cards, prices, navigation destinations, search clear action, back/exit controls, and scanner state/actions.
- Communicate selected category and selected navigation destination programmatically and visually, not by color alone.
- Ensure interactive targets are comfortably tappable and do not rely on tiny icon-only affordances without labels/semantics.
- Maintain logical screen-reader reading order and meaningful image descriptions for menu photography; decorative images should not create redundant announcements.
- Give Search results, no-results, camera permission, camera unavailable, and invalid QR feedback understandable text.
- Check keyboard focus/activation for interactive controls where supported by the native platform, as well as larger text and safe-area behavior.

The PRD does not specify a formal WCAG conformance level; none is claimed here.

## 7. Images and assets

### Confirmed local project assets

Twelve local JPEG sample photos are bundled under `assets/images/menu/` and declared in `pubspec.yaml`. The file names correspond to the 12 sample item records; all 12 files are checked by a repository test and were visually reviewed for broad item correspondence. Provenance and license links are recorded in [MVP.md](./MVP.md). They are sample assets, not verified ARDO/Figma photography. On-device crop/rendering and offline loading remain unverified.

### References visible in supplied CSS (not verified files)

| Prototype reference | CSS use | Verification status |
|---|---|---|
| `/menu/duck-breast.jpg` | Home hero background | URL observed in provided CSS attachment; actual file, rights, and menu-item mapping unverified |
| `/menu/burrata-garden.jpg` | Scanner background | URL observed in provided CSS attachment; actual file, rights, and menu-item mapping unverified |

Do not assume these two references are the full set or correct final item images. Obtain the actual approved `public/menu/` files and confirm their provenance and mapping before implementation.

### Implementation asset requirements

- Menu photos are stored under `assets/images/menu/`; each item has a required local path and the directory is registered in `pubspec.yaml`.
- Repository tests verify every referenced file exists. Flutter asset bundling is configured, but a release APK build is still required to verify packaging.
- Attribution, source links, and licenses are recorded in [MVP.md](./MVP.md). These files must not be described as ARDO/Figma assets.
- `MenuItemImage` uses a semantic label and a visual fallback. Runtime image loading and crop behavior still need device verification.
- No local Cormorant Garamond or Manrope font files are present; the app uses system fonts.

## 8. Empty, loading, unavailable, and error states

| Context | Required design behavior |
|---|---|
| Local menu startup | Menu is available immediately; no network loading state. |
| Search empty query | Display all 12 items. |
| Search no matches | Explain that no matching menu items were found; keep query editable/clearable. |
| Search clear | Restore all 12 items. |
| Empty category | Not expected with the approved sample data; do not invent a special page absent a real empty dataset case. |
| Item image unavailable | Prevent crash and preserve legible item details; choose a minimal fallback after the approved asset inventory is available. |
| Missing/invalid detail item | Provide a safe return to prior browsing; exact copy is an implementation decision. |
| Scanner starting | Show an indicator only if camera initialization causes a noticeable delay. |
| Camera permission denied/unavailable | Explain scanner cannot proceed and provide exit/back to normal menu. |
| Unsupported QR value | Explain unsupported code and allow retry or exit; never redirect. |
| Valid QR | Open the same local menu exactly once. |
| Orders/Profile selected | Show only “Not included in this version”; dismissal returns to prior tab. |

## 9. Requirements traceability

Architecture paths refer to the current structure described in [ARCHITECTURE.md](./ARCHITECTURE.md). This matrix records design coverage, not proof that every criterion passed testing.

### Functional scenarios

| PRD requirement | Design coverage | Architecture component |
|---|---|---|
| FS-01 — View categories | Menu Home initially shows four recognizable circular category controls and items. | `menu_home_screen.dart`, `menu_repository.dart` |
| FS-02 — Browse category | Selecting a category control filters Home in place. | `menu_home_screen.dart`, `menu_repository.dart` |
| FS-03 — Browse all | All Items displays all 12 records grouped by category. | `all_items_screen.dart`, `menu_repository.dart` |
| FS-04 — Inspect item | Item Details shows the selected image, category, name, description, note, and price. | `menu_item_card.dart`, `menu_item_image.dart`, `item_detail_screen.dart` |
| FS-05 — Return to browsing | Back from details returns to the originating Home, All Items, or Search context. | `item_detail_screen.dart`, `app/app.dart` |
| FS-06 — Valid QR | Planned separate-branch scanner validates the fixed value and opens the same local menu once. | Not implemented on core branch |
| FS-07 — Invalid QR | Planned clear unsupported-code state with retry or exit; no redirect. | Not implemented on core branch |
| FS-08 — No camera access | Planned permission-denial/unavailability handling. | Not implemented on core branch |
| FS-09 — Search local menu (approved addition) | Trim, case-insensitive matching on name/category/description/note; all items for empty/cleared query; empty-results state; select result for details. | `search_screen.dart`, `menu_repository.dart`, `menu_item.dart`, `item_detail_screen.dart` |
| FS-10 — Orders/Profile notice (approved addition) | Visible tabs on Home/Search; selection shows notice only; dismiss returns to prior tab. | `app/app.dart` |

### Acceptance criteria

| PRD criterion | Design coverage / non-UI verification | Architecture component |
|---|---|---|
| AC-01 | Menu Home initial layout is clean and usable. | `menu_home_screen.dart`, `app/app.dart` |
| AC-02 | Readable food/drink category labels. | `menu_home_screen.dart` |
| AC-03 | Home category controls filter the correct items in place. | `menu_home_screen.dart`, `menu_repository.dart` |
| AC-04 | All Items is reachable and presents all 12 items/four categories. | `all_items_screen.dart`, `menu_repository.dart` |
| AC-05 | Each detail displays correct name, nonempty description, USD price, and image. | `item_detail_screen.dart`, `menu_item.dart` |
| AC-06 | At least two item selections show their own matching details. | `menu_item_card.dart`, `item_detail_screen.dart` |
| AC-07 | Visible details back action returns to browsing. | `item_detail_screen.dart`, `app/app.dart` |
| AC-08 | Local data/assets support offline menu, details, and images; requires implementation/device verification, not design alone. | `sample_menu_data.dart`, `menu_repository.dart`, asset bundle |
| AC-09 | Narrow (~360 logical px) and wider phone, text scaling, safe areas, no overflow; requires layout/device QA. | `app/app.dart`, `menu_home_screen.dart`, and other screens |
| AC-10 | Orders/Profile tab interaction is notice-only; no business screens. | `app/app.dart` |
| AC-11 | Visible controls have real specified interactions; implementation verification required. | All interactive screens/widgets |
| AC-12 | Android release build/install and physical-device core flow; build/device QA, not UI design. | Whole app; test record in `docs/QA.md` |
| AC-13 | Android/iOS Flutter targets; native iOS verified only after actual Apple-environment build/runtime test. | Flutter platform projects; device QA |
| AC-14 | Scan action is a disabled integration point; a real camera scanner is pending the QR branch. | `menu_home_screen.dart`; scanner not implemented |
| AC-15 | Valid scan behavior is pending. | Scanner not implemented |
| AC-16 | Invalid QR behavior is pending. | Scanner not implemented |
| AC-17 | Camera permission/unavailable behavior is pending. | Scanner not implemented |
| AC-18 | Duplicate-result handling is pending. | Scanner not implemented |
| AC-19 | Runnable source/setup/essential docs; delivery/documentation criterion, not UI design. | Repository and README |
| AC-20 | Local device demonstration without public deployment; demonstration criterion requiring actual device run. | Whole app; QA record |
| AC-21 | No secrets/private machine configuration; repository/security hygiene criterion, not UI design. | Repository review |
| AC-22 | Four bottom tabs visible on Home/Search; pushed screens return by back/exit without requiring tabs. | `app/app.dart`, `menu_home_screen.dart`, `all_items_screen.dart`, `item_detail_screen.dart` |
| AC-23 | Search matching/empty/clear/result-to-detail behavior; implementation and widget verification required. | `search_screen.dart`, `menu_repository.dart`, `item_detail_screen.dart` |
| AC-24 | Orders/Profile show only informational notice; no business behavior. | `app/app.dart` |

## 10. Open implementation questions and verifiable design decisions

### Decisions fixed by PRD/architecture

- Home category controls filter directly on Menu Home; no separate Category screen.
- Search rules are fixed: trim query, case-insensitive match on name/category/description/display note; empty/cleared query returns all 12; no-match state; result opens correct detail.
- Bottom navigation is visible on Home and Search. All Items, Item Details, and QR Scanner use appropriate back/exit navigation.
- Orders/Profile tabs show only “Not included in this version.”
- The app uses local data and bundled menu assets. The current core branch has a disabled Scan Menu QR control; the real scanner using the single accepted demo value is pending.
- Flutter native widgets/styles are used for implementation; Tailwind is not used in Flutter.

### Remaining design and implementation verification

1. Obtain the actual Figma Make `src/App.tsx`, `src/index.css`, and `public/menu/` assets to verify exact content copy, component structure, all screen interactions, and full image inventory.
2. Figma image URLs remain unverified. The local Commons sample assets and their sources/licenses are recorded in [MVP.md](./MVP.md); they are not the referenced ARDO assets.
3. Cormorant Garamond and Manrope files are absent; the current app uses the platform system font.
4. Search implementation and behavior are covered by repository/widget tests. Offline use still needs physical-device verification.
5. Select a maintained Android/iOS scanner package on the QR feature branch and verify its permission requirements on both platforms.
6. Physical Android device testing is blocked because no Android device/emulator is connected to the current environment. iOS native build/runtime testing requires macOS/Xcode and is not verified.

No conflict with the approved PRD or architecture is introduced by this design specification. The main implementation correction is to adapt the web prototype’s fixed dimensions and CSS behavior to responsive native Flutter layouts while retaining the approved visual identity.
