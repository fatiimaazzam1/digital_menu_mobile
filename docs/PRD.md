# Product Requirements Document (PRD)

**Product:** Digital Menu Mobile Application  
**Version:** 2.0 — Reviewed and Approved  
**Stack:** Flutter, Dart, local sample data  
**Target platforms:** Android and iOS

## 1. Product Summary

Digital Menu is a responsive Flutter mobile application for browsing a restaurant menu on Android and iOS. The app presents menu categories, an **All Items** page, and item details containing a **name, description, price, and image**. It uses local sample data with **at least 10 distinct items in total**.

The menu is available immediately when the app opens. A small **in-app QR scanner** provides an additional way to reach that same menu by scanning a prepared demo QR code. The scanner is a chosen enhancement; it does not replace normal browsing or require a web application.

## 2. Product Problem

A digital menu must make food and drink information easy to find and read on a phone. Its categories, complete item list, item details, and navigation must be clear and reliable. The QR demonstration adds a way to enter the menu from a physical code while keeping the data entirely local.

This is a sample menu application, not an integration with a real restaurant.

## 3. Goal of the First Version

Deliver one functioning mobile app that can:

- Display menu categories and their associated items.
- Open an **All Items** page containing the full menu.
- Display the correct details of any selected item.
- Navigate between browsing and details without errors.
- Scan a prepared menu QR code **inside the installed application**, then show the same local menu.
- Allow normal browsing without a QR code or camera permission.
- Adjust to different Android and iOS phone sizes.

**Success means** the required menu features work with local data, the QR enhancement works as specified, and results are recorded from actual testing. Supporting both platforms is a product target; an unperformed iOS build or test must not be reported as passed.

## 4. Exactly Three Core Features

### Feature 1: View Menu Categories

Display clearly labeled food and drink categories. Selecting a category shows only items assigned to it.

### Feature 2: Browse All Items

Provide a dedicated **All Items** page that shows the complete menu across every category, with at least 10 distinct items overall.

### Feature 3: View Menu Item Details

Selecting an item opens its details with the correct **name, description, price, and image**. A visible back action returns to browsing.

### Additional Feature: Scan Menu QR

- Provide a **Scan Menu QR** action in the mobile application.
- Request camera access when needed and scan a QR code using the phone camera.
- Recognize one prepared demo QR value, `digital-menu:sample-01`, and open the existing local menu.
- Handle invalid QR values or unavailable/denied camera access without crashing; permit retry or normal browsing.
- Avoid opening arbitrary external links or navigating repeatedly after one successful scan.

The QR image is **generated outside the app** and displayed on a laptop or printed paper for the demo. The app must already be installed before using its scanner. A normal phone-camera scan does not automatically launch the app.

**Scope priority:** Complete and test the three core features first, then the QR enhancement. The QR scanning workflow is a project decision prompted by the QR-menu theme, not a separately specified scanner requirement.

## 5. Sample Data

The app uses locally defined menu data; no specific restaurant dataset was supplied. The chosen first-version menu has **12 distinct items**, distributed as follows:

| Category | Items |
| --- | ---: |
| Drinks | 3 |
| Starters | 3 |
| Main Courses | 3 |
| Desserts | 3 |
| **Total** | **12** |

Each menu item must include:

- A stable ID and category association.
- A name and description.
- A price shown with a consistent currency label.
- A bundled local image.

**Sample currency:** USD (project choice; no specific currency was required). Actual item names, prices, descriptions, and image assets will be finalized during the sample-data task and recorded without changing the required minimum or data fields.

## 6. Functional Scenarios

**FS-01 — View categories:** Opening the app displays recognizable menu categories.

**FS-02 — Browse a category:** Selecting a category updates the visible item list to match it.

**FS-03 — Browse everything:** Opening **All Items** displays items from every category.

**FS-04 — Inspect an item:** Selecting an item displays that item's information and image.

**FS-05 — Return to browsing:** The back action returns to an appropriate browsing view.

**FS-06 — Scan a valid QR:** Using the in-app camera scanner on the prepared code opens the local menu.

