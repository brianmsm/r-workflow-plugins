# Changelog

All notable changes to `quarto-publishing` will be documented here.

## [Unreleased]

## [0.2.0] - 2026-06-15

### Added

- Added practical Quarto presentation format guidance for revealjs, PowerPoint, and Beamer workflows.
- Added slide-deck design guidance for audience, purpose, message titles, narrative sequence, slide density, and report-to-slides conversion.
- Added presentation-output verification guidance for revealjs, PowerPoint, and Beamer artifacts.

### Changed

- Refined `quarto-authoring-core` handoffs so project-level configuration routes to `quarto-project-configuration` when `.qmd` authoring is no longer the main concern.
- Kept the router skill deferred pending further evidence, relying on existing skill handoffs for broad presentation workflow coverage.

## [0.1.1] - 2026-06-15

### Changed

- Clarified `quarto-report-design` guidance for mixed and technical reports so source code remains inspectable with folded code when appropriate, instead of being hidden by global `echo: false`.
- Calibrated handoff guidance among existing Phase 1 skills so `quarto-authoring-core` does not act as the default for every `.qmd` task.
- Strengthened `quarto-report-design` activation for manuscript/report restructuring, Results/Discussion boundaries, objectives/hypotheses, analytical narrative, and local review constraints.
- Strengthened DOCX and format-specific guidance for `reference-doc`, tables, captions, Word-oriented notation, CSL/citeproc behavior, and bounded post-render configuration.
- Strengthened `quarto-render-troubleshooting` guidance for rendered artifact verification across HTML, DOCX, PDF, citations, links, and post-render outputs.
- Strengthened `quarto-computation-performance` guidance for do-not-execute requests, expensive renders, external/generated artifacts, simulations/models, and proportional validation.

## [0.1.0] - 2026-05-02

### Added

- Added Claude Code plugin and marketplace metadata for `quarto-publishing`.
- Added agent setup documentation for Codex, Claude Code, and Gemini CLI installation paths.
- Added Codex interface branding with plugin icon and logo assets.
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
