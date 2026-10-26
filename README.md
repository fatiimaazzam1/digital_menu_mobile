# ARDO Menu

ARDO Menu is a Flutter mobile application for browsing a bundled sample restaurant menu on Android and iOS. It includes Home category browsing, All Items, item details, local Search, and an in-app QR scanner that opens the local menu without a backend.

The app has no backend, account system, order processing, remote menu API, or remote image loading. Menu records and 12 provisional sample images are bundled locally. These are sample content, not verified ARDO/Figma restaurant menu content. Image sources and recorded license references are documented in [docs/MVP.md](docs/MVP.md); the applicable license terms have not been independently verified.

## Features

- Menu Home with Drinks, Starters, Mains, and Desserts.
- In-place category filtering and a grouped All Items screen.
- Item details using locally bundled data and images.
- Local Search by item name, category, description, and display note. Search is case-insensitive and trims surrounding whitespace.
- Home, Search, Orders, and Profile navigation. Orders and Profile display only “Not included in this version.”
- In-app QR scanning. Only three matching detections of the exact payload `digital-menu:sample-01`, within the configured 700 ms stability window, are recognized. Unsupported values, including URLs, never open a browser or external destination.
- After a successful scan, the scanner shows **Menu recognized** and a **Continue** action. Continue opens the existing All Items screen; Back returns to the original Home screen.
- Responsive Home cards use a two-column grid at supported widths and standard text scaling, switching to a natural-height list on narrow screens or with larger text.
- Local branding is used in the Home header and Android/iOS launcher icons. The branding asset's authorship and origin are not documented here.

## Technology and dependencies

- Flutter and Dart. The project constraint is Dart `^3.11.3`; Flutter 3.41.5 / Dart 3.11.3 was used for the latest recorded checks.
- Runtime dependencies: `mobile_scanner: ^7.4.2` for camera/QR scanning and `cupertino_icons: ^1.0.8`.
- Development dependencies: Flutter Test SDK and `flutter_lints: ^6.0.0`.
- No additional state-management, router, database, or backend package is used.

## Prerequisites

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml`. Flutter 3.41.5 / Dart 3.11.3 is the recorded environment.
- Git and PowerShell on Windows.
- Android Studio/Android SDK and an Android device or emulator for Android execution.
- macOS with Xcode for native iOS builds and runtime testing.

## Setup and run (Windows PowerShell)

Open PowerShell in the repository root and run:

```powershell
flutter pub get
flutter devices
```

Run on the default available device:

```powershell
flutter run
```

Or select a device ID reported by `flutter devices`:

```powershell
$deviceId = "DEVICE_ID_FROM_FLUTTER_DEVICES"
flutter run -d $deviceId
```

To clone the repository and get the dependencies:

```powershell
git clone https://github.com/fatiimaazzam1/digital_menu_mobile.git
Set-Location .\digital_menu_mobile
flutter pub get
```

## Automated checks

Run from the repository root:

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
git diff --check
```

Latest recorded checks:

- **Formatting:** PASS; 18 Dart files checked.
- **Static analysis:** PASS; no issues reported.
- **Automated tests:** PASS; 28 tests passed (8 repository, 5 QR parser, and 15 widget tests).
- **Whitespace validation:** PASS.
- **Android debug build:** PASS; `flutter build apk --debug` completed successfully and produced `build/app/outputs/flutter-apk/app-debug.apk`.

These results are from the recorded verification run. Rerun the checks after final code or documentation changes. Widget tests inject camera-independent detections, so they do not replace physical-camera testing. See [docs/QA.md](docs/QA.md) for the test record and acceptance-criteria status.

## Generate a QR code for manual testing

Use a QR-code generator of your choice to encode this exact text, with no spaces or URL prefix:

```text
digital-menu:sample-01
```

Display the generated code on another screen or print it. Install and open ARDO Menu, select **Scan Menu QR** on Home, and hold the code steadily within the scanner frame until **Menu recognized** appears. Press **Continue** to open All Items.

