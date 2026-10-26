# Changelog

All notable changes to `r-analytic-core` will be documented here. Versions and tags are independent of other plugins.

## [Unreleased]

### Changed

- Clarified that an explicit tidyverse preference governs imports, repeated-column transforms and ordinary iteration as well as `dplyr` calls, without imposing a strict global mode or refactoring unaffected code.
- Kept `.R`, `.Rmd` and `.qmd` setups small: shared imports and literal per-package `library()` calls, one-off `pkg::fun()`, no upfront analytical mega-chunks, automatic installation, dependency/path/locale discovery or `renv` bootstrap by default.
- Strengthened the default against new `stopifnot()`/defensive wrappers for ordinary missing packages, files and objects: use native R errors and agent-side inspection; retain meaningful diagnostics and narrowly justified protections against demonstrated silent corruption.
- Extended student-facing R guidance explicitly to notebook chunks; added scoped positive and exception cases for style consistency and execution requirements.

### Added

- Added scoped guidance for student-facing R scripts: simple lesson steps, local inputs, teacher-only analysis separation, and student handoff verification, without repeating research-code principles.

### Documentation

- Updated installation guidance and publication status after registering the `v0.1.0` release in the public Codex and Claude Code marketplaces.

## [0.1.0] - 2026-10-11

### Added

- Initial portable `r-analytic-coding-principles` skill for locally editable, research-first R code in `.R`, `.Rmd`, and `.qmd` files.
- Focused references for model/figure locality, purposeful duplication, helpers, package namespaces, and proportionate verification outside the working analysis.
- Codex and Claude Code plugin manifests, plugin architecture and roadmap, and behavioral validation scenarios.

### Changed

- Tightened namespace guidance around package use frequency, base R `library(..., exclude = ...)` and `conflictRules()`, optional `{conflicted}`, and verified function resolution before removing `pkg::`.
- Strengthened preservation of diagnostic counts/fields and data-frame column provenance, following a silent `sum(NULL, na.rm = TRUE)` field-test defect.
- Clarified CFA model-syntax locality and source-preserving `.qmd`/`.Rmd` edits, including chunk labels and YAML frontmatter.
- Refined behavioral evaluation cases to reflect real masking conflicts and distinguish skill discovery from actual reading.
- Documented native Codex field tests: isolated plugin installation, explicit versus implicit activation, R/Quarto regression checks, and remaining discovery limitations.
- Shortened the skill activation description to the concise version tested against natural-language style prompts; the substantive skill body and portability boundaries remain unchanged.
- Protected otherwise-unused analytical intermediates from deletion during defensive-check cleanup, following a new adversarial final-gate finding.

### Validated

- Completed a two-wave post-fix native Codex behavioral gate with independently checked R outputs and Quarto renders, including regression cases for preserving analytical intermediates.
- Confirmed plugin-scoped behavioral saturation after two post-fix waves (4 and 6 independent scenarios), with no new material in-scope failures.
- Verified native Codex skill discovery using a natural-language request for research R coding style; automated selection without that request remains opportunistic.
