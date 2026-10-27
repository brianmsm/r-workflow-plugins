# Changelog

Versions belong to this **agent plugin**, independently of the Quarto-Bento application and other plugins.

## [Unreleased]

### Changed

- Added **version-gated compatibility guidance for the unpublished application `qbento 0.2.0` Linux candidate**: expanded reusable themes (role/named styles, variants, slots, checked design packages), measured code/result composition and full-data scroll, and bounded inline 2D/3D Plotly with explicit camera saving. The published application `0.1.1` lacks these additions; the **agent plugin stays version `0.1.1`** until an independent plugin release decision.
- Distinguish display-code fences from computed chunks, prevent generic API/HTML-widget execution or camera-patch inventions, prefer reusable native design before per-element styling scripts, and maintain source/pending/publication and offline-widget security boundaries.
- Document full-content PDF continuation and static SVG/PNG fallback without inventing PDF CLI options or treating visible clipping as permission to omit data.

### Validation and provenance

- Reviewed the app's `docs/evidence/COMPOSITION-INTERACTIVITY-0.2.0.md` and current implementation; the supplied Linux product gate reports **705 passing tests + 4 steps, 0 failures, 1 optional ignored check**, with browser camera, long output and a 14-page PDF. These are **application tests**, not an agent-skill behavioral trial.
- Independently installed the exact **dirty-source review tarball** (`ae96fc64…`) in an isolated npm prefix. Two synthetic QMDs completed real CLI renders plus checked `get`/`validate`; **43/43** physical/integrity checks passed, including retained design/slots, computed output, inline widget import and final rows. No user presentation, global CLI, app source or sealed evidence was changed. The app is not yet tagged/immutable; tests do not prove cross-platform UI or full agent activation/composition.


## [0.1.1] - 2026-10-26

### Changed

- Clarified optional `quarto-report-design` cooperation and output-engine-specific animation choices without introducing cross-plugin runtime dependencies.
- Added migration guidance: preserve existing Reveal.js `auto-animate` source declarations, explain that `qbento 0.1.1` does not map them into native morph, and provide static-stage or separately authorized native-motion alternatives.
- Explained that native Bento `morph` retained in `.qbento/` survived an ordinary same-identity QMD wording change without the optional `.qbento-design` annotation; `qbento sync` cannot export it as Reveal.js Auto-Animate.

### Validation

