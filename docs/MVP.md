# MVP Implementation Log

## Step 1 — Local menu data and bundled images

**Status:** Implemented; automated checks pass. Physical-device verification remains.

### Decisions and files

- Kept the 12 existing sample menu records, stable IDs, category associations, names, descriptions, notes, and USD prices. The content was already suitable for a sample menu; no VioletPro restaurant dataset was supplied. It is adopted as local sample content, not represented as ARDO/Figma data.
- Kept four categories—Drinks, Starters, Mains, Desserts—with three items each. Every item now has a required, non-null local image asset path.
- Downloaded one matching food/drink photo per item from Wikimedia Commons. The images are bundled under `assets/images/menu/`; Flutter registers the directory in `pubspec.yaml`. No image is fetched over the network at runtime.
- Added `MenuItemImage`, used by menu cards and Item Details. It supplies a descriptive image semantic label, `BoxFit.cover`, and an accessible fallback if an asset cannot load.
- Added automated checks for menu count, unique item IDs and image paths, exact category IDs/names and distribution, nonempty required fields, and existence of each referenced asset. Added a widget test for the missing-asset fallback.
- Existing `el` and `cr` regression tests remain unchanged because menu names, descriptions, and notes did not change.

Implemented files:

- `lib/features/menu/data/menu_item.dart`
- `lib/features/menu/data/sample_menu_data.dart`
- `lib/features/menu/widgets/menu_item_image.dart`
- `lib/features/menu/widgets/menu_item_card.dart`
- `lib/features/menu/screens/item_detail_screen.dart`
- `pubspec.yaml`
- `test/features/menu/data/menu_repository_test.dart`
- `test/widget_test.dart`
- `assets/images/menu/` (12 image files)

### Image provenance and terms

The ARDO/Figma menu image files were not available in the project and were not verified as accessible or licensed. These sample images are recorded as sourced from Wikimedia Commons. The source-page references and stated licenses below are recorded provenance, not independent confirmation that the current file-page metadata or license terms have been verified. Retain the listed attribution and check the applicable license terms before redistribution. CC0 works are credited here for traceability.

