# Digital Menu Mobile Design

## 1. Overview and Source References

This document translates the approved product requirements into screen-level design guidance for the native Flutter application.

- **PRD.md** is the product requirements source of truth.
- **ARCHITECTURE.md** describes the Flutter structure, local data flow, and navigation.
- **MCP.md** records the design-tool integration and related evidence.
- **POC.md** records proof-of-concept experiments and their results.
- **MVP.md** records the implemented MVP scope, setup, and asset information.
- **QA.md** records actual test execution and verification results.
- **REVIEW.md** summarizes the final implementation review, known limitations, and remaining risks.

The approved ARDO Figma Make design is a visual reference. It is not, by itself, evidence that the same design or behavior has been implemented in Flutter.

### Evidence and limitations

- The Figma Make project was identified in prior project notes by file key `KewPu6ikVpqYgj8hitWJqu`. Its full contents have not been independently verified during this document update.
- Earlier notes refer to a user-provided, read-only CSS attachment from the Make project. The raw attachment was not available for independent inspection. CSS values, selectors, image URLs, and breakpoints from those notes are therefore historical references.
- The original prototype files `src/App.tsx`, `src/index.css`, and the complete `public/menu/` image inventory were not available for direct inspection during this update. Exact prototype component structure, original interaction logic, and image provenance remain unverified.
- Twelve sample menu images are bundled under `assets/images/menu/`. Their source and stated license information are documented in `MVP.md`; current license terms and visual suitability have not been independently verified here.
- The Flutter implementation uses ARDO-inspired navy, ivory, and gold styling, a branded Home header, category controls, menu cards, Search, bottom navigation, and an in-app QR scanner. This does not establish pixel-perfect equivalence with the original Figma prototype.
- The user previously reported testing the scanner on a physical device, where the supported menu was recognized and Continue opened the menu. Complete device, operating-system, build, and test-step details were not available for independent verification.

## 2. ARDO Visual System

The intended visual direction is a refined restaurant menu using ARDO branding, deep navy surfaces, warm ivory or cream content areas, restrained gold accents, and food photography.

The Flutter implementation uses a local branding asset in the Home header and as launcher artwork. Its origin and authorship are not established by this document, and it is not verified as an original Figma-provided image.

### Historical CSS palette reference

The following palette was transcribed in earlier project notes. The raw CSS was not available for independent verification, so these values must not be treated as independently verified Figma evidence.

| Token | Historical value | Intended use |
|---|---|---|
| `navy-950` | `#091326` | Deep background |
| `navy-900` | `#101d36` | Navigation, cards, and dark controls |
| `navy-800` | `#1d3764` | Secondary navy surfaces |
| `navy-700` | `#284a7d` | Links and supporting emphasis |
| `gold-500` | `#c9a75c` | Accent rules and active indicators |
| `gold-300` | `#e5cf9d` | Highlights on dark surfaces |
| `ivory` | `#f7f3ea` | Main screen background |
| `paper` | `#fffdf8` | Cards and light surfaces |
| `ink` | `#172034` | Primary text |
| `muted` | `#73788a` | Secondary text |
| `line` | `#e6e0d5` | Dividers and borders |
| `error` | `#b44b45` | Error emphasis |
| `success` | `#3b755d` | Success emphasis |

Earlier notes also mention a CSS shadow reference of `0 20px 60px rgba(7, 17, 38, 0.16)`. This is a historical prototype reference, not a verified Flutter shadow specification.

The Flutter source uses colors including `#101d36`, `#c9a75c`, `#fffdf8`, `#f7f3ea`, `#e5cf9d`, `#e6e0d5`, `#73788a`, `#1d3764`, and `#172034`. The actual source code remains the authority for the current implementation.

Contrast, especially muted text on ivory and gold accents on light backgrounds, should be checked during accessibility review.

### Typography

Earlier project notes describe the prototype as using:

- **Cormorant Garamond**, weights 500, 600, and 700, for editorial headings and branding.
- **Manrope**, weights 400, 500, 600, and 700, for body text and controls.

The original CSS imports were not available for independent verification. The Flutter project does not bundle local font files for these families and uses the platform system font.

