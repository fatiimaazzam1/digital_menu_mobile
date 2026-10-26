# Proof of Concept: Local Menu Flow

## 1. Purpose

The Proof of Concept (POC) evaluated whether a small, feature-oriented Flutter implementation could support the core digital-menu flow using local Dart data, Flutter's built-in state management, and `Navigator`.

The POC investigated category filtering, browsing all menu items, local search, item details, and back navigation. It is an earlier development milestone, not evidence that the completed MVP or all PRD acceptance criteria have passed.

## 2. Hypothesis

A small feature-oriented Flutter implementation using local Dart data, built-in widget state, and `Navigator` can prove the core menu flow: category filtering, a complete All Items list, local Search, and navigation to and from item details.

## 3. Experiment

The POC implemented:

- Immutable `MenuCategory` and `MenuItem` data models.
- A local `MenuRepository` for category filtering, ID lookup, and case-insensitive search over item name, category, description, and display note.
- Twelve provisional fixture records: three each in Drinks, Starters, Mains, and Desserts. These were not verified Figma menu content.
- Menu Home category chips that filter visible items in place, an All Items screen, a Search screen, and Item Details with back navigation.
- An image-pending placeholder. At the time of the POC, verified menu image files were unavailable and fixture image paths were `null`.
- Home and Search navigation only. Orders/Profile business behavior and the QR scanner were outside this POC's scope.

The implementation used Flutter's built-in `StatefulWidget`, `setState`, and `Navigator`. No additional dependencies were added for the POC.

## 4. Traceability and POC Results

The statuses below describe only the recorded POC evidence. They must not be interpreted as proof that the corresponding full MVP acceptance criteria have passed.

### 4.1 Functional scenarios

| PRD scenario | POC evidence | POC status |
| --- | --- | --- |
| FS-01 — View categories | Home displays the four category labels; a widget test checks them. | PASS |
| FS-02 — Browse a category | Repository and widget tests check category filtering. The widget test selects each category and checks that its items appear in place while an item from another category does not. | PASS |
| FS-03 — Browse everything | Repository tests check 12 records; the widget test opens All Items and reaches records at the beginning and end of the list. | PASS |
| FS-04 — Inspect an item | Details display the selected fixture's name, description, display note, and USD price. Image display remains a pending-assets placeholder in the POC. | PARTIAL |
| FS-05 — Return to browsing | Widget tests verify back navigation from item details to the originating All Items or Search screen. | PASS |
| FS-06 — Scan a valid QR | QR scanning was not implemented or tested in this POC. | NOT TESTED |
| FS-07 — Invalid QR | QR scanning was not implemented or tested in this POC. | NOT TESTED |
| FS-08 — No camera access | Camera permission behavior was not implemented or tested in this POC. | NOT TESTED |
| FS-09 — Search local menu | Repository and widget tests cover the four searchable fields, case-insensitivity, trimming, empty/cleared queries, no matches, and result-to-details navigation. Regression tests for `el` and `cr` passed. Offline Search behavior on a physical device was not verified. | PARTIAL |
| FS-10 — Orders/Profile notice | Orders/Profile behavior was not implemented or tested in this POC. | NOT TESTED |

### 4.2 Acceptance criteria

| PRD criterion | POC evidence and limitations | POC status |
| --- | --- | --- |
| AC-01 | Home renders and is usable in a widget test; final design quality and device behavior were not evaluated. | PARTIAL |
| AC-02 | All four category labels are present in the widget tree; visual readability and device layout were not evaluated. | PARTIAL |
| AC-03 | Repository and widget tests exercise category filtering; the widget test selects all four category chips on Home. | PASS |
| AC-04 | The repository contains 12 records; the All Items widget test reaches records at both ends of the list. | PASS |
| AC-05 | Fixture details display name, description, display note, and USD price. Verified final menu images and image rendering were pending. | PARTIAL |
| AC-06 | Tests open Duck Breast and Mushroom Risotto details and check their corresponding prices/content. | PASS |
| AC-07 | Widget tests verify back navigation from details to All Items and Search. | PASS |
| AC-23 | Repository and widget tests verify local search behavior, including searchable fields, case, whitespace, empty/cleared queries, no matches, and opening a result. Short-query expected results depend on the fixture data. | PASS |

The PASS statuses above apply only to the specific POC evidence described. They do not establish full MVP acceptance.

AC-08 through AC-22 and AC-24 were not tested in the POC. AC-01, AC-02, and AC-05 were partial. In particular, AC-05 had not passed because final menu images were pending.

**Traceability note:** The PRD is the authoritative source for functional-scenario and acceptance-criterion identifiers. If an identifier or requirement changes in the approved PRD, update this traceability section to match it. Do not treat a POC status as an MVP status.

