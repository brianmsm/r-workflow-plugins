---
name: quarto-report-design
description: "Use to design or revise Quarto report, manuscript or teaching-slide communication: reader purpose, analytical argument, Results/Discussion, claims and evidence, tables/figures, technical depth, and reviewer-driven structure. Choose audience and report profile without inventing findings. Not for routine QMD syntax, format/project YAML, execution strategy, render verification or unrelated prose editing."
---

# Quarto Report Design

Make the reader's path from the substantive question through evidence, interpretation, limits and implications clear. This is communication design, not general prose polishing.

## Operating Workflow

1. Infer the **reader task and communication brief** from the request/project: audience, deliverable, public/internal scope, technical depth and local terms. Do not demand an outline or re-ask known preferences.
2. Select the lightest suitable report profile and, if needed, a secondary technical layer; use a routed profile reference for substantial detail.
3. Map objectives, questions, claims and recommendations to actual evidence; preserve observational units, populations, source values and denominators.
4. Organize by the reader's questions, **not** by software steps or editorial history. Introduce an object/comparison before its results; link evidence to interpretation, limits and implication.
5. Define consequential terms and derived measures where needed. Explain the purpose and limitations of diagnostics and how supplied decision criteria combine; do not invent thresholds or requirements.
6. Choose tables/figures for their evidentiary role (observed, transformed, diagnostic, didactic or process) and make labels, reference scales and uncertainty truthful and readable.
7. Keep the argument understandable with optional callouts closed; route supporting calculations, specifications or inventories into oriented technical detail without hiding decision-changing limits.
8. Before delivery, check central claims, numbers, figures, captions, objectives and linked evidence **against the actual sources**. Distinguish reviewed source from completed render or visual inspection; do not imply checks you did not perform.

## Profile Defaults

- **Executive:** decision, finding, implication, next step; keep extended methods in supporting detail.
- **Executive-academic:** readable decision-oriented body with scholarly definitions, inferential caution, citations, explicit evidence links and inspectable technical support.
- **Technical:** assumptions, model behavior, diagnostics and checks needed for analytical review; raw output only when useful to inspect.
- **Academic:** research questions/hypotheses, methods and findings organized as a supported argument, not a pipeline narrative.
- **Mixed:** name the primary reader task; present a readable main path with a deliberate secondary layer. For auditable HTML, use inspectable/folded source rather than hiding it by default.

Infer the profile from the task; do not impose a generic report template. Without a clear decision-making signal, an analytical R/Quarto report often calls for an academic-technical blend; confirm before **major** restructuring that changes reader purpose or scientific meaning.

## Cross-Profile Rules

- Lead each major section with its question or point and end with an implication, limitation, decision or transition. Explain the object and comparison before presenting numbers.
- Use **current-result voice** in public deliverables. Show substantive names first with a traceable mapping to internal identifiers; keep pipeline states, hashes, receipts, editorial chronology and sensitive operational IDs in internal records unless the reader needs them.
- Define consequential terms at first use; introduce variables before interpreting model results. Explain derived measures through original variables, transformation, missingness, scale and role rather than unexplained new quantities.
- Preserve **unit, population and denominator** across prose, figures, tables and conclusions; never treat unknown/unclassified cases as absent or classified subtotals as complete population totals. State lower-bound or conditional-percentage scope.
- Distinguish diagnostic fit, measurement/classification, association and prediction claims. When criteria interact, say which are necessary/sequential/non-compensatory, attribute any mandated rule and distinguish failure from missing evaluation; favorable evidence on one criterion does not cancel another.
- Keep every central claim linked to supporting evidence. A selective linked reading guide may help long comparisons; neither a full TOC nor a symmetric figure layout justifies creating an unestimated group or result.
- A **new** derived summary/combined view is permissible only within the authorized analytical scope and when verified from the actual data with method, population, weighting and limits stated. Otherwise display existing estimates faithfully or explain missing evidence; never fabricate statistics for narrative symmetry.
- Label figures/tables as observed, transformed, diagnostic, didactic or process. For transformed scores and contrasts, show reference, direction, units, neutral/zero value and relevant uncertainty, retaining original values when interpretation depends on them. Keep labels, populations and scales consistent across related displays.
- Introduce what to notice in each figure/table and connect it to the interpretation afterwards. Avoid raw console output in executive/polished bodies, but keep source code inspectable when the reader's task needs it.
- Honor user/local terminology, punctuation, reviewer comments, contractual objectives and format constraints. Reduce repeated prose **before** cutting evidence; preserve the supplied argument, claims, limitations, objectives and central displays.
- For prose-only edits, do not silently change calculations, source chunks, captions, cross-references or generated outputs; when artifacts **are** changed, revisit the associated text and evidence links.

