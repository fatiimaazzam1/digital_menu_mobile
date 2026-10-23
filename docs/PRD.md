# Product Requirements Document (PRD)

**Product:** Digital Menu Mobile Application  
**Version:** 2.1 — Reviewed and Approved
**Stack:** Flutter, Dart, local sample data  
**Target platforms:** Android and iOS

## 1. Product Summary

Digital Menu is a responsive Flutter mobile application for browsing a restaurant menu on Android and iOS. The app presents menu categories, an **All Items** page, and item details containing a **name, description, price, and image**. It uses local sample data with **at least 10 distinct items in total**.

The menu is available immediately when the app opens. Home category chips filter menu items directly on Menu Home. The approved visual navigation contains **Home, Search, Orders, and Profile** tabs. Search is a user-approved additional feature that searches the local menu. Orders and Profile tabs display only a **“Not included in this version”** notice; they do not open functional Orders or Profile pages.

A small **in-app QR scanner** provides an additional way to reach that same menu by scanning a prepared demo QR code. It does not replace normal browsing or require a web application.

## 2. Product Problem

A digital menu must make food and drink information easy to find and read on a phone. Its categories, complete item list, item details, and navigation must be clear and reliable. The QR demonstration adds a way to enter the menu from a physical code while keeping the data entirely local.

This is a sample menu application, not an integration with a real restaurant.

## 3. Goal of the First Version

Deliver one functioning mobile app that can:

- Display menu categories and their associated items.
- Filter Menu Home items directly when a category chip is selected.
- Open an **All Items** page containing the full menu.
- Display the correct details of any selected item.
- Navigate between browsing and details without errors.
- Search the local menu through the Search tab.
- Keep the approved Home, Search, Orders, and Profile bottom navigation visible; Orders and Profile selections show only the informational notice and provide no business functionality.
- Scan a prepared menu QR code **inside the installed application**, then show the same local menu.
- Allow normal browsing without a QR code or camera permission.
- Adjust to different Android and iOS phone sizes.

**Success means** the required menu features work with local data, the QR enhancement works as specified, and results are recorded from actual testing. Supporting both platforms is a product target; an unperformed iOS build or test must not be reported as passed.

## 4. Three Mandatory Core Features and Approved Additions

The following three core menu features are the mandatory VioletPro scope and remain unchanged.

### Core Feature 1: View Menu Categories

Display clearly labeled food and drink categories on Menu Home. Selecting a category chip filters the visible Menu Home items to only those assigned to it.

### Core Feature 2: Browse All Items

Provide a dedicated **All Items** page that shows the complete menu across every category, with at least 10 distinct items overall.

### Core Feature 3: View Menu Item Details

Selecting an item opens its details with the correct **name, description, price, and image**. A visible back action returns to browsing.

### User-approved additional feature: Search

The Search tab provides case-insensitive search over the locally stored menu. Trim surrounding whitespace from the query and match it against each item's name, category, description, and display note. An empty query displays all 12 items. Clearing the query restores all items; a query with no matches displays an understandable empty-results state. Selecting a result opens that item's correct Item Details. Search is an approved product addition, **not a mandatory VioletPro core feature**. It uses local data and does not require a backend or network access. No additional search capabilities such as filters or remote suggestions are implied.

### Approved visual navigation: Orders and Profile placeholders

The bottom navigation preserves the four Figma destinations: **Home, Search, Orders, and Profile**. Selecting Orders or Profile shows only a **“Not included in this version”** informational notice. These tabs are user-approved navigation placeholders, not VioletPro-required functional features. They must not lead to Orders/Profile pages or business actions.

### User-approved additional feature: Scan Menu QR

- Provide a **Scan Menu QR** action in the mobile application.
- Request camera access when needed and scan a QR code using the phone camera.
- Recognize one prepared demo QR value, `digital-menu:sample-01`, and open the existing local menu.
- Handle invalid QR values or unavailable/denied camera access without crashing; permit retry or normal browsing.
- Avoid opening arbitrary external links or navigating repeatedly after one successful scan.

The QR image is **generated outside the app** and displayed on a laptop or printed paper for the demo. The app must already be installed before using its scanner. A normal phone-camera scan does not automatically launch the app.

The scanner is an approved addition to the three mandatory core features. Implement it as a real camera-based Flutter scanner, not a simulation or set of prototype-only scan buttons.

## 5. Sample Data

The app uses locally defined menu data; no specific restaurant dataset was supplied. The chosen first-version menu has **12 distinct items**, distributed as follows:

| Category | Items |
| --- | ---: |
| Drinks | 3 |
| Starters | 3 |
| Mains | 3 |
| Desserts | 3 |
| **Total** | **12** |

Each menu item must include:

- A stable ID and category association.
- A name and description.
- A display note used as menu item content and searchable text.
- A price shown with a consistent currency label.
- A bundled local image.

**Sample currency:** USD (project choice; no specific currency was required). Actual item names, prices, descriptions, and image assets will be finalized during the sample-data task and recorded without changing the required minimum or data fields.

