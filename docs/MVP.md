# MVP Implementation Log

## 1. Purpose and Scope

This document records the implementation milestones for the ARDO Digital Menu Flutter application, including local menu data and images, the core menu interface, QR scanning, branding, and responsive refinements.

It distinguishes implementation work from automated test evidence and manual device verification. A successful automated check does not establish that every acceptance criterion or platform behavior has passed.

The approved product requirements remain in [PRD.md](./PRD.md). Architecture, visual decisions, historical POC results, QA evidence, and review findings are maintained in their respective documents.

## 2. Step 1 — Local Menu Data and Bundled Images

**Status:** Implemented; automated checks passed for this milestone. Physical-device verification remains outstanding.

### Decisions and implementation

- Retained 12 sample menu records with stable IDs, category associations, names, descriptions, display notes, and USD prices. No official restaurant dataset was supplied, so these records are sample content and are not represented as verified ARDO/Figma content.
- Retained four categories: Drinks, Starters, Mains, and Desserts, with three items per category.
- Added one local food or drink image per item under `assets/images/menu/`.
- Registered the image directory in `pubspec.yaml`. Images are bundled with the app and are not fetched over the network at runtime.
- Added `MenuItemImage` for menu cards and Item Details. It provides descriptive image semantics, `BoxFit.cover`, and a fallback when an image asset cannot load.
- Added automated checks for menu count, unique IDs and image paths, category IDs/names/distribution, required fields, and the existence of referenced image files.
- Added widget coverage for the missing-image fallback.
- Kept the `el` and `cr` search regression tests because the sample names, descriptions, and notes were not changed.

### Implemented files

- `lib/features/menu/data/menu_item.dart`
- `lib/features/menu/data/sample_menu_data.dart`
- `lib/features/menu/widgets/menu_item_image.dart`
- `lib/features/menu/widgets/menu_item_card.dart`
- `lib/features/menu/screens/item_detail_screen.dart`
- `pubspec.yaml`
- `test/features/menu/data/menu_repository_test.dart`
- `test/widget_test.dart`
- `assets/images/menu/` — 12 image files

### Image provenance and licensing

The bundled photos are sample photography, not verified ARDO/Figma assets. The following source-page references and license details were recorded during implementation. They are provenance records, not independent confirmation that the current file-page metadata or license terms have been verified. Check the applicable license terms before redistribution and retain the required attribution.

