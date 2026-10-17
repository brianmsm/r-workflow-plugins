# Changelog

Versions belong to this **agent plugin**, independently of the Quarto-Bento application and other plugins.

## [Unreleased]

### Added

- Initial `quarto-bento-workflow` skill with distinct new-project and existing-project paths.
- Three version-pinned operational references for JSON edits, source components, synchronization and recovery.
- Codex/Claude manifests and optional Codex skill UI metadata, sharing one agent-neutral instruction body.
- Architecture, roadmap and behavioral test scenarios; no bundled runtime, helper scripts, assets, hooks or mandatory cross-plugin dependency.

### Changed

- Clarified that data/design-only tasks do not authorize annotation-only QMD synchronization; preserve source bytes when the user prohibits source edits, even if a valid sync plan offers changes.
- Corrected R2-C001/R5-F01: both reconciliation preview and apply re-execute QMD and need execution authorization; source hashes and execution counters are separate evidence.
- Replaced contributor links that escaped an isolated plugin package with immutable repository-document URLs, including the same issue in its roadmap.
- Added reconciliation authorization and uninitialized-QMD regression scenarios.

### Validation

- Recorded initial product/API checks, rendered reference examples and native Codex trials, including optional composition with Quarto performance guidance and explicit limits on visual/Studio coverage.
- Recorded the R5 reconciliation-execution reproduction and ten fresh Codex trials against the corrected candidate; one wrong-version skill lookup is retained as a validation limitation, not counted as a successful candidate activation.
