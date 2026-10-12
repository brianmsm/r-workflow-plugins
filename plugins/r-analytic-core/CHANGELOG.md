# Changelog

All notable changes to `r-analytic-core` will be documented here. Versions and tags are independent of other plugins.

## [Unreleased]

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