- Scoped Linux app-CLI probes: two successful synthetic first renders and a checked `get → patch → get → sync` preview established missing Auto-Animate interoperability; an additional synthetic QMD edit-and-render preserved a native `morph`. Neither study establishes browser playback compatibility or an all-format migration adapter. Evidence is stored outside the distributed plugin and the product gap is tracked in [qbento issue #1](https://github.com/brianmsm/quarto-bento/issues/1).
- Static skill/packaging validation passed; the revised instruction bytes have **not** undergone a new independent agent-behavior wave. No claim is made that the historical strict H2 gate became satisfied.

## [0.1.0]

### Added

- Initial `quarto-bento-workflow` skill with distinct new-project and existing-project paths.
- Three version-pinned operational references for JSON edits, source components, synchronization and recovery.
- Codex/Claude manifests and optional Codex skill UI metadata, sharing one agent-neutral instruction body.
- Architecture, roadmap and behavioral test scenarios; no bundled runtime, helper scripts, assets, hooks or mandatory cross-plugin dependency.

### Changed

- Reduced duplicate runtime guidance across the skill and references, separated inspection/Apply/render examples, and clarified literal versus computed tables and application-versus-plugin versions. Source, publication, recovery and execution safeguards remain; the editorial changes have static validation, not a new exact-byte agent trial.
- Scoped skill activation to genuine Quarto-Bento/qbento or `.qbento/` tasks; ordinary Quarto slide-format editing and independent HTML copies are excluded.
- Added a separate saved-native-content publication gate: excluded authored changes can remain visible in HTML despite correct selected QMD sync; refuse unsafe or unclear publication, and review the full deck before a one-shot operator render. No selective-publish API was invented.
- Clarified that data/design-only tasks do not authorize annotation-only QMD synchronization; preserve source bytes when the user prohibits source edits, even if a valid sync plan offers changes.
- Tightened discovery with concrete positive/negative triggers and clear task-boundary exclusions; put MUST-level persistence verification, optional-annotation scope gating and honest completion checks at the start of the workflow, with deeper details in existing references. No executable hooks were added.
- Documented a pre-execution browser-sandbox safety gate and an explicitly authorized external-render handoff: stop before a known-doomed QMD execution, verify source/identity/counter, execute the trusted project once in a compatible environment, and independently verify delivered HTML and retained state. No bundled renderer or permission bypass.
- Corrected R2-C001/R5-F01: both reconciliation preview and apply re-execute QMD and need execution authorization; source hashes and execution counters are separate evidence.
- Replaced contributor links that escaped an isolated plugin package with immutable repository-document URLs, including the same issue in its roadmap.
- Added reconciliation authorization and uninitialized-QMD regression scenarios.

### Validation

- Accepted a **prospective scoped local Linux/known-source** 0.1.0 release candidate on the owner's explicit methodological decision, **not** as fulfillment of the historical two-strict-H2-CLEAN-round gate. R1-NEW remains `NOT_CLEAN`, R2-LOCAL remains a distinct `PASS_LOCAL`, and R2-NEW was preparation-only.
- After a failed prospective first render on an overlong table heading (`UNSUPPORTED_TABLE_LAYOUT`), amended the table authoring reference to require conservative one-line headers/cells and one table without mixed prose per identified wrapper. A **new** one-shot Codex subject on the corrected reference then authored a supported two-slide table presentation. One independently reviewed host render produced real Bento HTML and saved native state with the correct table and slide identities (scoped local S/T/A/H PASS). Visual text bounds were **not** measured because Chromium reported `TEXT_MEASUREMENT_UNAVAILABLE`.
- Static portability and package validation passed with one skill, three relative operational references, matching Codex/Claude manifests, and no bundled runtime. Native Claude agent behavior, non-Linux platforms, untrusted source execution, rich/wrapped table support, full Studio UI and N01 recovery remain unverified; do not imply these passed.
- Evaluated focused native-agent publication scope with actual skill reads (8 actors; 4 private-output denials before render and 4 authorized one-shot host HTML publications). A one-line trigger-description A/B first found negative Bento reads 2/4 → 0/4 with an **unquoted, invalid-YAML** draft; retesting the **valid YAML-quoted** version found 1/4 false reads and 2/2 correct positive persisted geometry. This small, coordinator-run evidence is **not** two independent clean release waves or a zero-false-trigger guarantee.
- Recorded initial product/API checks, rendered reference examples and native Codex trials, including optional composition with Quarto performance guidance and explicit limits on visual/Studio coverage.
- Recorded R3's two non-clean agent-validation waves, subsequent H1/H2/H3 hook rejection (`REVISE_AND_RETEST`), and added regression rubrics for optional source annotations, false retained-design success and negative skill activation. Revised skill bytes require fresh independent agent tests before any release verdict changes.
- Recorded the R5 reconciliation-execution reproduction and ten fresh Codex trials against the corrected candidate; one wrong-version skill lookup is retained as a validation limitation, not counted as a successful candidate activation.

### Compatibility Updates (Quarto-Bento CLI 0.1.1)

- Raised the checked **application** baseline from 0.1.0 to installed and npm-published 0.1.1 with JSON agent protocol v1, independently of the agent plugin's prepared `0.1.0` version. Retained application 0.1.0 distinctions only as compatibility notes.
- Documented checked selective sync (`--select`), exact pending change IDs, deletion confirmations, atomic component selection and full-plan/auxiliary identity review.
- Clarified post-Apply retained pending/approval markers and separated QMD writes from authorized execution and rendering.
- Added strict project binding diagnostics, cautious `NO_BASELINE`/previous-state recovery preflight for unresolved N01, and practical design/annotation/delivery/overflow guidance.
- Clarified both successful Apply variants (with approval marker, or without marker and a possible pre-render `SOURCE_CONFLICT`) and required checks for genuine intervening source changes. Distinguished Plotly generation dependencies from the offline viewer's recipient requirements.
