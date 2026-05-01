---
name: quarto-publishing-workflow
description: Use for Quarto publishing workflows with R, including Quarto documents, analytical reports, websites, books, manuscripts, revealjs slides, _quarto.yml configuration, render troubleshooting, and reproducible rendering. Do not use for classic R Markdown unless the task involves migration, comparison, or interoperability with Quarto.
---

# Quarto Publishing Workflow

Use this skill to help an agent plan, edit, troubleshoot, or maintain Quarto publishing projects that use R.

## Workflow

1. Identify the output type: document, analytical report, website, book, manuscript, or revealjs slide deck.
2. Inspect the project shape before changing files: look for `_quarto.yml`, project profiles, `.qmd` files, R scripts, data dependencies, and render outputs.
3. Keep Quarto as the publishing system. Mention classic R Markdown only for migration, comparison, or interoperability.
4. Prefer minimal, project-local changes to `_quarto.yml`, document YAML, chunk options, execution settings, format options, or supporting R code.
5. Preserve reproducibility: check package assumptions, relative paths, seeds, data inputs, parameters, profiles, and render commands.
6. For render failures, read the exact error, identify whether it comes from Quarto configuration, Pandoc, knitr, R execution, dependencies, paths, or output format settings, then fix the narrowest cause.
7. Validate with the smallest useful command, such as rendering one `.qmd` file before rendering an entire website or book.

## Guidance

- Use `_quarto.yml` for project-wide settings and document YAML for page-specific settings.
- Keep analytical reports clear about inputs, transformations, outputs, and assumptions.
- For websites and books, consider navigation, cross-references, project structure, and output directories.
- For manuscripts, consider citation files, bibliography style, cross-references, figures, tables, and journal or preprint requirements.
- For revealjs slides, consider slide hierarchy, incremental content, code visibility, figure sizing, and presenter ergonomics.
- When troubleshooting, prefer concrete commands and file references over broad advice.