The native app should preserve readable system text scaling. Custom fonts should only be introduced if approved, appropriately licensed files are obtained and added to the Flutter asset configuration.

### Components, spacing, imagery, and controls

Earlier notes describe rounded cards, category controls, compact item cards, navy and gold controls, subtle borders, and four-destination bottom navigation. These descriptions are historical prototype references rather than independently verified Figma specifications.

The Flutter implementation uses shared spacing and radius constants from `lib/app/design_tokens.dart`, alongside screen-specific styling.

The design should prioritize:

- Clear visual hierarchy between branding, categories, menu content, and navigation.
- Consistent spacing and corner treatments.
- Readable names, descriptions, notes, and prices.
- Responsive image cropping.
- Comfortable touch targets.
- Native safe-area and keyboard behavior.

Do not copy fixed prototype dimensions indiscriminately into native Flutter layouts.

## 3. Screen-by-Screen Specifications

### 3.1 Menu Home

**Purpose:** Initial destination and primary entry point for mandatory category browsing.

**Content and behavior**

- Display the ARDO-inspired branded header and menu introduction.
- Show horizontally scrollable circular category controls for **Drinks, Starters, Mains, and Desserts**.
- Selecting a category filters items directly on Home. Do not push a separate category screen.
- Display menu item cards with their images, names, USD prices, and display notes according to the implemented card layout.
- Selecting a card opens the corresponding Item Details screen.
- Provide a Search shortcut that selects the Search tab. The user enters a query separately; the shortcut does not automatically prefill or focus the search field.
- Provide an **All Items** action.
- Provide an enabled **Scan Menu QR** action that opens the in-app camera scanner.
- Display the four bottom-navigation destinations: Home, Search, Orders, and Profile.
- Orders and Profile display only the notice **"Not included in this version"**. They do not open business-feature screens.

**Implemented Flutter layout**

- Home uses a shared 16-logical-pixel horizontal content inset for its principal content.
- Search and QR controls use 16-pixel corners; menu photos use 12-pixel clipped corners.
- Vertical spacing uses shared values from `lib/app/design_tokens.dart` and screen-specific layout values.
- At widths of at least 340 logical pixels with standard text scaling, Home uses a two-column `SliverGrid` with a child aspect ratio of 0.62.
- At narrower widths or with larger text scaling, the layout uses a `SliverList` so cards can use natural height.
- Grid cards use constrained text layouts. Names and display notes have two-line limits, while prices must remain readable and must not be ellipsized.
- List cards use compact images, constrained text, and a price area that can wrap instead of truncating.
- Widget tests cover specified insets, corner radii, card geometry, price alignment, image bounds, text constraints, and selected narrow or large-text layouts.

These automated checks provide layout evidence under their tested conditions. They do not replace physical-device visual inspection.

**States**

- **Initial:** Display the locally bundled categories and menu items.
- **Selected category:** Visually distinguish the selected category and show its matching items.
- **Empty category:** Not expected with the approved sample distribution. Do not invent a separate empty-category flow without a real use case.
- **Loading:** No network loading state is required for local menu data.
- **Error:** Image failures should not crash the screen; use the existing image fallback.

### 3.2 Search

**Purpose:** Approved additional feature for searching the local menu without a backend.

**Content and behavior**

- Display a search field and matching menu results.
- Trim surrounding query whitespace and perform case-insensitive matching against each item's name, category name, description, and display note.
- An empty query returns all 12 items.
- Clearing the query restores all 12 items.
- Selecting a result opens the matching Item Details screen.
- A query with no matches displays a clear empty-results message.
- Keep Home, Search, Orders, and Profile in the bottom navigation.
- Orders and Profile retain their notice-only behavior.
- Do not add remote search, remote suggestions, or unapproved advanced filters.

**States**

- Empty query displaying all items.
- Non-empty query with matching results.
- Non-empty query with no results.
- Query editing with the keyboard visible.
- Cleared query with all items restored.

No asynchronous network loading indicator is required for local search.

### 3.3 All Items

**Purpose:** Mandatory dedicated listing of the complete menu.

**Content and behavior**

- Display all 12 sample menu items grouped under the four category headings.
- Display the appropriate item information, including name and price, using the implemented card presentation.
- Selecting an item opens the corresponding Item Details screen.
- Provide a visible back action.
- Returning from All Items restores the originating Home route.
- The bottom-navigation bar is not required on this pushed screen.
- Data and images are local; no network loading state is required.