**FS-07 — Invalid QR:** Scanning an unsupported value shows an understandable message and permits retry or exit.

**FS-08 — No camera access:** Denying camera access does not prevent ordinary menu browsing.

## 7. Expected Behavior

**Menu behavior**

- The app opens to **Menu Home**, with visible categories and menu items.
- A selected category shows only its corresponding items.
- **All Items** shows all 12 planned items regardless of category.
- Selecting an item displays matching name, description, price, and image.
- Back navigation works without losing access to the menu.
- Item data and images load from the app's local assets; the menu works without a backend or internet connection.
- Prices consistently use USD in this sample version.
- No Orders page or Profile page is present.

**QR behavior**

- **Scan Menu QR** opens a camera-based scanner from within the installed app.
- Scanning `digital-menu:sample-01` returns to the same locally stored menu; it does not download new content.
- Unsupported QR values produce a clear message, not a redirect.
- Camera permission denial/unavailability is handled, and normal menu browsing remains possible.
- Repeated frame detections must not open duplicate screens.

**Device behavior**

- Layouts accommodate different phone widths, safe areas, scrolling, and increased text size.
- Main features and data are consistent between Android and iOS; platform-specific camera permissions must be configured correctly.

## 8. Acceptance Criteria

These are checks to perform, **not claims of completed testing**.

### Core menu

- **AC-01:** The Flutter/Dart mobile app opens to a clean, usable menu.
- **AC-02:** Food and drink categories have clearly visible, readable labels.
- **AC-03:** Selecting different categories displays only their correctly associated items.
- **AC-04:** A reachable **All Items** page displays all 12 planned items across the four sample categories (and therefore meets the minimum of 10 total).
- **AC-05:** Every item displays the correct name, nonempty description, USD price, and image in its details experience.
- **AC-06:** Selecting two or more different items opens their matching details without mixing content.
- **AC-07:** Back navigation from item details returns to browsing correctly.
- **AC-08:** Categories, items, details, and bundled images remain usable with internet access disabled.
- **AC-09:** Content remains readable and usable on a physical Android device and an additional narrow phone layout (about 360 logical pixels wide), without overflow; larger text settings and safe areas are checked.
- **AC-10:** No Orders or Profile page is implemented or reachable.
- **AC-11:** Visible controls work as labeled; no misleading nonfunctional buttons are shown.
- **AC-12:** The Android release build installs and completes the core browsing flow on a physical device.
- **AC-13:** The project includes Android and iOS Flutter platform targets; native iOS compilation and runtime behavior are recorded as **verified only if actually tested** using the necessary Apple environment.

### QR enhancement

- **AC-14:** The app provides a **Scan Menu QR** action that opens a scanner on a compatible camera-equipped phone.
- **AC-15:** Scanning the prepared valid QR opens the existing local menu without a network request.
- **AC-16:** An unsupported QR produces a clear message with retry or exit options; no arbitrary external link is opened.
- **AC-17:** Denied/unavailable camera access is handled without a crash, and the regular menu remains accessible.
- **AC-18:** One valid QR scan produces only one intended navigation action.

### Delivery and quality

- **AC-19:** The GitHub repository includes runnable source code, setup instructions, and essential documentation.
- **AC-20:** The application can be demonstrated locally on a device without public deployment.
- **AC-21:** No secrets, credentials, or machine-specific private configuration are committed.

**Testing record:** All acceptance criteria are **NOT YET TESTED**. Record actual steps, devices, results, and defects in `docs/QA.md`. If iOS cannot be tested, explicitly report that limitation instead of marking iOS tests passed.

## 9. Design and Accessibility Requirements

- A polished menu interface inspired by the challenge's restaurant-menu visual example, without copying excluded functionality from the illustration.
- Clear categories, readable item cards, item names and prices, and a detail screen with an image and description.
- Consistent spacing, readable typography, sufficient contrast, and comfortable tap areas.
- A reliable route to **All Items**, intuitive back navigation, and a visible QR-scan action.
- Responsive layouts for narrow and wide Android/iOS phones; respect safe areas, scrolling, and larger text sizes.
- Clear error and permission states for the QR scanner.
- No decorative search, order, profile, or other action-looking controls without real behavior.