## 6. Functional Scenarios

**FS-01 — View categories:** Opening the app displays recognizable menu categories.

**FS-02 — Browse a category:** Selecting a category chip on Menu Home updates the visible item list to match it, without navigating to a separate category screen.

**FS-03 — Browse everything:** Opening **All Items** displays items from every category.

**FS-04 — Inspect an item:** Selecting an item displays that item's information and image.

**FS-05 — Return to browsing:** The back action returns to an appropriate browsing view.

**FS-06 — Scan a valid QR:** Using the in-app camera scanner on the prepared code opens the local menu.

**FS-07 — Invalid QR:** Scanning an unsupported value shows an understandable message and permits retry or exit.

**FS-08 — No camera access:** Denying camera access does not prevent ordinary menu browsing.

**FS-09 — Search local menu (approved addition):** Search is case-insensitive, trims surrounding query whitespace, and matches item name, category, description, and display note. An empty query shows all 12 items; clearing the query restores all items; no matches show an understandable empty-results state. Selecting a result opens the correct Item Details. Search remains available offline.

**FS-10 — Orders/Profile notice (approved navigation placeholders):** Orders and Profile remain visible bottom-navigation tabs on Home and Search. Selecting either displays only the “Not included in this version” notice. No functional Orders/Profile page or business action is available.

## 7. Expected Behavior

**Menu behavior**

- The app opens to **Menu Home**, with visible categories and menu items.
- Selecting a category chip on Menu Home filters the visible items to that category; category selection does not open a separate screen.
- **All Items** shows all 12 planned items regardless of category.
- Selecting an item displays matching name, description, price, and image.
- Back navigation works without losing access to the menu.
- Item data and images load from the app's local assets; the menu works without a backend or internet connection.
- Prices consistently use USD in this sample version.
- The bottom navigation contains Home, Search, Orders, and Profile.
- The bottom navigation is shown on Home and Search. All Items, Item Details, and QR Scanner provide appropriate back/exit navigation to the preceding browsing context; the tab bar is not required on those pushed screens.
- Search performs case-insensitive local matching against item name, category, description, and display note after trimming surrounding whitespace. An empty query displays all 12 items; clearing restores them; no matches display an understandable empty-results state. Selecting a result opens its correct Item Details.
- Selecting Orders or Profile shows only the “Not included in this version” notice; neither tab exposes business functionality or a functional page.

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

### Mandatory core menu

- **AC-01:** The Flutter/Dart mobile app opens to a clean, usable Menu Home.
- **AC-02:** Food and drink categories have clearly visible, readable labels.
- **AC-03:** Selecting different category chips on Menu Home displays only their correctly associated items without navigating to a separate category screen.
- **AC-04:** A reachable **All Items** page displays all 12 planned items across the four sample categories (and therefore meets the minimum of 10 total).
- **AC-05:** Every item displays the correct name, nonempty description, USD price, and image in its details experience.
- **AC-06:** Selecting two or more different items opens their matching details without mixing content.
- **AC-07:** Back navigation from item details returns to browsing correctly.
- **AC-08:** Categories, items, details, and bundled images remain usable with internet access disabled.
- **AC-09:** Content remains readable and usable on a physical Android device and an additional narrow phone layout (about 360 logical pixels wide), without overflow; larger text settings and safe areas are checked.
- **AC-10:** Orders and Profile tabs are visible as specified, but selecting either displays only the “Not included in this version” notice; no functional Orders/Profile page or business action is implemented or reachable.
- **AC-11:** Visible controls work as labeled, including the Orders/Profile notice interaction; no misleading controls are shown.
- **AC-12:** The Android release build installs and completes the core browsing flow on a physical device.
- **AC-13:** The project includes Android and iOS Flutter platform targets; native iOS compilation and runtime behavior are recorded as **verified only if actually tested** using the necessary Apple environment.

### QR enhancement

- **AC-14:** The app provides a **Scan Menu QR** action that opens a scanner on a compatible camera-equipped phone.
- **AC-15:** Scanning the prepared valid QR opens the existing local menu without a network request.
- **AC-16:** An unsupported QR produces a clear message with retry or exit options; no arbitrary external link is opened.
- **AC-17:** Denied/unavailable camera access is handled without a crash, and the regular menu remains accessible.
- **AC-18:** One valid QR scan produces only one intended navigation action.

### User-approved navigation/search additions

- **AC-22:** The bottom navigation presents Home, Search, Orders, and Profile and is visible on Home and Search. All Items, Item Details, and QR Scanner provide appropriate back/exit navigation to the preceding browsing context without requiring the bottom tab bar.
- **AC-23:** Search trims surrounding whitespace and performs case-insensitive local matching against item name, category, description, and display note. An empty query and clearing the query display all 12 items; no matches display an understandable empty-results state; selecting a result opens the correct Item Details. No backend or network request is made.
- **AC-24:** Selecting Orders or Profile displays only the “Not included in this version” notice and does not expose functional Orders/Profile behavior.

### Delivery and quality