### 3.4 Item Details

**Purpose:** Mandatory item-detail feature.

**Content and behavior**

- Display the selected item's correct image, name, category, description, display note, and USD price.
- Ensure information belongs to the selected item and is not mixed with another record.
- Provide a visible back action returning to the originating Home, All Items, or Search context.
- Do not add order, cart, account, or payment functionality; these are outside the approved scope.

**States**

- **Normal:** Display the selected item's data.
- **Invalid or missing item:** Display the implemented safe not-found message and preserve a safe back-navigation path.
- **Image unavailable:** Use the existing image fallback without preventing the remaining details from being displayed.

### 3.5 QR Scanner

**Purpose:** Implemented additional feature that scans a supported QR payload using the installed Flutter app's camera integration.

**Entry point**

The **Scan Menu QR** action on Home opens the in-app camera scanner. The feature uses `mobile_scanner`; it is not a decorative scanning screen or a simulated prototype interaction.

**Scanner presentation**

- Show the live camera preview.
- Use a centered bracket frame and a shaded overlay outside the frame.
- Provide a short instruction such as "Place the QR code inside the frame."
- Keep the frame usable within the available preview area.
- Provide an exit or back action to return to the originating menu.

**Supported payload and behavior**

The parser accepts only this exact payload:

`digital-menu:sample-01`

- Require three consecutive matching detections, with consecutive detections no more than 700 milliseconds apart.
- Reject unsupported payloads, including URLs, without opening external links.
- Stop scanning after stable recognition.
- Display **Menu recognized** and a **Continue** action.
- Continue returns a success result to Home, which opens the existing All Items screen over the original Home route.
- Back from All Items returns to the original Home route.
- Ignore late scanner callbacks after the scanner screen has been disposed.

The QR feature opens the locally bundled menu. It does not require a backend, a public website, or a remote menu API.

**States**

- **Starting:** Show a progress indicator only if camera initialization causes a noticeable delay.
- **Scanning:** Show the live preview and scanning frame.
- **Valid QR:** Stop scanning and display the recognition state with Continue.
- **Invalid QR:** Show understandable retry feedback without opening a URL.
- **Camera denied or unavailable:** Explain why scanning cannot continue and provide a way back to normal menu browsing.
- **Exit:** Return to the originating browsing context.

Automated tests cover the parser and camera-independent scanner behavior, including stable recognition, navigation, duplicate detections, late callbacks, and relevant error paths. These tests do not prove that native camera permission prompts or physical-camera behavior work on every device.

The user has reported a successful physical-device scan of the supported menu. The available record does not independently establish full Android/iOS compatibility or verification of every permission and error scenario. Refer to `QA.md` for the actual verification record.

The prepared QR code is generated outside the app. Scanning it with the phone's default camera is not an app-launch route.

### 3.6 Orders and Profile

Orders and Profile remain visible in the bottom navigation on Home and Search.

Selecting either tab displays only:

**Not included in this version**

Dismissing the notice returns the user to the previous functional tab.

These tabs must not implement order history, profile data, authentication, forms, account actions, or navigation into unapproved business flows.

## 4. Navigation and Interactions

```text
App launch
└── Home (bottom navigation visible)
    ├── Select category
    │   └── Filter Home in place
    ├── Select item
    │   └── Item Details
    │       └── Back to originating Home
    ├── All Items
    │   ├── Back to originating Home
    │   └── Select item
    │       └── Item Details
    │           └── Back to All Items
    ├── Scan Menu QR
    │   ├── Back/exit to originating Home
    │   ├── Valid payload
    │   │   └── Menu recognized
    │   │       └── Continue
    │   │           └── Existing All Items route
    │   │               └── Back to original Home
    │   ├── Invalid payload
    │   │   └── Retry or exit
    │   └── Camera denied/unavailable
    │       └── Return to normal browsing
    ├── Search tab
    │   ├── Search local items
    │   └── Select result
    │       └── Item Details
    │           └── Back to Search
    ├── Orders tab
    │   └── Notice → dismiss → previous functional tab
    └── Profile tab
        └── Notice → dismiss → previous functional tab
```

