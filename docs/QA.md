# Quality Assurance (QA)

## 1. Purpose

This document records automated verification and manual testing of the Digital Menu Mobile Application. It separates automated test results, physical Android device testing, and checks that remain unverified.

## 2. Test Environment

| Item | Details |
|---|---|
| Project | Digital Menu Mobile Application |
| Current branch | `feat/qr-scanner` |
| Framework | Flutter |
| Flutter version | 3.41.5 |
| Dart version | 3.11.3 |
| Tested physical platform | Android |
| Physical device testing | Completed and reported by the developer |
| iOS testing | Not tested |
| Backend | Not used; menu data is local |
| Network dependency for menu data | None |

The Android device model, Android OS version, and exact device-test date were not recorded in this document.

## 3. Automated Verification

The following results were recorded for the current implementation on 2026-10-26.

| Check | Result | Recorded details |
|---|---|---|
| `flutter pub get` | PASS | Dependencies resolved |
| `dart format --output=none --set-exit-if-changed lib test` | PASS | 18 files checked; no formatting changes required |
| `flutter analyze` | PASS | No issues reported |
| `flutter test` | PASS | 28 tests passed: 8 repository, 5 QR parser, and 15 widget tests |
| `git diff --check` | PASS | No whitespace errors reported |
| `flutter build apk --debug` | PASS | Debug APK generated at `build/app/outputs/flutter-apk/app-debug.apk` |

These are recorded results from the previous verification run. Run the commands again after any subsequent changes before submitting.

## 4. Physical Android Device Testing

**Status: MANUAL TESTING COMPLETED — developer-reported.**

The developer confirmed that the application was run and tested on a real Android device. The following scenarios were tested:

- [x] Opened and ran the application on a physical Android device.
- [x] Checked the Home screen and category browsing.
- [x] Checked All Items and item details.
- [x] Tested Search and navigation.
- [x] Opened the QR scanner and scanned a real QR code.
- [x] Continued from the successful scan to All Items.
- [x] Checked navigation back to Home.
- [x] Tested camera permission grant and denial.
- [x] Tested the application with airplane mode enabled.
- [x] Checked the user interface and layout on the physical device.
- [ ] Tested the application on an iOS device.

This manual testing is recorded as developer-reported physical-device verification. The device model, OS version, screenshots or video evidence, and exact test date were not recorded here. That documentation limitation does **not** mean the Android device tests were never performed.

### Scope of the physical-device result

The physical Android tests support the tested user flows on the device used. They do not, by themselves, establish that every Android model, screen size, OS version, or release build behaves identically.

The airplane-mode test supports the local-data/offline behavior observed during that test. iOS behavior remains unverified.

## 5. Automated QR Scanner Coverage

The automated tests cover the following scanner behaviors:

- Parsing and accepting the expected payload `digital-menu:sample-01`.
- Rejecting unsupported QR payloads rather than opening arbitrary URLs.
- Requiring three matching detections within the configured 700 ms stability window.
- Resetting recognition when the required detection sequence is interrupted.
- Preventing duplicate navigation after a successful scan.
- Showing successful recognition feedback.
- Continuing to the existing All Items screen.
- Returning to Home using the back-navigation flow.
- Handling late scanner callbacks.
- Handling permission-denied and unavailable-camera states.

Automated widget/parser tests complement the physical-device tests; they are not a replacement for testing native camera behavior on each platform.

## 6. Layout and Usability Coverage

Automated layout tests cover:

- Home and Search screen alignment and corner radii.
- Grid, card, and price alignment.
- Horizontal content insets.
- Image bounds.
- Long text and price rendering.
- A narrow width of 320 logical pixels.
- Larger text settings.

The developer also confirmed that the UI was checked on a physical Android device. This does not establish visual compatibility across every device size or accessibility setting.

## 7. Acceptance Criteria Traceability

Status definitions:

- **PASS:** The criterion has supporting automated or manual verification for the tested scope.
- **PARTIAL:** Some relevant behavior was verified, but the full criterion has not been established.
- **NOT VERIFIED:** No sufficient verification result is recorded for that criterion.