- **AC-19:** The GitHub repository includes runnable source code, setup instructions, and essential documentation.
- **AC-20:** The application can be demonstrated locally on a device without public deployment.
- **AC-21:** No secrets, credentials, or machine-specific private configuration are committed.

**Testing record:** All acceptance criteria are **NOT YET TESTED**. Record actual steps, devices, results, and defects in `docs/QA.md`. If iOS cannot be tested, explicitly report that limitation instead of marking iOS tests passed.

## 9. Design and Accessibility Requirements

- A polished menu interface inspired by the challenge's restaurant-menu visual example, without copying excluded functionality from the illustration.
- Preserve the approved Figma visual identity: ARDO branding, navy/cream/gold palette, Cormorant Garamond and Manrope typography, food photography, menu cards, and Home/Search/Orders/Profile bottom navigation. These are approved design choices, not additional VioletPro-mandated features.
- Clear categories, readable item cards, item names and prices, and a detail screen with an image and description.
- Search and the notice-only Orders/Profile interactions must be visually clear and consistent with the approved reference.
- Consistent spacing, readable typography, sufficient contrast, and comfortable tap areas.
- A reliable route to **All Items**, intuitive back navigation, and a visible QR-scan action.
- Responsive layouts for narrow and wide Android/iOS phones; respect safe areas, scrolling, and larger text sizes.
- Clear error and permission states for the QR scanner.
- Search is a functional user-approved addition. Orders/Profile are visible, working notice-only tab interactions; they must not imply functional business pages. Do not add decorative or misleading controls elsewhere.

Detailed layouts, colors, typography, component states, and navigation diagrams belong in `docs/DESIGN.md`. Figma may be used for design. Figma MCP is optional and is not part of the app itself.

## 10. Technology Stack

- **Flutter and Dart:** One shared native-mobile codebase targeting Android and iOS.
- **Flutter UI:** Implement the approved visual reference using native Flutter widgets and styling. Tailwind CSS belongs only to the Figma web prototype and is not part of the mobile app.
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

- The app shows a sample restaurant menu and does not manage restaurant orders or profiles. The approved Orders/Profile tabs only show an informational notice.
- **At least 10 items total** are required; 12 items and the four-category split are project choices.
- Prices may use any consistent currency; USD is selected for this version.
- The All Items page is necessary. Category selection is finalized to filter Menu Home directly; item details use a separate detail experience.
- Android and iOS support are expected, but a shared codebase alone does not prove iOS was built or tested.
- A local-device demo and GitHub link are acceptable. Public deployment is unnecessary.
- QR scanning is a chosen extension. It requires the app to be installed and the QR code to be scanned inside it; it is **not** a public restaurant URL or universal link.
- The demo QR selects the existing single local menu, not live or multiple-restaurant content.
- The normal menu must remain accessible when the QR scanner is not used.
- No real restaurant integration, customer study, or unperformed platform testing is claimed.

**Unresolved delivery detail:** Native iOS build/test access and whether a separate iOS release artifact is needed. These constraints must be disclosed if they remain unresolved; they do not justify claiming iOS verification without evidence.

## 12. Explicitly Excluded Features

**Excluded functional scope:**

- Functional Orders page, order placement/management, and order-related business actions.
- Functional Profile page, account/profile management, and profile-related business actions.

**Outside this first version:**

- Cart, checkout, payments, accounts, authentication, and menu administration.
- Remote API, database, live data synchronization, or externally hosted menu images.
- Ratings, reviews, delivery tracking, and other visual-example details not specified as required.
- Advanced search filters, remote search, or search services beyond local menu search.
- Flutter Web, a hosted website, QR deep links/universal links, and public URL-based QR entry.
- Generating QR codes inside the app, routing among multiple restaurants, or scanning from the default phone camera to open the app automatically.

The included in-app QR scanner is the **only** planned QR feature. Orders/Profile placeholder notices do not change the exclusion of their functional pages.

## 13. PRD Review Status

**Status: Version 2.1 — Reviewed and Approved.** Version 2.0 remains the prior reviewed and approved baseline. Version 2.1 records approved additions and clarified navigation and scope; it does **not** claim that features have been built or tests have passed. The original VioletPro challenge PDF was not available during this revision, so mandatory challenge scope is retained as represented in the existing approved PRD and has not been independently rechecked against the source.

The PRD guides implementation and `docs/DESIGN.md`. Document experiments in `docs/POC.md`, test results in `docs/QA.md`, and engineering findings in `docs/REVIEW.md`. Maintain the root `README.md` for setup, run instructions, and delivery details.

**Change log**

| Version | Change | Status |
| --- | --- | --- |
| 1.0 | Initial digital-menu requirements draft. | Superseded |
| 2.0 | Finalized mobile-only scope, Android/iOS targets, QR demonstration behavior, dataset choices, acceptance criteria, and product-focused documentation. | Approved |
| 2.1 | Added user-approved local Search and notice-only Orders/Profile navigation, finalized category-chip filtering on Menu Home, and clarified mandatory versus additional scope. | Reviewed and Approved |