Home and Search retain the bottom navigation. All Items, Item Details, and the QR Scanner are pushed experiences with appropriate back or exit behavior. The original browsing context should be preserved.

Orders and Profile are notice interactions, not functional business routes.

## 5. Responsive Android/iOS Design

Earlier notes describe a Figma Make prototype with a centered mobile shell, fixed-height visual regions, and breakpoints around 420 and 365 pixels. The raw CSS was not available for verification. These values are historical prototype references, not the Flutter layout specification.

The current Home layout uses a two-column grid from 340 logical pixels under standard text scaling and switches to a list for narrower widths or larger text scaling.

For native Flutter:

- Use available screen constraints and flexible layouts rather than a fixed 390 × 844 viewport.
- Respect Android and iOS safe areas, system bars, and bottom insets.
- Keep bottom navigation clear of system gesture areas.
- Allow horizontal scrolling for category controls on narrow screens.
- Prevent long labels, descriptions, and prices from overflowing or being clipped.
- Reflow content instead of reducing text below a comfortable readable size.
- Keep Home, Search, All Items, and Item Details content vertically scrollable when necessary.
- Ensure the Search field and results remain usable while the keyboard is visible.
- Support larger system text scaling and multiline content.
- Keep image crops appropriate to the card's available aspect ratio.
- Preserve a usable scanner frame in the available camera preview.
- Review portrait and landscape layouts where practical.

**Future improvement, not currently implemented:** Wider phones could benefit from a deliberate maximum content width and larger outer margins. The current Home layout does not enforce a maximum content-width constraint.

Widget tests cover selected narrow and larger-text layouts. These tests do not establish full physical-device compatibility.

The PRD's responsive acceptance criteria, including narrow phone layouts, safe areas, text scaling, and Android device testing, must be verified through the QA process. Native iOS build/runtime verification requires a compatible Apple development environment and remains unverified.

## 6. Accessibility

The following are design and implementation requirements, not claims that accessibility acceptance testing is complete.

- Preserve readable text and Flutter's system text scaling.
- Check foreground/background contrast, particularly muted text on ivory and gold accents on light backgrounds.
- Provide meaningful semantic labels for category controls, item cards, navigation destinations, search actions, and scanner controls.
- Expose the selected category and selected navigation destination both visually and programmatically.
- Ensure touch targets are comfortably tappable.
- Avoid unlabeled icon-only controls.
- Maintain logical screen-reader reading order.
- Provide meaningful image descriptions for menu photography and avoid redundant announcements for decorative imagery.
- Make Search empty-results, invalid QR, camera permission, and camera unavailable messages understandable.
- Verify keyboard focus and activation behavior where supported.
- Test larger text, safe areas, and screen-reader behavior on supported devices.

Widget tests and the presence of semantic labels do not establish contrast compliance or complete screen-reader accessibility. The PRD does not specify a formal WCAG conformance level; this document does not claim one.

## 7. Images and Assets

### Confirmed local project assets

Twelve sample JPEG photos are bundled under `assets/images/menu/` and registered in `pubspec.yaml`.

Menu item records reference local image paths, and repository tests check that referenced files exist. File-existence tests do not verify visual suitability, licensing, or whether every photo accurately represents its associated menu item.

Source and stated license information are recorded in `MVP.md`. Current license terms and visual correspondence have not been independently verified in this update.

These are sample assets, not verified original ARDO/Figma photographs.

### Historical CSS URL references

Earlier project notes mention these prototype URLs:

| Prototype reference | Previously described use | Verification status |
|---|---|---|
| `/menu/duck-breast.jpg` | Home hero background | Original CSS and actual file not independently verified |
| `/menu/burrata-garden.jpg` | Scanner background | Original CSS and actual file not independently verified |

Do not assume that these references are the complete asset inventory or that the files exist in the current Flutter project. Obtain the original assets and confirm their source, rights, and intended use before treating them as approved design evidence.

### Implementation asset requirements

