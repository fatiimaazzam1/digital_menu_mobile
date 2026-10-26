# Engineering Review

## Scope

Reviewed the `feat/qr-scanner` implementation against approved `PRD.md` v2.1, covering the local menu repository and screens, Search, navigation, QR parser/scanner, platform camera configuration, automated tests, and project documentation.

This is an implementation review incorporating the developer's reported physical Android testing. It is not a security audit, a complete cross-platform acceptance sign-off, or proof that every supported device behaves identically.

## Findings and Remaining Risks

| Priority | Finding | Status / action |
|---|---|---|
| Android release verification | The recorded Android debug APK build succeeded. A release APK build and release-flow test are not recorded. | Build the release APK and install/test that release build before claiming release-build verification. |
| Physical Android verification | The developer confirmed testing on a real Android device, including opening the app, menu browsing, Search, QR scanning, successful Continue/navigation, camera permission grant/denial, UI layout, and airplane mode. | Physical Android testing is recorded as completed for the reported scenarios. Device model, OS version, exact test date, and captured evidence were not recorded. |
| QR edge cases | A real QR code was scanned on the physical Android device. Automated tests cover parser rejection and recognition stability. A separate physical-device invalid-QR test is not confirmed. | Test invalid QR content on-device if time permits. |
| Camera recovery | Camera permission grant and denial were tested on the physical Android device. Automated tests cover permission-denied and unavailable-camera states. | Physical-device testing of an unavailable-camera scenario is not separately recorded. |
| iOS compatibility | Native iOS build, runtime, and camera permission behavior remain unverified. | Requires suitable macOS/Xcode tooling and an iOS simulator or device. Report iOS as untested until verified. |
| Visual acceptance | The developer confirmed inspecting the UI on a physical Android device. Automated layout tests cover narrow widths, text, image bounds, and alignment. | Do not infer testing across every screen size, OS version, or accessibility setting from one device. |
| Asset redistribution | Sample image sources, attribution, and license references are recorded in `MVP.md`, but applicable license terms have not been independently verified. | Verify the image license terms and required attribution before redistribution. |
| Repository hygiene | A complete secrets/history audit is not recorded. | Audit the final repository before claiming AC-21 is satisfied. |

## Implementation Observations

- Home category filtering, local All Items and item details, local Search, and notice-only Orders/Profile remain present.
- QR input uses exact equality. Only `digital-menu:sample-01` is accepted; unsupported values, including URLs, do not trigger external navigation.
- The scanner provides a live camera preview, a responsive square scan frame, a dimmed overlay, and scan instructions. Camera-error UI provides a route back to browsing.
- Recognition requires three matching detections within the configured stability window. On success, the scanner displays **Menu recognized** and a **Continue** action.
- Continue closes the scanner and opens the existing All Items screen. Back navigation returns to the original Home instance.
- Duplicate detections and late callbacks after disposal are guarded. Automated widget tests cover detection stability, explicit Continue navigation, and camera-independent recovery paths.
- The Flutter app title and Android/iOS display names are `ARDO Menu`. Local navy, ivory, and gold branding is used in the Home header and native launcher assets. The branding asset's authorship and origin are not documented here.
- Menu content and images are bundled locally. No backend, account system, order workflow, or remote menu-data access is implemented.

## Automated Evidence

The current recorded verification results are documented in `QA.md`:

- `flutter pub get` — PASS.
- Dart formatting check — PASS; 18 files checked.
- `flutter analyze` — PASS; no issues reported.
- `flutter test` — PASS; 28 tests passed (8 repository, 5 QR parser, and 15 widget tests).
- `git diff --check` — PASS.
- `flutter build apk --debug` — PASS; debug APK generated.

These are results from the recorded verification run. They should be rerun after final changes before submission.

Automated coverage includes parser acceptance/rejection, detection stability, Continue-to-All Items navigation, back navigation, late callbacks, camera-error recovery, and responsive layout constraints.

## Physical Android Test Evidence

The developer confirmed that the current app was manually exercised on a physical Android device. Reported scenarios include:

- Opening and running the app.
- Home, category browsing, All Items, and item details.
- Search and navigation.
- Opening the scanner and scanning a real QR code.
- Continuing to All Items and returning to Home.
- Camera permission grant and denial.
- Airplane-mode testing.
- Visual inspection of the UI on the device.

This review recognizes those physical-device tests as completed and developer-reported. The missing device identifiers and test artifacts are documentation limitations, not evidence that the tests were never performed.

The results support the tested scenarios on the device used. They do not establish Android release-build acceptance, iOS compatibility, every device-size combination, or untested QR and camera edge cases.

## Review Status

**Engineering review: PARTIAL.**

The implementation and recorded automated checks support the expected menu and scanner flows. Physical Android testing has also been reported for the scenarios listed above, including real QR scanning, camera permission grant/denial, airplane mode, and UI inspection.

Remaining work before making broader release-readiness claims:

1. Build and verify the Android release APK.
2. Re-run automated verification after the final code and documentation changes.
3. Complete a final repository secrets/configuration audit.
4. Verify sample image licensing and attribution requirements.
5. Keep iOS compatibility marked unverified until tested with appropriate Apple tooling.
6. Record any additional device-specific evidence if required by the submission process.

Do not claim full cross-platform acceptance or complete release readiness while these outstanding items remain.

## PRD Alignment Check

- **PRD update required:** NO, provided the implementation remains within the approved v2.1 scope.
- **PRD reapproval required:** NO.
- **Reason:** This review updates the recorded QA status and outstanding risks without introducing new product requirements.
- **Documentation responsibilities:** `PRD.md` defines approved requirements; `DESIGN.md` documents design and traceability; `ARCHITECTURE.md` describes implementation structure; `MCP.md` records design-tool integration; `POC.md` preserves historical proof-of-concept evidence; `MVP.md` records implementation milestones; `QA.md` records test results; and `REVIEW.md` assesses implementation quality, evidence, and remaining risks.
