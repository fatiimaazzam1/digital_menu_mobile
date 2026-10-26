# Figma MCP Integration

## 1. Purpose

Figma Model Context Protocol (MCP) supported design inspection and planning for implementing the ARDO-inspired visual reference in native Flutter.

This document records the intended workflow, historical evidence, limitations, and pending verification. Figma MCP does not automatically generate or convert the Flutter application. The Flutter implementation must be built, tested, and reviewed separately.

The approved `PRD.md` remains the source of product requirements. `DESIGN.md` describes the screen-level design guidance, while `ARCHITECTURE.md` documents the implemented Flutter structure, data flow, and navigation.

## 2. Project and Workflow

- **Figma Make project:** ARDO Digital Menu
- **File key:** `KewPu6ikVpqYgj8hitWJqu`
- **Relevant Make source paths:** `src/App.tsx`, `src/index.css`, and `public/menu/`

During earlier VS Code work, Figma Make resources were accessed through **MCP: Browse Resources**, and source content was shared for design review.

A previous Agent session recorded that the `figma-whoami` tool completed successfully. This historical authentication result was not reverified during the current audit. Account details are intentionally omitted.

During the current audit, a request for the Make project returned resource-link guidance but did not retrieve `src/App.tsx`, `src/index.css`, the raw CSS, screenshots, or the `public/menu/` assets.

These records distinguish historical resource access and user-provided design material from direct source retrieval verified during the current audit.

## 3. Evidence and Limitations

An earlier design review referred to a user-provided, read-only CSS attachment associated with the Figma Make project. The raw attachment was not available for independent inspection during this audit.

Consequently, CSS-derived details in earlier notes are historical references. They must not be presented as independently verified against the current Figma Make source.

The current Agent workspace contains the Flutter project, but the original Make source files and menu asset directory were not available for direct inspection.

### 3.1 Visual direction

Earlier notes describe the intended visual direction as:

- ARDO-inspired restaurant branding.
- Deep navy surfaces.
- Warm ivory and cream content areas.
- Restrained gold accents.
- Food photography.
- Rounded menu cards and category controls.

These descriptions provide historical design context. They do not prove pixel-level equivalence between the original prototype and the current Flutter application.

### 3.2 Historical color references

Earlier CSS notes transcribed the following palette values. The original CSS was not available for independent verification during this audit.

| Token | Historical value |
|---|---|
| Navy | `#091326` |
| Navy | `#101d36` |
| Navy | `#1d3764` |
| Navy | `#284a7d` |
| Gold | `#c9a75c` |
| Gold | `#e5cf9d` |
| Ivory | `#f7f3ea` |
| Paper | `#fffdf8` |
| Ink | `#172034` |
| Muted text | `#73788a` |

The Flutter source contains several of these colors, as documented in `DESIGN.md`. The Flutter source code, rather than the historical CSS notes, is the authority for the current implementation.

### 3.3 Typography

Earlier notes report that the prototype CSS referenced:

- **Cormorant Garamond** for editorial headings and branding.
- **Manrope** for body text and controls.

The original CSS imports were not independently verified during this audit. The font files were not retrieved or verified as local project assets.

The Flutter application currently uses the platform system font and does not bundle local Cormorant Garamond or Manrope font files. Do not describe these fonts as bundled or available offline unless the corresponding licensed files are added and verified.

### 3.4 Screens and navigation

The approved product and design documents cover:

- Menu Home and category browsing.
- All Items.
- Item Details.
- Local Search.
- Home, Search, Orders, and Profile navigation.
- In-app QR scanning.

Earlier CSS notes refer to menu, search, scanner, and navigation styling. However, the exact source component hierarchy and interaction logic were not independently verified from `src/App.tsx` during this audit.

The actual Flutter screen behavior and navigation are documented in `ARCHITECTURE.md`; design requirements and screen guidance are documented in `DESIGN.md`.

### 3.5 Web prototype constraints

Historical CSS notes describe a centered web shell approximately 390 pixels wide, a minimum height around 844 pixels, fixed-height regions, and breakpoints near 420 and 365 pixels.

These are unverified web-prototype references, not fixed requirements for native Flutter screen dimensions.

The Flutter implementation should adapt to available constraints, safe areas, keyboard insets, scrolling, and system text scaling. Responsive behavior must be verified through the tests and device checks recorded in `QA.md`.

## 4. Image and Asset Provenance

No original menu image files were retrieved or independently verified from the Figma Make project during this audit.

CSS image URL references do not establish that the corresponding files exist, are approved, or are licensed for reuse.

The Flutter project separately bundles 12 sample menu photos under `assets/images/menu/`. Their source and stated license information are recorded in `MVP.md`.

These sample photos must not be represented as original Figma or ARDO assets without supporting evidence.

Likewise, CSS font imports do not establish that the font files themselves were downloaded or included in the Flutter project.

Before claiming exact asset parity with the prototype, obtain the original asset inventory and verify each file's provenance, license, and intended use.

## 5. Relationship to Project Documentation

The documents have distinct responsibilities:

| Document | Responsibility |
|---|---|
| `PRD.md` | Approved product requirements, scope, and acceptance criteria |
| `ARCHITECTURE.md` | Implemented Flutter structure, components, local data flow, and navigation |
| `DESIGN.md` | Screen-level visual guidance, interaction expectations, responsive behavior, and requirements traceability |
| `MCP.md` | Figma MCP workflow, design evidence, and integration limitations |
| `POC.md` | Proof-of-concept experiments, validation, and recorded outcomes |
| `MVP.md` | MVP implementation scope, setup information, and asset provenance |
| `QA.md` | Actual automated and manual test execution, results, and unverified scenarios |
| `REVIEW.md` | Final review conclusions, known limitations, and remaining risks |
| `README.md` | Project overview, prerequisites, setup, and run instructions |

Figma MCP evidence can inform design decisions, but it does not supersede the approved PRD or establish that Flutter features have been implemented or tested.

`DESIGN.md` translates the available visual references into guidance for native Flutter. `ARCHITECTURE.md` describes the implementation approach. `QA.md` records the actual verification status.

## 6. Conclusion and Pending Verification

Historical project notes report that Figma MCP authentication was successful in a previous session. Authentication was not independently reverified during the current audit.

The CSS attachment remains a historical visual reference because its raw contents were not available for independent inspection. Direct retrieval of the original Make source, verification of Figma-provided images, and confirmation of local font availability remain pending.

The Flutter implementation should continue to follow the approved PRD and the screen-level guidance in `DESIGN.md`, while adapting web-prototype constraints to native mobile layouts.

Keep the evidence categories distinct:

- **Historical evidence:** Previous resource access, authentication reports, and user-provided design material.
- **Current implementation evidence:** Flutter source files, bundled assets, and automated tests.
- **Verified behavior:** Only behavior supported by recorded test execution or actual observed results.
- **Pending verification:** Original Figma asset provenance, unverified prototype details, and any device or platform checks not yet performed.

This distinction keeps the design process traceable without claiming that unavailable source material or untested behavior has been verified.