Detailed layouts, colors, typography, component states, and navigation diagrams belong in `docs/DESIGN.md`. Figma may be used for design. Figma MCP is optional and is not part of the app itself.

## 10. Technology Stack

- **Flutter and Dart:** One shared native-mobile codebase targeting Android and iOS.
- **Local Dart models and repository:** Keep menu sample data separate from UI widgets.
- **Bundled assets:** Provide menu images from within the application.
- **Flutter widgets, navigation, and small local state:** Prefer simple built-in capabilities; do not add a complex state-management framework without a clear need.
- **QR scanner:** Use an Android/iOS-compatible scanner package, with camera permissions configured for both platforms; final dependency choice is made during implementation.
- **Prepared demo QR:** A static QR image containing `digital-menu:sample-01`, generated outside the application.
- **VS Code, Git and GitHub:** Development, source control, meaningful commits, and repository submission.
- **Physical Android device:** Primary device for functional and release testing.
- **macOS/Xcode environment:** Necessary for native iOS build and verification; availability is not yet established.

**Not needed:** Backend, database, accounts, Flutter Web, a publicly hosted menu, or QR deep linking.

**Proposed code organization:** Models, local data/repository, screens, and reusable widgets; keep QR-scanning code isolated from the core menu. Final folder details belong in setup/README documentation, not in the product requirements.

## 11. Assumptions and Limitations

- The app shows a sample restaurant menu and does not manage restaurant orders or profiles.
- **At least 10 items total** are required; 12 items and the four-category split are project choices.
- Prices may use any consistent currency; USD is selected for this version.
- The All Items page is necessary; separate Home/Details screens and category-selection interactions are implementation choices that make browsing clear.
- Android and iOS support are expected, but a shared codebase alone does not prove iOS was built or tested.
- A local-device demo and GitHub link are acceptable. Public deployment is unnecessary.
- QR scanning is a chosen extension. It requires the app to be installed and the QR code to be scanned inside it; it is **not** a public restaurant URL or universal link.
- The demo QR selects the existing single local menu, not live or multiple-restaurant content.
- The normal menu must remain accessible when the QR scanner is not used.
- No real restaurant integration, customer study, or unperformed platform testing is claimed.

**Unresolved delivery detail:** Native iOS build/test access and whether a separate iOS release artifact is needed. These constraints must be disclosed if they remain unresolved; they do not justify claiming iOS verification without evidence.

## 12. Explicitly Excluded Features

**Explicitly excluded in the challenge:**

- Orders page.
- Profile page.

**Outside this first version:**

- Cart, checkout, payments, accounts, authentication, and menu administration.
- Remote API, database, live data synchronization, or externally hosted menu images.
- Ratings, reviews, delivery tracking, and other visual-example details not specified as required.
- Search and advanced filters unless a working version is separately approved.
- Flutter Web, a hosted website, QR deep links/universal links, and public URL-based QR entry.
- Generating QR codes inside the app, routing among multiple restaurants, or scanning from the default phone camera to open the app automatically.

The included in-app QR scanner is the **only** planned QR feature.

## 13. PRD Review Status

**Status: Version 2.0 — Reviewed and Approved.** This document establishes the product scope before implementation; it does **not** claim that features have been built or tests have passed.

The PRD guides implementation and `docs/DESIGN.md`. Document experiments in `docs/POC.md`, test results in `docs/QA.md`, and engineering findings in `docs/REVIEW.md`. Maintain the root `README.md` for setup, run instructions, and delivery details.

**Change log**

| Version | Change | Status |
| --- | --- | --- |
| 1.0 | Initial digital-menu requirements draft. | Superseded |
| 2.0 | Finalized mobile-only scope, Android/iOS targets, QR demonstration behavior, dataset choices, acceptance criteria, and product-focused documentation. | Approved |

Update this PRD only when approved product requirements or major scope decisions change. Detailed visual design, POC outcomes, code review notes, and QA evidence belong in their own documents.