| Menu item | Bundled file | Author | License | Source |
| --- | --- | --- | --- | --- |
| Citrus Sparkler | `drink-citrus-sparkler.jpg` | Fornax | [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) | [Glass sparkling lemonade](https://commons.wikimedia.org/wiki/File:Glass_sparkling_lemonade.jpg) |
| Iced Coffee | `drink-iced-coffee.jpg` | RegionVisitor90 | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | [Iced Coffee 20240730-135859](https://commons.wikimedia.org/wiki/File:Iced_Coffee_20240730-135859.jpg) |
| Berry Lemonade | `drink-berry-lemonade.jpg` | Silar | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) | [Different types of homemade lemonade with berries and fruits](https://commons.wikimedia.org/wiki/File:020220327_141136_Different_types_of_homemade_lemonade_with_berries_and_fruits.jpg) |
| Burrata & Garden | `starter-burrata.jpg` | Gerda Arendt | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | [Tomato salad with burrata, Limburg](https://commons.wikimedia.org/wiki/File:Tomato_salad_with_burrata,_Limburg.jpg) |
| Roasted Carrots | `starter-roasted-carrots.jpg` | Daderot | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | [Roasted carrots with spiced labneh, sumac, and mint](https://commons.wikimedia.org/wiki/File:Roasted_carrots_with_spiced_labneh,_sumac,_and_mint_-_Cambridge,_MA.jpg) |
| Crispy Calamari | `starter-crispy-calamari.jpg` | ppacificvancouver | [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/) | [Crispy fried salt and pepper calamari](https://commons.wikimedia.org/wiki/File:Crispy_fried_salt_and_pepper_calamari_with_spicy_anchovy_aioli,_fresh_parsley,_grilled_lemon,_and_shallot_rings.jpg) |
| Duck Breast | `main-duck-breast.jpg` | Daderot | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | [Duck breast on vegetables](https://commons.wikimedia.org/wiki/File:Duck_breast_on_vegetables_-_Massachusetts.jpg) |
| Mushroom Risotto | `main-mushroom-risotto.jpg` | Karen and Brad Emerson | [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/) | [Mushroom risotto](https://commons.wikimedia.org/wiki/File:Mushroom_risotto_(3990739885).jpg) |
| Grilled Salmon | `main-grilled-salmon.jpg` | Daderot | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | [Grilled salmon and asparagus on rice](https://commons.wikimedia.org/wiki/File:Grilled_salmon_and_asparagus_on_rice_-_Boston,_Massachusetts.jpg) |
| Chocolate Tart | `dessert-chocolate-tart.jpg` | Gogerr | [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) | [Dark Chocolate Tart from the Elora Mill Hotel Restaurant](https://commons.wikimedia.org/wiki/File:Dark_Chocolate_Tart_from_the_Elora_Mill_Hotel_Restaurant.jpg) |
| Lemon Panna Cotta | `dessert-lemon-panna-cotta.jpg` | hiro | [CC BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/) | [Panna Cotta with cream and garnish](https://commons.wikimedia.org/wiki/File:Panna_Cotta_with_cream_and_garnish.jpg) |
| Apple Crumble | `dessert-apple-crumble.jpg` | Jonathan Harker | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | [British apple crumble 05](https://commons.wikimedia.org/wiki/File:British_apple_crumble_05.jpg) |

### Requirements and evidence

Status meanings: **PASS** means the stated check is supported by the evidence recorded here; **PARTIAL** means implementation or automated coverage exists but required manual or full-scope verification remains; **NOT TESTED** means no supporting test or observation is recorded.

| Requirement | Implemented behavior and actual evidence | Status |
| --- | --- | --- |
| FS-03 — Browse everything | All Items uses the same 12 local records. Repository count/distribution tests and the existing widget test opening All Items passed. | PASS |
| FS-04 — Inspect an item | Item Details now renders the selected local image, name, description, note, and USD price. Automated widget coverage verifies details for Duck Breast; asset existence is checked for all records. Physical review of all image/detail pairings remains. | PARTIAL |
| AC-04 — All Items | Tests verify 12 unique records and exactly three in each of the four required categories; the widget test opens All Items and reaches items at both ends. | PASS |
| AC-05 — Item details and image | All records have required data and existing bundled image files; the widget test exercises a detail view with a bundled image and the missing-image fallback. Visual confirmation of every pairing and device rendering remains. | PARTIAL |
| AC-08 — Offline use | Records and images are packaged locally, and Search remains a local repository operation with no network dependency. Airplane-mode behavior has not been manually verified on a device. | PARTIAL |
| AC-23 — Local Search | Existing repository and widget tests still pass, including matching fields, case/whitespace handling, empty/cleared query, no results, navigation, and the fixture-specific `el`/`cr` regressions. Offline physical-device behavior remains unverified. | PARTIAL |

Automated validation run for Step 1:

- `dart format lib test` — completed; 14 files checked, none changed.
- `flutter test` — **13 tests passed**: 8 repository/unit tests and 5 widget tests.
- `flutter analyze` — **No issues found**.

No physical-device, airplane-mode, iOS, release-build, or full acceptance-criteria result is inferred from these automated checks.

### Step 1 verification retained

- Confirm all 12 image/item pairings and image rendering on the physical Android device, including offline/airplane mode.
- The images are sample photography, not verified ARDO/Figma photography. The source pages and license references are recorded above, but their current metadata and license terms have not been independently verified. Replace them only if approved project assets become available, and preserve the provenance records.
- Retain the listed attribution and source/license references, and confirm the applicable terms before redistributing the images.

The historical [POC record](./POC.md) is intentionally unchanged.

## Step 2 — Core Home UI and navigation

**Status:** Implemented on `feat/menu-mvp`; automated tests and analysis pass. Physical Android and iOS verification remain unavailable in this environment.

### Implemented behavior

- Replaced the basic vertical Home list with an ARDO-inspired navy header, ivory content surface, search shortcut, horizontally scrolling circular category icons, and a two-column menu grid at standard phone widths. Larger text and narrow widths use a one-column layout.
- Search shortcut selects the Search tab. Existing query matching and result-to-details behavior remain local and unchanged.
- All Items now groups the complete repository dataset under its category heading. Details show the item's category, description, display note, price, and bundled image.
- Added the approved four visible navigation destinations. Orders/Profile display only “Not included in this version.” in a dismissible dialog and keep the prior functional tab selected.
- Added a disabled, clearly labelled Scan Menu QR integration point. A camera scanner is not implemented on this core branch.
- Kept platform system fonts because Cormorant Garamond and Manrope files are not bundled.

### Current validation

- `flutter test` — 17 tests passed (8 repository/unit tests and 9 widget tests).
- `flutter analyze` — No issues found.
- `flutter build apk --release` — Succeeded; Flutter reported a 47.7 MB APK. No device install was possible.
- Widget tests cover the 360 logical pixel width and larger text scaling; this is not physical-device evidence.
- An Android emulator was available in the AVD list but remained offline after launch; no Android runtime test was possible.
- The Home image assets have valid local paths and are tested for existence. Visual review confirmed broad content correspondence, but image rendering/cropping on-device and airplane-mode behavior remain unverified.

The final Android release build result and complete acceptance-criteria matrix are recorded in [QA.md](./QA.md). Architecture and visual implementation notes are in [ARCHITECTURE.md](./ARCHITECTURE.md) and [DESIGN.md](./DESIGN.md); review findings and remaining risks are in [REVIEW.md](./REVIEW.md).
