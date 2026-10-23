# Figma MCP Integration

## Purpose

Figma MCP supported design inspection and planning for implementing the ARDO visual reference in native Flutter. This documents planning support, not a completed Flutter implementation. Figma MCP does not automatically generate or convert the Flutter application.

## Project and workflow

- **Figma Make project:** ARDO Digital Menu
- **File key:** `KewPu6ikVpqYgj8hitWJqu`
- **Relevant Make source paths:** `src/App.tsx`, `src/index.css`, and `public/menu/`

In earlier VS Code work, Figma Make resources were accessed through **MCP: Browse Resources**, and source content was shared for design review. In this Agent session, the `figma-whoami` tool completed successfully, confirming authenticated access; account details are intentionally omitted. The current Agent did not independently retrieve `src/App.tsx`, `src/index.css`, or `public/menu/`. The earlier resource access and shared review material are distinct from source retrieval verified in this session.

## Evidence and limits

The earlier design review used a user-provided, read-only CSS attachment associated with the Make project. This attachment is the evidence available here; it does not establish that the current Agent retrieved `src/App.tsx`, `src/index.css`, or the `public/menu/` directory. The current Agent workspace contains the Flutter project, not those Make source files or menu assets.

The CSS attachment and approved design documentation establish the following visual reference:

- **Direction:** ARDO restaurant branding, navy surfaces, warm ivory/cream content areas, restrained gold accents, food photography, rounded menu cards, and category chips.
- **Colors:** The CSS evidence transcribed in [DESIGN.md](./DESIGN.md) lists navy tokens `#091326`, `#101d36`, `#1d3764`, and `#284a7d`; gold `#c9a75c` and `#e5cf9d`; ivory `#f7f3ea`; paper `#fffdf8`; ink `#172034`; and muted text `#73788a`.
- **Typography:** CSS imports referenced Cormorant Garamond for editorial headings and Manrope for body text and controls. The font files themselves were not retrieved or verified for local/offline use.
- **Screens and navigation:** The approved product/design documents describe Home, Search, Orders, and Profile navigation, category browsing, All Items, item details, and a QR scanner. The CSS attachment indicates styling for menu, search, scanner, and navigation elements; exact source component structure and interactions were not verified from `src/App.tsx`.
- **Web-prototype constraints:** The reviewed CSS evidence describes a centered shell capped at about 390 px, a minimum height around 844 px, fixed-height regions, and breakpoints near 420 px and 365 px. These web layout constraints are not appropriate as fixed Flutter screen dimensions; the mobile UI must adapt to available constraints, safe areas, scrolling, and text scaling.

No actual menu image files were retrieved or verified. CSS image URL references are not proof that the files exist, are approved, or are licensed for use. Do not treat CSS font imports as retrieved font assets.

## Relationship to `DESIGN.md`

[DESIGN.md](./DESIGN.md) records the screen-level design and translates the available visual evidence into responsive Flutter guidance. Use it to inform Flutter styling and layout while verifying assets and adapting web-specific dimensions for native devices. [PRD.md](./PRD.md) remains the source of product requirements, including required behavior and approved additions; design evidence does not supersede it.

## Conclusion and pending verification

Figma MCP authentication was verified in this session, and the previously reviewed CSS attachment provides useful ARDO visual guidance. Direct Make source inspection, menu-image verification and provenance, and local font availability remain pending. Flutter implementation should proceed from the approved PRD and DESIGN documents, with unresolved assets verified before they are bundled.
