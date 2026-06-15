---
name: quarto-format-configuration
description: Use when configuring or reviewing Quarto output-format YAML and format-specific rendering behavior for HTML, PDF via LaTeX, PDF via Typst, DOCX, revealjs, PowerPoint, Beamer, books, websites, manuscripts, ePub, themes, CSS/SCSS, reference documents, includes, templates, CSL/citeproc output behavior, Word-oriented formatting, DOCX tables/captions/landscape sections/headers/footers/page numbers, and custom formats or extensions when they affect output behavior. Hand off to render troubleshooting when the task becomes rendered artifact verification. Do not use for general .qmd authoring, project architecture, publishing/deployment, CI, caching/performance strategy, report writing, or deep render troubleshooting except when the issue is an invalid or misplaced format option.
---

# Quarto Format Configuration

Use this skill to configure or review Quarto output formats and format-specific YAML. Focus on whether the chosen format and options are appropriate for the intended rendered artifact.

## Operating Principles

- Start from the intended output artifact: HTML page, website page, book, PDF, Word document, slide deck, manuscript, ePub, or secondary export.
- Review the `format:` block first, identify each requested output format, and check whether options are nested under the correct format key.
- Keep authoring and project architecture out of scope unless a format option directly affects rendering or placement.
- Review format options inside `_quarto.yml`, `_metadata.yml`, or document YAML only as format configuration; metadata architecture belongs to `quarto-project-configuration`.
- Prefer built-in Quarto format options before custom mechanisms.
- Use CSS/SCSS, reference documents, LaTeX includes, Typst options, templates, custom formats, extensions, or Lua filters only when simpler format options are insufficient.
- Be explicit about format limitations: HTML-specific features may not survive PDF, DOCX, PowerPoint, or ePub output.
- Treat LaTeX PDF, Typst PDF, DOCX, revealjs, PowerPoint, and Beamer as related but distinct output systems with different option sets and constraints.
- Keep multiformat advice minimal here; full cross-format compatibility belongs to future `quarto-multiformat-compatibility`.
- Treat `reference-doc` as a Word style source, not a guarantee that every generated section property, header, footer, page number, landscape section, table width, or caption layout will behave as intended.
- Use post-render scripts only when built-in Quarto options and reference documents are insufficient; keep them scoped, documented, idempotent, format-guarded, and verified.
- Hand off to `quarto-render-troubleshooting` once the question is whether the rendered artifact actually looks, links, cites, or paginates correctly.

## Review Checklist

When reviewing Quarto format configuration, check:

1. The selected output format matches the user's delivery goal.
2. The request is really about format configuration, not authoring, project architecture, deployment, performance, or troubleshooting.
3. `format:` is present when needed and format-specific options are nested under the relevant format.
4. Shared options and format-specific options are separated only when the review requires it.
5. Multiple formats are not likely to overwrite outputs unexpectedly.
6. HTML options such as `theme`, `css`, `toc`, `code-fold`, `code-tools`, `code-overflow`, `syntax-highlighting`, `embed-resources`, `html-math-method`, and includes are appropriate when relevant.
7. PDF via LaTeX options such as `documentclass`, `classoption`, `pdf-engine`, `pdf-engine-opt`, `pdf-engine-opts`, `include-in-header`, and `keep-tex` are justified when relevant.
8. PDF via Typst uses `format: typst` and is considered when the user wants simpler or faster PDF production without LaTeX-specific templates or packages.
9. DOCX output uses `reference-doc` when institutional styling, Word styles, or repeatable Word formatting matter, without assuming those styles fully control the generated DOCX.
10. Presentation format choice is clear: `revealjs` for HTML slides, `pptx` for editable Office slides, and `beamer` for LaTeX/PDF academic slides.
11. Books, websites, manuscripts, and ePub are reviewed only for output-format behavior, not full project design.
12. Citation processing options such as bibliography paths, CSL, `cite-method`, language, and reference heading behavior are configured where they affect rendered output.
13. Word-oriented notation avoids fragile raw LaTeX when Unicode or plain text is safer for DOCX.
14. Custom formats, extensions, and Lua filters are treated as advanced choices that require a concrete reason.

## References

For compact examples and decision rules for HTML, LaTeX PDF, Typst PDF, DOCX, revealjs, PowerPoint, Beamer, secondary formats, custom formats, extensions, and minimal multiformat cautions, read `references/quarto-format-configuration.md` when editing or reviewing concrete format YAML.

## Anti-Scope

Do not rewrite general `.qmd` prose, Markdown structure, citations, cross-references, callouts, figures, tables, or equations unless a format option directly affects rendering.

Do not redesign `_quarto.yml`, `_metadata.yml`, project profiles, project types, render targets, output directories, or shared metadata beyond format-specific placement.

Do not design deployment, publishing, CI, GitHub Pages, Netlify, Posit Connect, Quarto Pub, or hosting pipelines.

Do not design caching, `freeze`, execution architecture, or long-running render performance.

Do not perform deep render troubleshooting, TeX log debugging, package installation repair, missing font diagnosis, Pandoc failure analysis, rendered DOCX/XML inspection, browser review, PDF page inspection, or environment setup.

Do not use this skill as the primary guide for full multiformat compatibility strategy, report narrative design, custom extension systems, Lua filter implementation, or reusable templates. Keep format advice limited to output behavior and route broader work to the appropriate skill boundary.
