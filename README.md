# VioletPro Digital Menu

A native Flutter mobile app for browsing a local sample menu. The current core branch includes category browsing, All Items, item details, local Search, and four-tab navigation. Orders and Profile are notice-only placeholders. The QR control is disabled on this branch; real camera scanning remains separate work.

The menu data and 12 sample photos are bundled in the app. There is no backend, account system, order flow, or remote image loading. These sample images are not ARDO/Figma-provided assets; their provenance and license links are in [docs/MVP.md](docs/MVP.md).

## Requirements

- Flutter 3.41.5 or a compatible Flutter SDK
- Dart 3.11.3 or compatible SDK
- Android SDK for Android builds
- macOS and Xcode for native iOS builds

## Run locally

```shell
flutter pub get
flutter run
```

Choose a connected Android/iOS device or a supported local Flutter device. The project includes Android and iOS platform folders; this does not mean both platforms have been built or device-tested.

## Verify

```shell
dart format lib test
flutter analyze
flutter test
flutter build apk --release
```

For physical-device and per-acceptance-criterion results, see [docs/QA.md](docs/QA.md). Current implementation details and remaining risks are in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md), [docs/MVP.md](docs/MVP.md), and [docs/REVIEW.md](docs/REVIEW.md). Product requirements remain in the approved [docs/PRD.md](docs/PRD.md); the historical experiment is [docs/POC.md](docs/POC.md).

## Current scope and limitations

- Search is entirely local and checks item name, category, description, and display note. Empty/cleared queries show all 12 records.
- Orders and Profile display only “Not included in this version.”
- The sample data and Commons-sourced images are provisional project content, not verified restaurant/ARDO menu material.
- QR scanning is not yet implemented on `feat/menu-mvp`. Do not interpret the disabled Scan Menu QR control as a working scanner.
- Android release packaging and automated tests are recorded in QA. Physical Android offline/device-flow testing and native iOS build/runtime testing remain unverified.