## 5. Search Investigation and Device Observation

The short queries `el` and `cr` produced results that initially appeared unexpected. The repository searches item name, category, description, and display note.

In the provisional fixtures:

- `el` matches Chocolate Tart, including the word “delicate” in its description.
- `cr` matches Burrata & Garden, Crispy Calamari, Mushroom Risotto, Chocolate Tart, and Apple Crumble.

The matches came from text in the provisional records. The investigation found no repository bug, and two exact-result regression tests were added for these queries.

These expected-result tests are fixture-specific. They must be reviewed if the final menu dataset changes.

The POC was launched on a physical Android phone, where the Search screens for `el` and `cr` were observed. This is limited device evidence, not comprehensive device validation.

The following manual device flows were not verified as part of the POC:

- Category filtering and All Items browsing.
- Item details and back navigation.
- Offline behavior.
- Responsive layouts and text scaling.
- Orders/Profile interactions.
- QR scanning and camera permissions.
- Release-build behavior.

The POC did not establish that Android acceptance criteria had passed, and it did not verify iOS device behavior.

## 6. Architecture and Data Flow

The POC models and repository are located under `lib/features/menu/data/`.

- Menu Home and All Items obtain categories and menu records from the local repository.
- Search passes the current query to the same repository.
- Selecting a result passes its stable item ID to Item Details.
- Item Details looks up and displays the selected record.
- Flutter's `Navigator` handles pushed screens and back navigation.
- `lib/app/app.dart` hosts the Home/Search shell.

The approach follows the feature-oriented structure described in [ARCHITECTURE.md](./ARCHITECTURE.md).

The POC's visual implementation was intentionally minimal. Product requirements remain in [PRD.md](./PRD.md), and visual guidance is documented in [DESIGN.md](./DESIGN.md).

## 7. Commands and Recorded Results

The following results were recorded for the POC run:

| Command | Recorded result |
| --- | --- |
| `flutter test` | 11 tests passed: 7 repository/unit tests, including the two short-query regression tests, and 4 widget tests. |
| `flutter analyze` | No issues found; the recorded run took 97.9 seconds. |

These are historical POC results. They are not a report of the latest codebase's test or analysis status. Refer to [QA.md](./QA.md) for current verification results and outstanding tests.

## 8. What Worked

The POC demonstrated that the following approach could support the tested local menu flow:

- Immutable local menu models.
- Repository-based fixture lookup and filtering.
- Category filtering.
- Access to all 12 provisional records.
- Local search across the defined text fields.
- Item selection and details display.
- Back navigation.
- A simple feature-oriented Flutter structure without additional dependencies.

The two short-query regression tests confirmed the expected results for the provisional fixture data. The limited physical Android observation also confirmed that those two Search queries could be viewed on that device.

## 9. Limitations and Follow-up Work

The POC left several items for subsequent MVP implementation and verification:

- **Menu data:** Fixture names, descriptions, prices, and notes were provisional and required reconciliation with the approved product scope and available design reference.
- **Images:** Final image inventory, provenance, bundling, and rendering were pending during the POC. Any fixture-dependent search tests needed review if the dataset changed.
- **Visual quality:** Typography, responsive styling, safe areas, larger text, accessibility, and visual fidelity were not validated on devices.
- **Navigation placeholders:** Orders/Profile notice interactions were not implemented or tested in the POC.
- **QR workflow:** Camera scanning, QR parsing, invalid-payload handling, and camera-permission behavior were not part of the POC.
- **Platform verification:** The Android observation did not establish full device-flow or release-build readiness. iOS runtime behavior was not verified.
- **Acceptance evidence:** The POC test results did not establish that the remaining PRD acceptance criteria had passed.

The later MVP may implement features that were outside the POC. Their implementation and verification must be recorded in the relevant current project documents rather than retroactively added to the POC results.

## 10. Conclusion

The POC supported the original hypothesis for the tested local browsing, search, item-detail, and navigation flow. A small repository, immutable local data models, Flutter's built-in widget state, and `Navigator` provided a suitable functional foundation without extra dependencies.

The POC did not establish release readiness, full visual fidelity, camera behavior, cross-platform compatibility, or full PRD acceptance.

The POC should remain a historical record of its experiment and evidence. The current implementation belongs in [MVP.md](./MVP.md), current verification results belong in [QA.md](./QA.md), and outstanding issues and release limitations belong in [REVIEW.md](./REVIEW.md).

## PRD Update Check

**PRD update required: NO.**

This update clarifies the historical scope and evidence of the POC. It does not change product requirements or acceptance criteria, so PRD reapproval is not required.