- Keep menu photos under `assets/images/menu/`.
- Ensure each menu item's image path points to a real bundled file.
- Keep asset registration in `pubspec.yaml` aligned with the project structure.
- Preserve source and license information in `MVP.md`.
- Use the existing image widget's fallback to prevent missing images from breaking the screen.
- Verify image rendering, cropping, and release packaging through actual build and device checks.
- Do not claim that sample photos are original ARDO/Figma assets without evidence.
- Do not claim that Cormorant Garamond or Manrope are bundled fonts; the current app uses the platform system font.

## 8. Empty, Loading, Unavailable, and Error States

| Context | Required behavior |
|---|---|
| Local menu startup | Display the bundled menu without a network loading state. |
| Search with empty query | Show all 12 items. |
| Search with no matches | Explain that no matching items were found and allow the query to be edited or cleared. |
| Search clear action | Restore all 12 items. |
| Empty category | Not expected with the approved sample distribution; do not invent a special flow without a real use case. |
| Item image unavailable | Preserve readable item details and use the image fallback. |
| Invalid item reference | Display the implemented safe not-found message and preserve a back-navigation path. |
| Scanner starting | Show a progress indicator only if initialization causes a noticeable delay. |
| Camera permission denied | Explain that scanning cannot proceed and provide a route back to browsing. |
| Camera unavailable | Explain the issue and allow the user to return to the menu. |
| Unsupported QR payload | Provide retry feedback; never redirect to an arbitrary URL. |
| Valid QR payload | Stop scanning after stable recognition, display Menu recognized, and offer Continue to open All Items. |
| Orders/Profile selected | Show only the notice that the feature is not included in this version. |

These are the intended design behaviors. Actual verification status belongs in `QA.md`.

## 9. Requirements Traceability

This matrix links the PRD requirements to the intended design and relevant implementation components. It is a coverage map, not proof that every requirement has passed testing.

The FS and AC identifiers below should be retained only where they match the identifiers in the approved `PRD.md`. The PRD remains authoritative if any identifier or wording differs.

### Functional scenarios

| Requirement | Design coverage | Relevant implementation |
|---|---|---|
| FS-01 — View categories | Home displays the four category controls and menu items. | `menu_home_screen.dart`, `menu_repository.dart` |
| FS-02 — Browse category | Selecting a category filters Home in place. | `menu_home_screen.dart`, `menu_repository.dart` |
| FS-03 — Browse all | All Items displays the 12 records grouped by category. | `all_items_screen.dart`, `menu_repository.dart` |
| FS-04 — Inspect item | Details display the selected image, category, name, description, note, and price. | `item_detail_screen.dart`, `menu_item_image.dart` |
| FS-05 — Return to browsing | Back returns to the originating Home, All Items, or Search context. | `item_detail_screen.dart`, `app.dart` |
| FS-06 — Valid QR | The supported payload is recognized after stable detections; Continue opens All Items. Full camera/platform compatibility remains unverified. | `qr_payload_parser.dart`, `qr_scanner_screen.dart`, `menu_home_screen.dart` |
| FS-07 — Invalid QR | Unsupported payloads do not open links and provide retry feedback. | `qr_payload_parser.dart`, `qr_scanner_screen.dart` |
| FS-08 — Camera unavailable or denied | Provide an explanation and a way back to menu browsing. Automated UI coverage does not prove native permission behavior. | `qr_scanner_screen.dart`, Android and iOS permission configuration |
| FS-09 — Local Search, approved addition | Match name, category, description, and note; support empty, clear, no-match, and result-to-details behavior. | `search_screen.dart`, `menu_repository.dart` |
| FS-10 — Orders/Profile, approved addition | Visible tabs show the notice only and do not implement business features. | `app.dart` |

### Acceptance criteria

The following is the design-side coverage map for the acceptance criteria referenced in the current design notes. Confirm the exact identifiers and wording against the approved PRD before treating this as a definitive one-to-one mapping.

