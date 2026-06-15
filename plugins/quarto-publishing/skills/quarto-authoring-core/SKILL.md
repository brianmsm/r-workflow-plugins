---
name: quarto-authoring-core
description: Use only for direct Quarto .qmd source authoring and review, including Markdown structure, document YAML, executable cell options, labels, citations, cross-references, figures, tables, equations, callouts, and light R Markdown idioms inside .qmd files. Route reader-facing report structure, delivered artifact behavior, rendered-output checking, execution strategy, and project-level YAML to more specific Quarto skills. Do not use for standalone .R/.py/data/model tasks that do not require Quarto source edits or renders, or for full R Markdown ecosystem migration.
---

# Quarto Authoring Core

Use this skill for Quarto `.qmd` authoring and review tasks, especially analytical documents that combine prose, Markdown, citations, cross-references, equations, figures, tables, callouts, and executable code cells.

## Operating Principles

- Treat the `.qmd` source as the primary artifact.
- Treat the document as Quarto-first and engine-aware: check whether it uses R/knitr, Python/Jupyter, Julia, or prose-only Markdown before assuming code behavior.
- Prefer Quarto-native syntax over legacy R Markdown habits when editing `.qmd`.
- Keep changes local to the document unless the user explicitly asks for project-level configuration.
- Preserve the author's writing style, analytical intent, and document purpose.
- Make the smallest useful correction that improves correctness, portability, readability, or maintainability.
- Mention classic R Markdown only for migration, comparison, or interoperability with Quarto.
- Do not make Quarto authoring the primary workflow just because a repository contains `.qmd` files. If the requested deliverable is a standalone `.R`, `.py`, data-processing, model-fitting, or analysis script and no Quarto source or render behavior is involved, stay with the project's ordinary analysis conventions.
- When editing repeated model sections or repeated chunks, anchor changes by chunk label, object-name prefix, and nearby section context. Avoid broad global replacements unless the user explicitly asks for them.

## Handoff Rules

Use this skill with, or defer primary control to, the following when the main risk is no longer ordinary `.qmd` source authoring:

- `quarto-report-design` when edits affect report or manuscript restructuring, Results/Discussion boundaries, objectives, hypotheses, analytical narrative, model hierarchy, length reduction, result placement, or interpretation of figures and tables.
- `quarto-project-configuration` when the task involves `_quarto.yml`, `_metadata.yml`, project profiles, parameters, project-level render targets, shared metadata, resources, output directories, websites, books, manuscripts as project structures, or project-level configuration rather than document-body authoring.
- `quarto-format-configuration` when the task involves output-specific YAML or behavior, especially DOCX/PDF/HTML, `reference-doc`, table width, captions, CSL/citeproc, Word-oriented formatting, landscape sections, headers, footers, page numbers, or format-specific rendering.
- `quarto-render-troubleshooting` when the task involves render failure, output verification, visual inspection, screenshots, links, anchors, final artifact checks, DOCX/PDF/HTML artifact checks, or post-render verification.
- `quarto-computation-performance` when the task involves expensive execution, simulations, model fitting, generated or external artifacts, user requests not to execute, cache/freeze, or proportional validation.

For slide `.qmd` files, use this skill for the actual slide source content: Markdown, headings, chunks, figures, tables, equations, citations, cross-references, callouts, and divs. Use the `quarto-report-design` skill and its `slide-deck-design.md` reference for audience, purpose, narrative sequence, message titles, density, and report-to-slides conversion; use the `quarto-format-configuration` skill and its `presentations.md` reference for revealjs/PPTX/Beamer YAML, themes, templates, slide numbers, speaker notes, and format-specific behavior; use `quarto-render-troubleshooting` for rendered slide verification.

## Review Checklist

When reviewing a `.qmd`, check:

1. Document YAML is valid, minimal, and appropriate for the requested output.
2. Headings form a coherent hierarchy.
3. Executable code cells use Quarto `#|` cell options where practical.
4. Cell labels are unique, descriptive, lowercase, and hyphenated.
5. Cross-reference labels use valid prefixes such as `fig-`, `tbl-`, `eq-`, and `sec-`.
6. Figures, tables, and equations that are referenced have captions or labels as needed; referenced sections have explicit `sec-` IDs when stable section references are required.
7. Citations use valid Pandoc syntax and match bibliography keys.
8. Callouts clarify communication instead of decorating the document.
9. Markdown remains readable as plain text.
10. Legacy R Markdown syntax is retained only when compatible or intentionally preserved.

## References

For compact syntax examples for document YAML, executable cells, cross-references, citations, callouts, engine-aware authoring, and R Markdown interoperability, read `references/qmd-authoring-patterns.md` when editing or reviewing concrete `.qmd` syntax.

## Anti-Scope

Do not use this skill as the primary guide for full migration from R Markdown ecosystems, report redesign, project-level `_quarto.yml` design, output-format behavior, deployment, website or book structure, CI, long-running computation, caching architecture, external pipelines, custom extensions, or deep render troubleshooting.
