# Engineering Review

## Review scope

Reviewed the current core-branch menu data/repository, Home and Search flows, All Items, Item Details, shared image/card widgets, app navigation, tests, platform availability, and documentation against approved [PRD.md](./PRD.md) v2.1. The review did not alter product scope or the PRD's 13-section structure.

## Findings

| Priority | Finding | Status / action |
| --- | --- | --- |
| Blocker for full PRD completion | Real QR scanning and camera permission/error handling are absent on `feat/menu-mvp`. | Deliberately deferred to the QR feature branch. Home's QR control is disabled and states the limitation. See QA AC-14–AC-18. |
| Device verification gap | No Android device or online emulator is currently available; the release APK has not been installed or exercised. | Release packaging succeeded. Physical Android flows, image crops, and airplane-mode behavior remain unverified. |
| Platform verification gap | Native iOS build/runtime testing has not been performed. | Requires macOS/Xcode. The existence of the iOS project is not a verification result. |
| Provisional visual assets | The 12 bundled photos are sample images, not verified ARDO/Figma deliverables; their recorded license terms have not been independently verified. | Source, author, attribution, and license references are recorded in [MVP.md](./MVP.md). Confirm applicable terms before redistribution; confirm with the owner whether to retain them or replace them if approved ARDO assets become available. |
| Search fixture coupling | Exact `el`/`cr` expected-result tests depend on current provisional text. | Keep while the dataset is unchanged; review expectations when replacing the sample dataset. |

## Core implementation review

- Category selection filters Home in place; Search and menu content use the local repository.
- All Items is grouped by the four categories; Details resolve by item ID and display the matching category, description, note, USD price, and local image.
- Home/Search state is retained in the tab shell; pushed list/detail screens use Navigator back behavior.
- Orders/Profile show only “Not included in this version.” and do not implement business flows.
- Image file references are required and checked for existence; the image widget has a missing-asset fallback.
- No backend, account, cart/order business flow, remote image loading, scanner package, or camera permission was introduced on the core branch.

No additional core-flow defect was identified in this review beyond the documented incomplete QR scope and outstanding device/platform verification. Automated evidence is in [QA.md](./QA.md); current implementation boundaries are in [ARCHITECTURE.md](./ARCHITECTURE.md).

## Review status

**Core MVP engineering review: PARTIAL.** Automated checks and Android release packaging pass. The release build has not been installed on a phone, offline and visual behavior remain unverified on device, and the approved QR addition is pending its separate branch. This is not a claim that the complete PRD MVP is finished.
