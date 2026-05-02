# Changelog

All notable changes to `quarto-publishing` will be documented here.

## [Unreleased]

## [0.1.0] - 2026-05-02

### Added

- Added the initial `quarto-authoring-core` skill for Quarto `.qmd` authoring and review across R/knitr, Python/Jupyter, Julia, and prose-only workflows, with light adaptation of R Markdown idioms inside `.qmd` files.
- Added compact `.qmd` authoring patterns for YAML, executable cells, cross-references, citations, callouts, and light R Markdown interoperability.
- Added the initial `quarto-project-configuration` skill for `_quarto.yml`, `_metadata.yml`, shared metadata, profiles, parameters, and project-level configuration review.
- Added compact Quarto project configuration patterns for metadata placement, project profiles, render targets, parameters, resources, and project-level `freeze`.
- Added the initial `quarto-format-configuration` skill for output-format YAML and format-specific rendering behavior.
- Added compact Quarto format configuration patterns for HTML, PDF via LaTeX, PDF via Typst, DOCX, presentations, secondary formats, and advanced output mechanisms.
- Added the initial `quarto-computation-performance` skill for expensive computation, long renders, cache/freeze strategy, externalized computation, precomputed artifacts, engine-aware execution behavior, and proportional validation.
- Added compact Quarto computation performance patterns for cache/freeze, artifacts, pipeline escalation, random seeds, and long-render validation.
- Added the initial `quarto-render-troubleshooting` skill for Quarto render failures, rendered-output defects, diagnostics, targeted fixes, and honest verification.
- Added compact Quarto render troubleshooting patterns for YAML, execution, paths/assets, LaTeX, Typst, citations, cross-references, HTML verification, and local-vs-CI differences.
- Added the initial `quarto-report-design` skill for executive, technical, academic, and mixed Quarto report structure.
- Added profile-specific report design references for executive, technical, and academic reports, plus a basic transitional accessibility checklist.

### Removed

- Removed the scaffold `quarto-publishing-workflow` skill because it was superseded by the six Phase 1 skills and created broad activation overlap.

## [0.0.0] - Scaffold

Scaffold version; not a public release.

- Added the initial plugin manifest.
- Added the initial `quarto-publishing-workflow` skill.
- Added local Codex marketplace metadata.
