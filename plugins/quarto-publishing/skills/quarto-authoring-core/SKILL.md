---
name: quarto-authoring-core
description: Use when authoring, reviewing, or lightly migrating Quarto .qmd documents with R code, including Markdown structure, document YAML, knitr cell options, citations, cross-references, figures, tables, equations, and callouts.
---

# Quarto Authoring Core

Use this skill for Quarto `.qmd` authoring and review tasks, especially documents that combine prose, Markdown, citations, cross-references, equations, figures, tables, callouts, and R code cells.

## Operating Principles

- Treat the `.qmd` source as the primary artifact.
- Prefer Quarto-native syntax over legacy R Markdown habits when editing `.qmd`.
- Keep changes local to the document unless the user explicitly asks for project-level configuration.
- Preserve the author's writing style, analytical intent, and document purpose.
- Make the smallest useful correction that improves correctness, portability, readability, or maintainability.
- Mention classic R Markdown only for migration, comparison, or interoperability with Quarto.

## Review Checklist

When reviewing a `.qmd`, check:

1. Document YAML is valid, minimal, and appropriate for the requested output.
2. Headings form a coherent hierarchy.
3. R code cells use Quarto `#|` cell options where practical.
4. Cell labels are unique, descriptive, lowercase, and hyphenated.
5. Cross-reference labels use valid prefixes such as `fig-`, `tbl-`, `eq-`, and `sec-`.
6. Figures, tables, and equations that are referenced have captions or labels as needed; referenced sections have explicit `sec-` IDs when stable section references are required.
7. Citations use valid Pandoc syntax and match bibliography keys.
8. Callouts clarify communication instead of decorating the document.
9. Markdown remains readable as plain text.
10. Legacy R Markdown syntax is retained only when compatible or intentionally preserved.

## References

For compact syntax examples for document YAML, R cells, cross-references, citations, callouts, and R Markdown interoperability, read `references/qmd-authoring-patterns.md` when editing or reviewing concrete `.qmd` syntax.

## Anti-Scope

Do not redesign `_quarto.yml`, deployment, website or book structure, CI, long-running computation, caching architecture, custom extensions, or deep render troubleshooting unless the user explicitly asks.
