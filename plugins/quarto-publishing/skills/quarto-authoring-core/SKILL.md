---
name: quarto-authoring-core
description: Use when authoring, reviewing, or lightly adapting Quarto .qmd documents, especially analytical documents using R/knitr, Python/Jupyter, Julia, or prose-only Markdown, including Markdown structure, document YAML, executable cell options, citations, cross-references, figures, tables, equations, callouts, and light adaptation of R Markdown idioms inside .qmd files. Do not use for full migration from R Markdown ecosystems, including R Markdown, Bookdown, Distill, Blogdown, Xaringan, ioslides, or Beamer projects.
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

Do not use this skill as the primary guide for full migration from R Markdown ecosystems, project-level `_quarto.yml` design, deployment, website or book structure, CI, long-running computation, caching architecture, custom extensions, or deep render troubleshooting.