| Criterion | Design coverage or verification requirement | Relevant implementation |
|---|---|---|
| AC-01 | Home presents the menu in a clear, usable layout. | `menu_home_screen.dart`, `app.dart` |
| AC-02 | Category labels are recognizable and readable. | `menu_home_screen.dart` |
| AC-03 | Category selection filters the correct items in place. | `menu_home_screen.dart`, `menu_repository.dart` |
| AC-04 | All Items is reachable and presents the complete menu. | `all_items_screen.dart`, `menu_repository.dart` |
| AC-05 | Item Details displays the correct name, description, USD price, and image. | `item_detail_screen.dart`, `menu_item.dart` |
| AC-06 | Multiple item selections display their respective details. | `menu_item_card.dart`, `item_detail_screen.dart` |
| AC-07 | Back navigation returns to the originating browsing context. | `item_detail_screen.dart`, `app.dart` |
| AC-08 | Menu data and images are bundled for offline use; device behavior requires verification. | `sample_menu_data.dart`, `menu_repository.dart`, bundled assets |
| AC-09 | Narrow and wider layouts, text scaling, safe areas, and overflow are addressed. | Relevant screens and layout widgets; device QA required |
| AC-10 | Orders/Profile remain notice-only. | `app.dart` |
| AC-11 | Visible controls perform their specified interactions. | Relevant screens and widgets |
| AC-12 | Android release build, installation, and core physical-device flow are verified through QA. | Whole app; `QA.md` |
| AC-13 | Android/iOS targets are present; native iOS compatibility requires a real Apple-environment build/runtime check. | Flutter platform projects; `QA.md` |
| AC-14 | Home opens the in-app camera scanner. | `menu_home_screen.dart`, `qr_scanner_screen.dart` |
| AC-15 | A valid payload produces recognition and Continue opens All Items. | `qr_payload_parser.dart`, `qr_scanner_screen.dart`, `all_items_screen.dart` |
| AC-16 | Unsupported QR data produces retry feedback and no external navigation. | `qr_payload_parser.dart`, `qr_scanner_screen.dart` |
| AC-17 | Permission-denied/unavailable UI provides a safe way back to browsing. | `qr_scanner_screen.dart`, Android and iOS permission configuration |
| AC-18 | Stable detections result in one recognition/navigation transition. | `qr_scanner_screen.dart`, widget tests |
| AC-19 | Runnable source, setup instructions, and essential documentation are provided. | Repository and `README.md` |
| AC-20 | A local device demonstration can be performed without public deployment. | Whole app; demonstration evidence in QA/review records |
| AC-21 | No secrets or private machine configuration are committed. | Repository review |
| AC-22 | Four tabs remain visible on Home/Search; pushed screens use back/exit navigation. | `app.dart` and relevant screens |
| AC-23 | Search matching, empty query, clear, no-match, and result-to-details behavior are implemented. | `search_screen.dart`, `menu_repository.dart`, `item_detail_screen.dart` |
| AC-24 | Orders/Profile display only the informational notice. | `app.dart` |

Do not mark a criterion as passed solely because it appears in this matrix. Use `QA.md` for evidence and actual test results.

## 10. Open Design Questions and Verification

### Decisions established by the approved scope and implementation

- Home category controls filter the existing Home screen; there is no separate category route.
- Search trims the query and performs case-insensitive local matching on item name, category, description, and display note.
- An empty or cleared query returns all 12 items.
- Search results open the corresponding Item Details screen.
- Home and Search retain the four-destination bottom navigation.
- All Items, Item Details, and the QR Scanner use appropriate back/exit navigation.
- Orders and Profile display only the notice stating that they are not included in this version.
- Menu data and images are bundled locally. No menu backend or network API is implemented.
- The scanner accepts only `digital-menu:sample-01` and does not open arbitrary URLs.
- Flutter native widgets and styling are used; Tailwind CSS is not part of the mobile app.

### Remaining design and implementation verification

1. Obtain the original Figma Make source files and asset inventory if exact visual comparison is required.
2. Confirm the provenance, intended mapping, and current license terms of bundled menu images.
3. Preserve the existing system-font behavior unless approved local font files are added.
4. Run the automated tests against the final committed code and record their actual results in `QA.md`.
5. Verify offline behavior and image rendering on a physical Android device.
6. Verify scanner operation and permission-denial/unavailable-camera behavior on the intended Android device.
7. Verify iOS build and runtime behavior in a compatible macOS/Xcode environment.
8. Review keyboard insets, larger text, safe areas, and accessibility behavior on supported devices.

This design document describes the intended UI and the current implementation approach. It does not claim complete pixel-level Figma parity, full iOS verification, or successful execution of untested device scenarios.