| Menu item | Bundled file | Recorded author | Recorded license | Source page |
| --- | --- | --- | --- | --- |
| Citrus Sparkler | `drink-citrus-sparkler.jpg` | Fornax | CC BY-SA 3.0 | [Glass sparkling lemonade](https://commons.wikimedia.org/wiki/File:Glass_sparkling_lemonade.jpg) |
| Iced Coffee | `drink-iced-coffee.jpg` | RegionVisitor90 | CC0 1.0 | [Iced Coffee 20240730-135859](https://commons.wikimedia.org/wiki/File:Iced_Coffee_20240730-135859.jpg) |
| Berry Lemonade | `drink-berry-lemonade.jpg` | Silar | CC BY-SA 4.0 | [Different types of homemade lemonade with berries and fruits](https://commons.wikimedia.org/wiki/File:020220327_141136_Different_types_of_homemade_lemonade_with_berries_and_fruits.jpg) |
| Burrata & Garden | `starter-burrata.jpg` | Gerda Arendt | CC0 1.0 | [Tomato salad with burrata, Limburg](https://commons.wikimedia.org/wiki/File:Tomato_salad_with_burrata,_Limburg.jpg) |
| Roasted Carrots | `starter-roasted-carrots.jpg` | Daderot | CC0 1.0 | [Roasted carrots with spiced labneh, sumac, and mint](https://commons.wikimedia.org/wiki/File:Roasted_carrots_with_spiced_labneh,_sumac,_and_mint_-_Cambridge,_MA.jpg) |
| Crispy Calamari | `starter-crispy-calamari.jpg` | ppacificvancouver | CC BY 2.0 | [Crispy fried salt and pepper calamari](https://commons.wikimedia.org/wiki/File:Crispy_fried_salt_and_pepper_calamari_with_spicy_anchovy_aioli,_fresh_parsley,_grilled_lemon,_and_shallot_rings.jpg) |
| Duck Breast | `main-duck-breast.jpg` | Daderot | CC0 1.0 | [Duck breast on vegetables](https://commons.wikimedia.org/wiki/File:Duck_breast_on_vegetables_-_Massachusetts.jpg) |
| Mushroom Risotto | `main-mushroom-risotto.jpg` | Karen and Brad Emerson | CC BY 2.0 | [Mushroom risotto](https://commons.wikimedia.org/wiki/File:Mushroom_risotto_(3990739885).jpg) |
| Grilled Salmon | `main-grilled-salmon.jpg` | Daderot | CC0 1.0 | [Grilled salmon and asparagus on rice](https://commons.wikimedia.org/wiki/File:Grilled_salmon_and_asparagus_on_rice_-_Boston,_Massachusetts.jpg) |
| Chocolate Tart | `dessert-chocolate-tart.jpg` | Gogerr | CC BY-SA 4.0 | [Dark Chocolate Tart from the Elora Mill Hotel Restaurant](https://commons.wikimedia.org/wiki/File:Dark_Chocolate_Tart_from_the_Elora_Mill_Hotel_Restaurant.jpg) |
| Lemon Panna Cotta | `dessert-lemon-panna-cotta.jpg` | hiro | CC BY-SA 2.0 | [Panna Cotta with cream and garnish](https://commons.wikimedia.org/wiki/File:Panna_Cotta_with_cream_and_garnish.jpg) |
| Apple Crumble | `dessert-apple-crumble.jpg` | Jonathan Harker | CC BY 4.0 | [British apple crumble 05](https://commons.wikimedia.org/wiki/File:British_apple_crumble_05.jpg) |

### Recorded automated results

- `dart format lib test` — completed; 14 files checked, none changed.
- `flutter test` — 13 tests passed: 8 repository/unit tests and 5 widget tests.
- `flutter analyze` — no issues found.

These are historical results for Step 1, not claims about the latest branch.

### Remaining verification

- Confirm all 12 image/item pairings and image rendering on a physical Android device.
- Verify behavior in airplane mode.
- Confirm that the recorded source and license information is accurate before redistributing the images.
- Review any image-dependent tests if the sample dataset changes.

## 3. Step 2 — Core Menu UI and Navigation

**Branch recorded for this milestone:** `feat/menu-mvp`

**Status:** Core implementation recorded as complete. Automated checks and a release build were reported as successful for this milestone. Physical-device and iOS verification remained outstanding.

### Implemented behavior

- Replaced the basic vertical Home list with an ARDO-inspired navy header, ivory content surface, Search shortcut, horizontally scrolling category icons, and a two-column menu grid at standard phone widths.
- Added a one-column layout for narrower widths or larger-text settings.
- Connected the Search shortcut to the Search tab while preserving local query matching and result-to-details navigation.
- Organized All Items by category using the complete local repository dataset.
- Displayed the selected item's category, description, display note, USD price, and bundled image on Item Details.
- Added the four visible navigation destinations: Home, Search, Orders, and Profile.
- Made Orders and Profile show a dismissible “Not included in this version.” notice instead of implementing unsupported business functionality. Dismissing the notice keeps the previous functional tab selected.
- Included a disabled, clearly labelled Scan Menu QR integration point on this core branch. Camera scanning was not implemented on this branch.
- Retained platform system fonts because the Cormorant Garamond and Manrope font files were not bundled.

### Recorded validation

- `flutter test` — 17 tests passed: 8 repository/unit tests and 9 widget tests.
- `flutter analyze` — no issues found.
- `flutter build apk --release` — succeeded; the recorded APK size was 47.7 MB.
- Widget tests covered a 360 logical-pixel width and larger text scaling. These are automated layout checks, not physical-device evidence.
- An Android emulator was listed in the AVD configuration but remained offline after launch; no emulator runtime test was completed.
- Repository tests checked the existence of the referenced local image assets. Visual suitability, image/item correspondence, device rendering, and airplane-mode behavior remained unverified.

The recorded release APK belongs to the core MVP milestone before QR-scanner implementation. It does not verify the later QR-scanner branch.

See [QA.md](./QA.md) for the current verification record and remaining platform limitations.

## 4. Step 3 — QR Scanner on `feat/qr-scanner`

**Status:** Scanner implementation and automated checks were recorded as complete. A later Android debug build was reported as successful. Physical-camera behavior, native permission prompts, release build, and iOS behavior remained unverified.

### Implemented behavior

- Added `mobile_scanner: ^7.4.2`.
- Added the Android camera permission and iOS camera usage description.
- Connected Home's Scan Menu QR action to a camera-scanner screen.
- Added a live camera preview, square scan frame, corner brackets, dimmed outside overlay, and scan instructions.
- Added a QR payload parser that accepts only the exact value `digital-menu:sample-01`.
- Prevented unsupported values, including arbitrary URLs, from opening external navigation.
- Added invalid-payload feedback, camera-permission/unavailable-camera recovery UI, duplicate-detection protection, and a mounted guard for late callbacks.
- Required three consecutive matching detections no more than 700 milliseconds apart before accepting the scan.
- After a valid stable scan, stopped further handling and displayed “Menu recognized” with an explicit Continue action.
- Made Continue return from the scanner and open the existing All Items screen over the original Home route. Back navigation returns to that original Home instance.

### Automated evidence and limitations

Widget tests simulate scanner detections and cover stability, valid and invalid payloads, duplicate callbacks, the success/Continue/All Items/back flow, late callbacks after disposal, and permission/unavailable-camera recovery.

These tests do not exercise a physical camera or prove native camera-permission behavior.

An earlier `flutter build apk --debug` attempt stalled during Gradle's `assembleDebug` task and was stopped without a result. A later successful current-branch debug build was recorded in QA documentation. `git diff --check` completed without whitespace errors; Git also reported a line-ending conversion warning for `pubspec.lock`.

See [QA.md](./QA.md) for the recorded current-branch test and build results.

## 5. Step 4 — Branding and Stable QR Recognition

### Implemented changes

- Updated the visible application title to **ARDO Menu** across Flutter, Android, and iOS configuration.
- Replaced the default Android and iOS launcher artwork with a local navy, ivory, and gold menu-book branding asset.
- Reused the branding asset in the Home header.
- Retained stable QR recognition, the success confirmation, explicit Continue action, and navigation to the existing All Items screen.
- Updated architecture, design, QA, review, and README documentation to describe the scanner flow and distinguish automated evidence from pending manual verification.

The authorship and origin of the branding asset were not documented in the milestone record. The presence of platform icon files does not establish that the app has been built or visually verified on both platforms.

The approved PRD and historical POC were not changed by this milestone.

## 6. Step 5 — Responsive Home and Card Refinement

### Implemented changes

- Consolidated Home content insets and section spacing.
- Aligned Search, QR action, and menu-card corner radii.
- Made the QR action full width.
- Retained the two-column Home grid at supported widths and switched narrow or larger-text layouts to natural-height list cards.
- Standardized card padding and image bounds.
- Constrained long item names and display notes while keeping prices visible.
- Added layout tests for alignment, padding, narrow widths, and larger text.
- Updated design and architecture documentation to describe the current scanner Continue flow and distinguish automated layout checks from physical visual inspection.

The user reported prior physical-device testing of the app, but the device, operating-system version, app build, and individual test steps were not provided in the milestone record. That report is not independent evidence that these specific UI refinements or every acceptance criterion were verified.

Refer to [QA.md](./QA.md) for the latest recorded results and remaining verification tasks.

## 7. Current Implementation Summary

The intended current implementation includes:

- Four local categories and 12 sample menu items.
- Bundled local images and a missing-image fallback.
- Home category filtering and an All Items screen.
- Item Details with item information and image.
- Local Search across name, category, description, and display note.
- Four visible bottom-navigation destinations, with Orders and Profile limited to the approved placeholder notice.
- An in-app QR scanner accepting only `digital-menu:sample-01`.
- Stable-scan confirmation and explicit Continue navigation to All Items.
- No backend, database, remote menu API, or arbitrary QR URL navigation.

The implementation and validation records should be checked against the current Git branch before submission. The branch-specific milestone history above must not be treated as proof that all earlier and later changes coexist in a single verified build.

## 8. Documentation Responsibilities

| Document | Responsibility |
| --- | --- |
| [PRD.md](./PRD.md) | Approved product scope, functional requirements, and acceptance criteria. |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Current code organization, component responsibilities, and data flow. |
| [DESIGN.md](./DESIGN.md) | Visual guidance, screen behavior, and design-to-requirement traceability. |
| [MCP.md](./MCP.md) | Figma MCP usage, historical evidence, and limitations. |
| [POC.md](./POC.md) | Historical proof-of-concept experiment and its results. |
| [MVP.md](./MVP.md) | Implementation milestones and the recorded outcomes of those milestones. |
| [QA.md](./QA.md) | Current test results, platform verification, and outstanding checks. |
| [REVIEW.md](./REVIEW.md) | Review findings, known limitations, and submission risks. |
| [README.md](../README.md) | Project overview, setup, run instructions, and submission guidance. |

## 9. PRD Update Check

**PRD update required: NO, provided the current implementation remains within the approved scope of PRD v2.1.**

This document records implementation milestones and does not itself change product requirements. No PRD reapproval is required for these documentation edits.

If the approved PRD's requirements or acceptance-criterion identifiers differ from those referenced by the current implementation or QA matrix, correct the traceability in the relevant documents. Any proposed product-scope change must be reviewed against the PRD before being treated as approved.
