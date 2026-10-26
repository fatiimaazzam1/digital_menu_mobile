# QA and Verification Record

## 1. Environment and Evidence

- **Flutter:** 3.41.5
- **Dart:** 3.11.3
- **Branch:** `feat/menu-mvp`
- **Project scope:** Core digital menu MVP. QR scanning is not implemented on this branch.

### Automated Verification

The following results were recorded during the current core MVP verification. Rerun the commands after further implementation changes to confirm the latest state.

| Check | Recorded result | Evidence and limitations |
|---|---|---|
| `flutter test` | PASS — 17 tests passed | 8 repository/unit tests and 9 widget tests were reported. |
| `flutter analyze` | PASS — No issues found | The analyzer reported no issues during the recorded run. |
| `flutter build apk --release` | PASS — Previous recorded run | The release APK was reported as successfully generated at `build/app/outputs/flutter-apk/app-release.apk`, with a size of 47.7 MB. The build was not rerun during the latest read-only audit. |
| `git diff --check` | Earlier run: PASS with a line-ending warning. Latest final verification: PASS with no output. | Both runs returned exit code 0. The earlier `pubspec.lock` line-ending warning is historical and is not an application test result. |

Widget tests include a 360 logical-pixel layout and a larger text-scaling case. These are automated layout checks, not physical-device accessibility certification.

### Device and Platform Limitations

- An Android emulator was discovered, but the attempted Pixel 7 Pro emulator remained offline as `emulator-5554`. No usable Android device or emulator was available in `flutter devices` during the recorded attempt.
- The current core build has therefore not been fully tested on a physical Android device.
- This Windows environment cannot perform native iOS builds with Xcode. No iOS build or runtime test was performed.
- The earlier physical Android Search observations for queries `el` and `cr` are documented in [POC.md](POC.md). These are historical proof-of-concept observations, not verification of the current MVP build.
- Automated tests check menu data, image paths, and file existence. They do not establish that every image is visually appropriate, correctly licensed, or rendered correctly on a physical device.

## 2. Acceptance-Criteria Status

Statuses below describe the available evidence for the current `feat/menu-mvp` branch.

- **PASS:** The specified behavior is supported by the recorded automated tests and/or code inspection. This does not automatically imply physical-device verification.
- **PARTIAL:** Some implementation or automated evidence exists, but additional verification or part of the expected scope remains incomplete.
- **FAIL:** The current implementation is known not to satisfy the criterion.
- **NOT VERIFIED:** Adequate evidence is not available to determine whether the criterion is satisfied.

