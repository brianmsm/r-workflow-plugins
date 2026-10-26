# Changelog

All notable changes to `quarto-publishing` will be documented here.

## [Unreleased]

_Changes in this section are intended for plugin v0.2.3; manifests and public catalog remain pinned to v0.2.2 until release._

### Changed

- Clarified optional cooperation with `quarto-bento-workflow`: share pedagogy and deck design but select animation mechanisms per output format; preserve authored Reveal.js transitions and disclose Bento motion-fidelity limitations during migration.
- Prefer concise nominal slide titles and add focused guidance for teaching explanations and learning activities, separate from general slide layout and rendering.

## [0.2.2] - 2026-09-10

### Changed

- Refined presentation guidance from a report's successive reader corrections: selective linked reading guides, shared-origin method explanations, distinct diagnostic/association/fit claims, and explicit references, directions, and neutral values for contrasts and transformed metrics.
- Added comparison-table patterns for grouped headers, statistic scales, reference categories, unavailable estimates, consistent typography, and usable narrow-screen lookup without hiding central evidence.
- Added guidance for supported Mermaid color controls, responsive composition, and browser verification of displayed text, contrast, image alternatives, table access, settled widgets, and real keyboard operation. Lightbox remains supplementary to readable inline figures.

## [0.2.1] - 2026-09-08

### Changed

- Hardened short-request report design with conditional analysis-scope maps, preserved observational units, attributed decision requirements, incomplete-data denominators, consistent reader/technical labels, transformed-scale provenance, and coherent visual sequences.
- Added explicit raw-HTML authoring guidance and paired color/displayed-size checks after field trials exposed escaped summary cards and low-contrast title text.
- Added a bounded, read-only HTML integrity helper with regression tests; markup in code remains an advisory requiring context, and structural results do not imply visual or interactive verification.
- Clarified `quarto-report-design` activation and workflow for public and institutional executive-academic reports, including communication briefs, public-versus-internal terminology, point-of-need definitions, evidence routes, final-product voice, and non-invention of unestimated views.
- Added visual-narrative guidance that distinguishes observed, transformed, diagnostic, didactic, and process artifacts and keeps captions, alt text, labels, and report prose aligned.
- Made lightbox the preferred default for HTML executive and executive-academic reports with figures that benefit from close inspection, while preserving readable base presentation.
- Separated source, render, structural, visual, and interactive verification claims and strengthened checks for Mermaid, collapsible content, rendered terminology, and lightbox behavior.
- Recorded anonymized pilot findings supporting calibration of the existing skills rather than creation of a new report skill.
- Clarified that evidence-backed, verified derivations within the authorized analytical scope are allowed, while unsupported aggregates and new analyses introduced solely for narrative symmetry remain excluded.

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