The app accepts no other value and does not launch URLs.

## Camera permissions

- Android declares `android.permission.CAMERA` in `android/app/src/main/AndroidManifest.xml`.
- iOS declares `NSCameraUsageDescription` in `ios/Runner/Info.plist`.
- The operating system may request camera access when scanning begins.
- The developer reports testing camera permission grant and denial on a physical Android device. Automated tests also cover camera-denied and unavailable-camera recovery paths.
- iOS camera permission behavior has not been tested.

## Project structure

```text
assets/
  branding/ardo_menu_icon.png
  images/menu/                      # 12 provisional sample photos

android/
  app/src/main/AndroidManifest.xml  # Display name and camera permission
  app/src/main/res/mipmap-*/        # Android launcher icon sizes

ios/
  Runner/Info.plist                 # Display name and camera usage description
  Runner/Assets.xcassets/AppIcon.appiconset/

lib/
  main.dart                         # Flutter entry point
  app/
    app.dart                        # App shell, theme, bottom navigation
    design_tokens.dart              # Shared spacing and radius tokens
  features/
    menu/
      data/                         # Menu models, sample records, repository
      screens/                      # Home, All Items, item details
      widgets/                      # Menu item cards and images
    qr_scanner/
      data/qr_payload_parser.dart   # Exact supported-payload validation
      screens/qr_scanner_screen.dart
    search/
      screens/search_screen.dart    # Local Search

test/
  features/menu/data/menu_repository_test.dart
  features/qr_scanner/data/qr_payload_parser_test.dart
  widget_test.dart

docs/
  PRD.md                            # Approved requirements, v2.1
  DESIGN.md                         # Screen and interaction design
  ARCHITECTURE.md                   # Code structure and data/navigation flows
  MCP.md                            # Figma MCP evidence and limitations
  POC.md                            # Historical proof-of-concept evidence
  MVP.md                            # Implementation record and asset provenance
  QA.md                             # Test evidence and remaining gaps
  REVIEW.md                          # Engineering review and outstanding risks
```

## Platform support and verification

The repository contains Flutter targets for Android and iOS, but their presence does not establish that both platforms have been tested.

**Android:** The developer reports manual testing on a physical Android device, including:

- Running the application and browsing Home, categories, All Items, and item details.
- Testing Search and navigation.
- Opening the scanner and scanning a real QR code.
- Continuing to All Items and returning to Home.
- Testing camera permission grant and denial.
- Checking the UI on the device.
- Testing with airplane mode enabled.

The device model, OS version, exact test date, and captured evidence were not recorded in this README. The Android debug APK build is verified by the recorded build result. A release APK build and release-build testing are not recorded.

**iOS:** Native build, runtime, and camera permission behavior have not been tested. Testing requires suitable macOS/Xcode tooling and an iOS simulator or device.

## Known limitations and documentation

- Menu content and images are provisional, not verified restaurant content.
- Applicable sample-image license terms and attribution requirements still need independent verification before redistribution.
- The app has no backend or live restaurant data.
- The developer-reported physical Android test results are recorded in [docs/QA.md](docs/QA.md). They should not be misrepresented as iOS testing or Android release-build verification.
- A final repository secrets/history audit is not recorded.
- The engineering review is partial until the remaining release, asset-license, and repository-audit items are addressed.

See the project documentation:

- [PRD.md](docs/PRD.md) — approved product requirements.
- [DESIGN.md](docs/DESIGN.md) — screen behavior and design traceability.
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — implementation structure and data/navigation flows.
- [MCP.md](docs/MCP.md) — Figma MCP evidence and limitations.
- [POC.md](docs/POC.md) — historical proof-of-concept findings.
- [MVP.md](docs/MVP.md) — implementation milestones and asset provenance.
- [QA.md](docs/QA.md) — automated and manual test evidence.
- [REVIEW.md](docs/REVIEW.md) — engineering review and outstanding risks.