## Code Visibility

Distinguish executable source from raw console output: avoiding console noise does **not** justify hiding the code a researcher needs to inspect. For technical, reproducible, debug-oriented, auditable or mixed HTML, default to folded source (`echo: true`, `code-fold: true`), suppressing routine messages/warnings only when not diagnostically relevant. Reserve global `echo: false` for reader-only executive/academic deliverables or when the same source is exposed elsewhere. Follow explicit visibility requests and do not silently change existing chunk outputs.

## User-Supervised Decisions

Infer ordinary choices when evidence and user preferences are clear; avoid repeated approval gates. Seek direction **before** a change that alters the report's purpose, intended audience, substantive claims, scientific meaning or required delivery medium. Examples include:

- Changing objectives/hypotheses, interpretation, recommendations, observational unit or order of analyses in a way that changes the argument.
- Removing, merging or substantially shrinking central sections, diagnostics, findings or appendices; relocating information needed for the main decision behind collapsed content.
- Replacing approved executive/academic/technical depth or creating a separate output version with different claims or audience.

Explain a bounded assumption when proceeding with ordinary edits; do not expand the analytical or publication task merely to satisfy a profile convention.

## References

- For decision-oriented reports, including reading guides, method comparisons, grouped tables, and interpretation of contrasts or transformed metrics, read `references/executive-report-structure.md`.
- For technical review, audit, reproducibility, and diagnostic reports, read `references/technical-report-structure.md`.
- For research, thesis, manuscript, methodological, and scholarly reports, read `references/academic-report-structure.md`.
- For **slide organization and delivery** (titles, hierarchy, density, visuals, timing), read `references/slide-deck-design.md`.
- For **teaching explanations or learning activities** (examples, misconceptions, controlled contrasts, interpretation), read `references/pedagogical-communication.md`. Read **both only when both types of decisions are in scope**; neither is required for an ordinary report.
- For basic transitional accessibility checks, read `references/accessibility-basic-checklist.md`.

## Boundaries

Use `quarto-authoring-core` for Quarto Markdown syntax, cell or chunk labels/options, citations, cross-references, captions, equations, callout syntax, or ordinary `.qmd` authoring mechanics.

Use `quarto-project-configuration` for `_quarto.yml`, `_metadata.yml`, shared metadata, profiles, parameters, render targets, resources, output directories, or project-level organization.

Use `quarto-format-configuration` for output-format YAML, HTML/PDF/DOCX/revealjs/PowerPoint/Beamer/Typst settings, themes, CSS/SCSS, reference documents, templates, includes, or extensions.

Use `quarto-computation-performance` for cache, freeze, long renders, externalized computation, seeds, precomputed artifacts, or pipeline escalation.

Use `quarto-render-troubleshooting` for failed renders, logs, YAML errors, cell or chunk errors, LaTeX or Typst errors, missing files, broken links, screenshots, browser inspection, rendered artifact checks, or verification claims.

For a Quarto-Bento presentation, keep audience, slide-design and pedagogical decisions here;
when `quarto-bento-workflow` is available, use it for Bento-native components, saved design,
source sync and rendering. Decide the teaching progression independently of the
engine; choose actual motion syntax by format. `auto-animate` belongs to
Reveal.js, not the verified Bento source codec. For Reveal.js-to-Bento
migration, preserve the original source and explain that the motion requires a
Bento-native recreation or a readable static alternative. Neither plugin is
required merely because the other was invoked.

Do not use this skill as the primary guide for scripts, assets, reusable templates, full accessibility audits, deployment workflows, or broad academic-writing guidance. If the user asks for those while designing a report, keep the report-design part limited and route the rest to the appropriate skill boundary.