| Criterion | Status | Evidence and remaining limitation |
|---|---|---|
| AC-01 — Usable Menu Home | PARTIAL | Home and its controls render in widget tests. Physical Android usability has not been verified. |
| AC-02 — Readable categories | PARTIAL | Four category labels are present and covered by the recorded widget checks. Physical-device readability and contrast have not been evaluated. |
| AC-03 — In-place category filtering | PASS | Repository and widget tests verify category filtering without navigating away from Home. |
| AC-04 — All 12 items | PASS | Repository tests verify 12 unique records and three items per category. The All Items screen uses the repository data grouped by category. |
| AC-05 — Correct details and image | PARTIAL | Required item data and image-file existence are checked. The detail screen displays the selected item's image and content, with a missing-image fallback. Visual image correctness and all item-image pairings have not been verified end-to-end. |
| AC-06 — Distinct item details | PASS | Recorded widget tests open Duck Breast and Mushroom Risotto details and verify their matching content and prices. |
| AC-07 — Back to browsing | PASS | Widget tests verify returning from item details to All Items and Search. |
| AC-08 — Offline menu | PARTIAL | Menu data and image assets are local, and the inspected core code has no runtime network dependency for menu browsing. Airplane-mode behavior has not been tested on a device. |
| AC-09 — Responsive/device readability | PARTIAL | Widget tests check a 360 logical-pixel layout and enlarged text without framework exceptions. Wider-device layouts, physical safe areas, and assistive-technology behavior remain unverified. |
| AC-10 — Notice-only Orders/Profile | PASS | Four-tab navigation and the notice are implemented. Orders and Profile do not provide real feature pages or business actions. |
| AC-11 — Controls work as labelled | PARTIAL | Core browsing, Search, and tab interactions are covered by tests. The Scan Menu QR control is intentionally disabled on this branch because the scanner has not been implemented. |
| AC-12 — Android release install/flow | PARTIAL | A previous release APK build succeeded. Installation and application flows have not been tested on a usable Android device or emulator. |
| AC-13 — Android/iOS targets | PARTIAL | Android and iOS project folders exist, and Android release packaging was reported successful. Native iOS build and runtime behavior remain unverified. |
| AC-14 — Open camera QR scanner | FAIL | The current branch contains a disabled integration point. No camera scanner is implemented. |
| AC-15 — Valid QR opens local menu | FAIL | QR payload handling is not implemented. |
| AC-16 — Invalid QR handling | FAIL | Invalid QR payload handling is not implemented. |
| AC-17 — Camera denial/unavailability | FAIL | Camera permission and unavailable-camera flows are not implemented. |
| AC-18 — Prevent duplicate scan navigation | FAIL | No scanner callback or scanner lifecycle is implemented. |
| AC-19 — Runnable source and essential documentation | PASS | README setup instructions and project documentation are present. A clean setup on another machine has not been independently verified. |
| AC-20 — Local device demonstration | NOT VERIFIED | No current-build physical-device demonstration was completed during the recorded verification. |
| AC-21 — No secrets/private configuration | NOT VERIFIED | No credential was intentionally added according to the implementation record, but a complete repository secrets audit has not been performed. |
| AC-22 — Four-tab navigation and back context | PASS | Home, Search, Orders, and Profile are present. Tests cover notice dismissal, restoration of the functional tab, and pushed-screen back behavior. |
| AC-23 — Local Search | PARTIAL | Unit/widget tests cover matching fields, case-insensitivity, whitespace trimming, empty and cleared queries, no-results behavior, and navigation to item details. The repository uses local data. Physical-device Search and airplane-mode behavior remain unverified. |
| AC-24 — Orders/Profile notice only | PASS | Widget tests verify the exact notice and that dismissing it returns to Home or Search without changing the functional tab. |

**Important:** AC-14 through AC-18 describe the QR feature expected by the requirements. Their FAIL statuses apply to the current core branch; they do not mean the QR feature has been tested and found defective. It has not yet been implemented here.

## 3. Manual Test Record

| Platform/device | Flow | Result |
|---|---|---|
| Current Android device | Current core build, menu browsing, image rendering, offline mode, Search, and four-tab navigation | NOT RUN — no usable Android device or emulator was detected during the recorded attempt. |
| Android release package | `flutter build apk --release` | PASS — previous recorded build succeeded; installation and runtime were not tested. |
| iOS device/simulator | Native build and runtime | NOT RUN — macOS/Xcode unavailable in the recorded environment. |
| Historical Android POC | Search queries `el` and `cr` | LIMITED HISTORICAL OBSERVATION — details are recorded in [POC.md](POC.md). This is not current-MVP acceptance evidence. |

No physical-device test should be marked PASS until the current build has actually been installed and the relevant flows have been exercised.

## 4. Next Verification Steps

1. **Android device verification:** Connect a physical Android phone or bring an emulator fully online. Confirm it appears in `flutter devices`, install the current build, and test Home, category filtering, All Items, item details and back navigation, Search and clear, Orders/Profile notices, and image rendering.
2. **Offline verification:** Enable airplane mode on the test device and repeat menu browsing, image display, and Search. Record the actual result.
3. **QR implementation:** Implement the scanner on the explicitly approved QR branch. Test valid payloads, invalid payloads, camera permission denial, unavailable-camera handling, and duplicate-scan navigation. Update AC-14 through AC-18 only after obtaining implementation and test evidence.
4. **iOS verification:** If macOS/Xcode becomes available, build and run the app on an iOS simulator or device and record the results.
5. **Secrets audit:** Inspect tracked files and relevant repository history for accidentally committed credentials or private configuration. Record the audit method and result.
6. **Final automated verification:** After any source or test changes, rerun `flutter test`, `flutter analyze`, and `git diff --check`. Rerun `flutter build apk --release` when validating the current Android release package.
7. **Documentation alignment:** Update this QA record and the relevant README, MVP, and REVIEW sections whenever implementation or verification status changes. Keep `docs/PRD.md` unchanged unless a requirements change is explicitly approved.

---

**Current assessment:** The core MVP has recorded passing automated checks, but physical-device verification remains outstanding and the QR scanner is not implemented on `feat/menu-mvp`. The complete challenge must not be reported as fully verified until its remaining required implementation and verification work is completed.