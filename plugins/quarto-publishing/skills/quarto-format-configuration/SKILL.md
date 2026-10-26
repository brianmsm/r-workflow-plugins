---
name: quarto-format-configuration
description: Use for configuring Quarto output-format YAML and format behavior across HTML, DOCX, PDF (LaTeX/Typst), revealjs/PPTX/Beamer slides, books, websites, manuscripts and ePub, including styles, templates, citations and extensions. Hand off rendered-artifact verification. Not for ordinary QMD authoring, project configuration, report narrative, computation strategy, or render troubleshooting.
---

# Quarto Format Configuration

Choose format-specific Quarto options for the intended delivered artifact.

## Operating Principles

- Start from the intended output artifact: HTML page, website page, book, PDF, Word document, slide deck, manuscript, ePub, or secondary export.
- Review the `format:` block first, identify each requested output format, and check whether options are nested under the correct format key.
- Keep authoring and project architecture out of scope unless a format option directly affects rendering or placement.
- Review format options inside `_quarto.yml`, `_metadata.yml`, or document YAML only as format configuration; metadata architecture belongs to `quarto-project-configuration`.
- Prefer built-in Quarto format options before custom mechanisms.
- Check HTML foreground/background pairs in the active theme, including title, subtitle, captions, and generated diagram labels. Judge figure text at its displayed size at the intended reading widths, not its canvas size; reflow or split dense panels before shrinking the whole figure. Use the HTML reference below for theme controls and responsive choices.
- Use CSS/SCSS, reference documents, LaTeX includes, Typst options, templates, custom formats, extensions, or Lua filters only when simpler format options are insufficient.
- Be explicit about format limitations: HTML-specific features may not survive PDF, DOCX, PowerPoint, or ePub output.
- When configuring HTML executive or executive-academic reports with figures that benefit from close inspection, enable lightbox treatment by default unless the user opts out or the image should remain inline or non-interactive. In review-only tasks, recommend the change without editing. Keep the base figure legible without enlargement and treat lightbox as an HTML-only enhancement.
- Treat LaTeX PDF, Typst PDF, DOCX, revealjs, PowerPoint, and Beamer as related but distinct output systems with different option sets and constraints.
- Document cross-format limitations without treating a planned multiformat capability as an installed skill.
- Treat `reference-doc` as a Word style source, not a guarantee that every generated section property, header, footer, page number, landscape section, table width, or caption layout will behave as intended.
- Use post-render scripts only when built-in Quarto options and reference documents are insufficient; keep them scoped, documented, idempotent, format-guarded, and verified.
- Hand off to `quarto-render-troubleshooting` once the question is whether the rendered artifact actually looks, links, cites, or paginates correctly.

## Review Checklist

1. Match the selected output format to the deliverable; do not tune a format the user has not requested.
2. Place format options under the correct `format:` key at document, directory or project level without redesigning project metadata.
3. Distinguish HTML, LaTeX PDF, Typst PDF, DOCX and presentation engines: CSS, reference documents, templating and interactive features are not interchangeable.
4. Use built-in format options before CSS/SCSS, includes, postprocessors or custom extensions; keep any advanced addition scoped and justified.
5. For HTML, check requested theme colors, responsive figures, code options, citations and appropriate lightbox behavior; enlargement does not certify ordinary-page legibility.
6. For DOCX, assess styles, captions, tables, page/section layout and `reference-doc` limitations; for slides, choose revealjs/PPTX/Beamer by actual delivery needs.
7. Confirm multiformat outputs do not overwrite each other and report any unsupported cross-format expectation. Rendered visual/interactivity checks belong to troubleshooting.

## References

- **Presentations (revealjs, PPTX, Beamer):** read `references/presentations.md` for format choice, options, templates and notes.
- **Other formats (HTML, LaTeX/Typst PDF, DOCX, books, websites, ePub, extensions):** read `references/quarto-format-configuration.md` for concrete YAML/format questions.

Read **both only** when the task genuinely spans both lookup needs; do not load the general format guide merely because a slide deck uses Quarto.

## Anti-Scope

Do not rewrite general `.qmd` prose, Markdown structure, citations, cross-references, callouts, figures, tables, or equations unless a format option directly affects rendering.

Do not redesign `_quarto.yml`, `_metadata.yml`, project profiles, project types, render targets, output directories, or shared metadata beyond format-specific placement.

Do not design deployment, publishing, CI, GitHub Pages, Netlify, Posit Connect, Quarto Pub, or hosting pipelines.

Do not design caching, `freeze`, execution architecture, or long-running render performance.

Do not perform deep render troubleshooting, TeX log debugging, package installation repair, missing font diagnosis, Pandoc failure analysis, rendered DOCX/XML inspection, browser review, PDF page inspection, or environment setup.

Do not use this skill as the primary guide for full multiformat compatibility strategy, report narrative design, custom extension systems, Lua filter implementation, or reusable templates. Keep format advice limited to output behavior and route broader work to the appropriate skill boundary.
