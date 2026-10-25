# Proof of Concept: Local Menu Flow

## Hypothesis

A small feature-oriented Flutter implementation using local Dart data, built-in widget state, and `Navigator` can prove the core menu flow: category filtering, a complete All Items list, local Search, and navigation to and from item details.

## Experiment

The POC implements:

- Immutable `MenuCategory` and `MenuItem` data models.
- A local `MenuRepository` for category filtering, ID lookup, and case-insensitive search over item name, category, description, and display note.
- Twelve provisional fixture records: three each in Drinks, Starters, Mains, and Desserts. These are not verified Figma menu content.
- Menu Home category chips that filter the visible items in place, an All Items screen, a Search screen, and Item Details with back navigation.
- A clearly labeled image-pending placeholder. No verified menu image files were available; fixture image paths are `null`.
- Home and Search navigation only. Orders/Profile business behavior and the QR scanner are not part of this POC.

The app uses Flutter's built-in `StatefulWidget`, `setState`, and `Navigator`; no dependencies were added.

## Traceability

Statuses below describe only the tested POC. They do not claim the full MVP acceptance criteria have passed.

### Functional scenarios

| PRD scenario | POC evidence | Status |
| --- | --- | --- |
| FS-01 — View categories | Home displays the four category labels; widget test checks them. | PASS |
| FS-02 — Browse a category | Repository and widget tests check category filtering; the widget test selects each category and checks that its items appear in place while another category's item does not. | PASS |
| FS-03 — Browse everything | Repository test checks 12 records; widget test opens All Items and reaches records at the beginning and end of the list. | PASS |
| FS-04 — Inspect an item | Details show the selected fixture's name, description, note, and USD price. Image display remains a pending-assets placeholder. | PARTIAL |
| FS-05 — Return to browsing | Widget tests verify back navigation from All Items details and Search details to the originating screen. | PASS |
| FS-06 — Scan a valid QR | QR scanning is not implemented or tested in this POC. | NOT TESTED |
| FS-07 — Invalid QR | QR scanning is not implemented or tested in this POC. | NOT TESTED |
| FS-08 — No camera access | Camera permission behavior is not implemented or tested in this POC. | NOT TESTED |
| FS-09 — Search local menu | Repository and widget tests cover all four searchable fields, case-insensitivity, trimming, empty/cleared query, no matches, and result-to-details navigation. The regression tests for `el` and `cr` passed. Offline Search behavior on a physical device has not yet been verified. | PARTIAL |
| FS-10 — Orders/Profile notice | Orders/Profile behavior is not implemented or tested in this POC. | NOT TESTED |

### Acceptance criteria

| PRD criterion | POC evidence and limits | Status |
| --- | --- | --- |
| AC-01 | Home renders and is usable in a widget test; final design quality and device behavior were not evaluated. | PARTIAL |
| AC-02 | All four category labels are present in the widget tree; visual readability and device layout were not evaluated. | PARTIAL |
| AC-03 | Repository and widget tests exercise category filtering; the widget test selects all four category chips on Home. | PASS |
| AC-04 | Repository has 12 records; All Items widget test reaches records at both ends of its list. | PASS |
| AC-05 | Fixture details show name, description, display note, and USD price. Verified final menu images and image rendering are pending; AC-05 has not passed. | PARTIAL |
| AC-06 | Tests open Duck Breast and Mushroom Risotto details and check their corresponding prices/content. | PASS |
| AC-07 | Back navigation returns from details to All Items and Search in widget tests. | PASS |
| AC-23 | Repository and widget tests verify local search behavior, including matching fields, case, whitespace, empty/cleared query, no matches, and opening a result. Short-query expected results are fixture-specific. | PASS |

PASS statuses refer only to the POC evidence listed here, not completion of the full MVP acceptance criteria. AC-08 through AC-22 and AC-24 remain NOT TESTED; AC-01, AC-02, and AC-05 remain PARTIAL. In particular, AC-05 has not passed because final menu images are pending.

## Search investigation and device observation

The short queries `el` and `cr` produced results that looked unexpected. The repository correctly searches item name, category, description, and display note. In the current provisional fixtures, `el` matches Chocolate Tart (including the word “delicate” in its description), while `cr` matches Burrata & Garden, Crispy Calamari, Mushroom Risotto, Chocolate Tart, and Apple Crumble. The matches come from text in those provisional records; investigation found no repository bug. Two exact-result regression tests were added for these queries. Because these expected-result tests depend on provisional fixture content, review them when the final ARDO dataset is adopted.

The POC was launched on a physical Android phone, and the Search screens for `el` and `cr` were observed. This is limited device evidence only. All other manual device flows are NOT VERIFIED, including category and All Items browsing, item details and back navigation, offline behavior, responsive layouts and text scaling, Orders/Profile interactions, QR scanning and permissions, and release-build behavior. No Android acceptance criteria or iOS device behavior is claimed as passed.

## Architecture and data flow

The models and repository are under `lib/features/menu/data/`. Menu Home and All Items use the repository to obtain categories and records; Search sends its current query to the same repository. Selecting a result passes its stable item ID to Item Details, which looks up and displays that record. Flutter's `Navigator` handles pushed screens and back navigation. `lib/app/app.dart` hosts the Home/Search shell.

The structure follows the feature-oriented organization in [ARCHITECTURE.md](./ARCHITECTURE.md). The visual implementation is intentionally minimal; the approved visual guidance remains in [DESIGN.md](./DESIGN.md), and product requirements remain in [PRD.md](./PRD.md).

## Commands and actual results

| Command | Result |
| --- | --- |
| `flutter test` | **11 tests passed**: 7 repository/unit tests (including the two short-query regression tests) and 4 widget tests. |
| `flutter analyze` | **No issues found** (ran in 97.9 seconds). |

## What worked and what remains

Local fixture validation, all-category filtering, repository search and lookup, All Items access, detail selection, and back navigation passed their POC tests. The two short-query results are verified only for the current provisional data. The implementation uses no backend, remote requests, extra package dependencies, or actual menu images. A physical Android launch and the two specified Search screens were observed, but no other manual device flows were verified.

Still unverified or out of scope:

- Fixture names, descriptions, prices, and notes are provisional and must be replaced with or reconciled against the final ARDO dataset.
- Final menu image inventory, provenance, bundling, and image rendering are pending; fixture-dependent exact-result search tests need review with the final dataset.
- Typography, responsive styling, larger text, safe areas, accessibility, offline behavior, and visual fidelity have not been validated on devices.
- Orders/Profile notice interactions and the QR camera flow have not been implemented or verified in this POC.
- The Android observation does not establish device-flow, release-build, or Android acceptance-criteria completion. iOS runtime behavior has not been verified.

## Conclusion

The tested approach is suitable as a small functional foundation for the MVP: simple immutable local data, a repository, Flutter built-in state, and Navigator support the tested browsing/search/detail flow without added dependencies. MVP work remains to adopt and validate the final ARDO data and images, review fixture-dependent search tests, implement the outstanding QR and Orders/Profile interactions, complete responsive and accessibility work, and verify the remaining functional, device, release-build, Android, and iOS requirements. POC results do not establish release readiness or acceptance.
