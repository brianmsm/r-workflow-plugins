# Quarto Publishing Pilot Findings

This document summarizes anonymized findings from early real-project testing of the `quarto-publishing` plugin.

The underlying pilot notes may include private project context and should remain local. This public summary keeps only reusable design signals that informed the `v0.1.1` calibration patch.

## Findings Informing `v0.1.1`

### P01: Authoring Core Was Too Easy To Select

`quarto-authoring-core` was useful for direct `.qmd` source mechanics, but it could become the default for tasks that merely happened to involve a repository with Quarto files.

Design implication: keep authoring guidance focused on source mechanics and route report structure, format behavior, render verification, and expensive execution to more specific skills.

### P02: Report Design Needed Stronger Activation

Some tasks were primarily about report or manuscript structure rather than Quarto syntax. Repeated signals included Results/Discussion boundaries, objective or hypothesis alignment, analytical narrative, model hierarchy, reducing length, and placement of figures or tables.

Design implication: make `quarto-report-design` more visible for reader-facing structure and analytical argument work.

### P03: Format Configuration Needed Clearer DOCX Boundaries

Output-specific behavior, especially DOCX behavior, often required more than ordinary `.qmd` authoring. Examples included reference documents, table width, captions, citation processing, Word-oriented notation, page layout, and post-render behavior.

Design implication: strengthen `quarto-format-configuration` for format-specific YAML and route rendered artifact checks to troubleshooting.

### P04: Render Success Was Not Always Artifact Verification

A successful render command does not prove that the produced HTML, DOCX, or PDF artifact was inspected. Output review may require visual checks, package or XML checks for DOCX, citation and reference checks, link and anchor checks, screenshots, or page inspection.

Design implication: make `quarto-render-troubleshooting` cover both failures and rendered artifact verification, while requiring honest statements about what was actually checked.

### P05: Expensive Workflows Needed Proportional Validation

Some Quarto workflows depended on simulations, model fitting, external artifacts, or generated tables and figures. Full reruns were not always appropriate, especially when the user asked not to execute.

Design implication: strengthen `quarto-computation-performance` around source-only checks, targeted regeneration, external artifacts, and proportional validation.

### P06: Broader Evidence Is Needed Before New Skills

The current evidence supports calibration of the six existing skills, not immediate expansion into additional independent skills.

Design implication: continue Phase 2 testing with more diverse cases before opening `v0.2.0`, including HTML-only reports, PDF-only reports, websites, revealjs slides, `.Rmd` migration, deployment-oriented tasks, multi-output documents, and intentionally broken renders.

## Findings Informing a Future `v0.2.x` Calibration

### P07: Executive-Academic Reports Need an Explicit Communication Brief

A public analytical HTML report can follow a broadly reasonable executive structure while still exposing operational vocabulary, defining consequential terms too late, organizing sections around the analysis pipeline, or narrating editorial history instead of the current evidence.

Design implication: `quarto-report-design` should identify the primary reader task, public-versus-internal boundary, primary and secondary report profiles, terminology constraints, evidence routes, and current-state voice before drafting. Executive-academic work should keep the body executive while preserving academic precision through first-use definitions, citations, inferential cautions, and inspectable supporting detail.

### P08: Visual Narrative and Verification Require Separate Decisions

Figures, tables, diagrams, and interactive enlargement can support the argument only when their role, scope, and verification status are explicit. A successful render or the presence of HTML markup does not prove that a Mermaid diagram is legible, a table works at the intended viewport, or a lightbox interaction functions.

Design implication: report design should classify visuals as observed, transformed, diagnostic, didactic, or process artifacts and must not invent aggregates or subgroups for symmetry. HTML executive and executive-academic reports with inspectable figures should prefer lightbox treatment, while format configuration preserves base legibility and render troubleshooting reports source, render, structural, visual, and interactive checks separately.

### P09: Brief-Prompt Trials Need Evidence and Evaluator Controls

Fresh report trials exposed observation-unit drift, replacement of documented decision requirements, and incomplete classified counts presented as exhaustive totals. Custom HTML also rendered as escaped source despite a successful render. These defects occurred across explicitly selected models; a single model's success or failure cannot establish the skill's general quality.

Design implication: preserve units and denominators throughout the narrative, attribute requirements, distinguish unknown states from absence, and reverse-check central claims against evidence. Use a bounded structural helper for deterministic HTML defects, with contextual review of intentional code. Keep brief user requests separate from evaluation instructions, retest with fresh contexts, and distinguish legitimate methodological explanation from invented study facts. Assess source, render, structure, appearance, interaction, and installed discovery separately.

## What This Summary Excludes

This file intentionally excludes:

- Real project names, client or institution names, and private research context.
- Local file paths, repository paths, and identifying filenames.
- Specific report, manuscript, advisor, reviewer, or contract details.
- Detailed methodological content that could identify an active project.
- Raw case logs, dates, transcripts, prompts, or task-by-task histories.