| Criterion | Area | Status | Notes |
|---|---|---|---|
| AC-01 | Menu Home | PASS | Home screen checked on a physical Android device and covered by automated tests. |
| AC-02 | Category browsing | PASS | Categories checked on a physical Android device. |
| AC-03 | Category filtering | PASS | Filtering covered by automated tests. |
| AC-04 | All Items | PASS | All Items screen checked on a physical Android device; automated coverage recorded. |
| AC-05 | Item details and images | PARTIAL | Item details and UI were checked; complete verification of every image-to-item pairing is not separately recorded. |
| AC-06 | Distinct item details | PASS | Detail behavior covered by automated tests. |
| AC-07 | Back navigation | PASS | Back navigation checked on the physical Android device and covered by tests. |
| AC-08 | Offline menu behavior | PASS | Airplane-mode behavior tested on the physical Android device. |
| AC-09 | Responsive layout and readability | PARTIAL | UI checked on the tested Android device and automated narrow-width/text tests exist; not all device sizes are covered. |
| AC-10 | Orders/Profile placeholder | PASS | Placeholder behavior covered by automated tests. |
| AC-11 | User controls and navigation | PASS | Core navigation and tested interactions checked on the physical Android device and/or automated tests. |
| AC-12 | Android release build and release-flow validation | NOT VERIFIED | A debug APK build passed. A release APK installation and release-flow test are not recorded. |
| AC-13 | Android and iOS compatibility | PARTIAL | Android physical-device testing completed; iOS has not been tested. |
| AC-14 | Open QR scanner and use camera | PASS | Scanner opened and a real QR code was scanned on a physical Android device. |
| AC-15 | Recognize valid QR and open local menu | PASS | Successful scan, Continue, All Items, and return to Home were tested on the physical Android device. |
| AC-16 | Reject invalid QR content | PARTIAL | Automated parser/rejection coverage exists; a physical-device invalid-QR test is not separately confirmed. |
| AC-17 | Camera permission and unavailable-camera recovery | PARTIAL | Camera permission grant/denial was tested on Android. Unavailable-camera behavior is covered by automated tests; separate physical-device verification is not recorded. |
| AC-18 | Duplicate-scan navigation protection | PARTIAL | Automated coverage exists; a dedicated physical-device duplicate-scan test is not separately recorded. |
| AC-19 | Source code and documentation are available | PARTIAL | Project files and documentation are maintained in the repository; final submission readiness must be checked after the final changes. |
| AC-20 | Local device demonstration | PASS | Application run and demonstrated through manual testing on a physical Android device. |
| AC-21 | No committed secrets or private configuration | NOT VERIFIED | A final repository-wide secrets/configuration audit is not recorded. |
| AC-22 | Scanner navigation context and return behavior | PASS | Continue to All Items and back to Home were checked on the physical Android device. |
| AC-23 | Local Search | PASS | Search and navigation tested on the physical Android device; automated tests recorded. |
| AC-24 | Orders/Profile remain placeholders | PASS | Placeholder-only behavior covered by automated tests. |

## 8. Remaining Checks Before Submission

The following are remaining checks or limitations, not claims that the completed Android tests were not performed.

- [ ] Run the final verification commands again after documentation and code changes.
- [ ] Build and, if feasible, install and test the Android release APK.
- [ ] Record the Android device model, OS version, and test date if evidence is required.
- [ ] Test invalid QR content on a physical device if time permits.
- [ ] Verify camera-unavailable behavior on a physical device if a suitable test environment is available.
- [ ] Review the final repository for accidentally committed secrets or private configuration.
- [ ] Verify image attribution and license details for the bundled sample images.
- [ ] Test on iOS if suitable Apple hardware and tooling become available; otherwise, clearly report iOS as untested.

## 9. Final QA Summary

The current record includes passing automated checks from the recorded run, including 28 tests, static analysis, formatting validation, whitespace validation, and a successful Android debug build. The developer also confirmed manual testing on a real Android device, including menu browsing, item details, Search, QR scanning, the successful navigation flow, camera permission grant/denial, UI layout, and airplane-mode behavior.

**Android physical-device testing: completed and developer-reported.**

**iOS testing: not performed.**

A release-build test, repository secrets audit, and separate physical-device tests for invalid QR content and camera-unavailable behavior remain outstanding or unverified.

## 10. PRD Alignment Check

- **PRD update required:** NO.
- **Reason:** This update records actual QA activity and clarifies verification status; it does not change product scope or requirements.
- **PRD reapproval required:** NO.
- **Documentation responsibility:** `QA.md` records test execution and verification status. `PRD.md` remains the approved requirements source; `DESIGN.md` documents the design and requirements traceability; `ARCHITECTURE.md` describes the implementation structure; `POC.md` preserves historical proof-of-concept results; `MVP.md` records implementation milestones; and `REVIEW.md` records the final assessment and outstanding risks.
