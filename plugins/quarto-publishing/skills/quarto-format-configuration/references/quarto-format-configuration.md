# Quarto Format Configuration Patterns

Use these compact patterns when reviewing or editing Quarto output-format configuration. Prefer official project conventions already present in the user's repository.

## Contents

- [Format selection](#format-decision-matrix) · [YAML shape](#yaml-shape-patterns)
- [HTML](#html-output) · [LaTeX PDF](#pdf-via-latex) · [Typst PDF](#pdf-via-typst) · [DOCX](#docx)
- [Citations](#citations-and-rendered-references) · [Presentations](#presentations) · [Books/sites](#books-websites-manuscripts-and-epub)
- [Multiformat](#minimal-multiformat-notes) · [Extensions/filters](#custom-formats-extensions-and-lua-filters)

## Format Decision Matrix

- `html`: interactive or browser-first reports, websites, notebooks, dashboards, and shareable HTML.
- `pdf`: usually LaTeX-backed PDF for academic, publisher, or TeX-heavy workflows.
- `typst`: Typst-backed PDF for simpler, faster PDF production when LaTeX-specific templates or packages are not required.
- `docx`: editable Word documents, institutional review workflows, and Word style templates.
- `revealjs`: browser-based HTML slides.
- `pptx`: editable Microsoft PowerPoint slides.
- `beamer`: LaTeX/PDF academic slides.
- `epub`: secondary ebook output when the content and formatting expectations are modest.

Choose the format before tuning options. Format-specific styling should serve the delivery target.

## YAML Shape Patterns

Single format:

```yaml
format:
  html:
    toc: true
    theme: cosmo
```

Multiple formats:

```yaml
format:
  html:
    toc: true
  pdf:
    toc: true
  docx:
    toc: true
```

Use `default` for a format when no custom options are needed:

```yaml
format:
  html: default
  typst: default
```

Avoid putting options under the wrong format key. For example, CSS belongs to HTML output, not DOCX or PDF output.

When rendering multiple formats that share an extension or output name, check whether output files could overwrite each other.

## HTML Output

Common HTML options:

```yaml
format:
  html:
    toc: true
    theme: cosmo
    css: styles.css
    code-fold: true
    embed-resources: false
```

Use `css` for small style changes. Use SCSS theme files when the user needs deeper Bootstrap or theme customization.

For HTML executive or executive-academic reports with figures that readers may need to inspect closely, use `lightbox: true` as the default unless the user opts out:

```yaml
format:
  html:
    lightbox: true
```

Automatic lightbox treatment applies to eligible block images; use `.nolightbox` for an individual image that should not enlarge, or apply `.lightbox` selectively when global treatment is not appropriate.

Lightbox does not repair an undersized, clipped, or poorly labeled figure. Keep the normal page view readable, preserve meaningful captions and alt text, and hand off browser, keyboard, enlargement, and bundled-resource checks to `quarto-render-troubleshooting`.

Lightbox configuration applies to eligible image elements; do not assume it automatically enlarges arbitrary inline SVG or Mermaid output. If close inspection matters, use a supported image asset or a deliberate full-size route and verify it. Respect an explicit request for non-interactive output.

### Responsive Figures and Diagram Colors

Inspect foreground/background pairs in the active theme, including title, subtitle, callouts, captions, legends, and generated diagram labels. A color chosen for a dark banner may be unreadable on a light title block; a theme's accent color can be too faint for small diagram text even when body text is readable. Check each supported light/dark mode separately when both are configured.

With Quarto's built-in Bootswatch themes, or custom themes using the same SCSS variables, default Mermaid colors follow the document theme. For a targeted correction, prefer its supported theme variables over selectors tied to generated node IDs. For example, a light report can set the following in its existing stylesheet, with colors chosen for that report:

```css
:root {
  --mermaid-node-fg-color: #172b4d;
  --mermaid-label-fg-color: #172b4d;
  --mermaid-node-bg-color: #edf3f8;
  --mermaid-label-bg-color: #ffffff;
}
```

This is a light-theme example, not a universal palette. Quarto also supports `format.html.mermaid.theme`; an explicitly selected Mermaid theme may use different controls. See [Mermaid themes](https://quarto.org/docs/authoring/diagrams.html#mermaid-themes) and verify the rendered result.

For a uniformly scaled SVG, estimate displayed text size as source font size × displayed width / viewBox width; nested transforms may require inspecting the actual SVG transform. Raster resolution alone likewise does not guarantee readable labels. Test the ordinary report column and intended narrow widths, including a phone-sized viewport when relevant. Recompose with wrapped labels, fewer side-by-side panels, or native text that can reflow; preserve the comparisons and branch logic. A global image width percentage or `max-width: 100%` prevents some overflow but does not establish readability.

For wide tables, prefer a labeled local scroll region or coherent smaller tables over shrinking all text. Keep header/reference context available and verify that clipped columns can actually be reached. Defining a wrapper's CSS does nothing unless the rendered table is inside that wrapper; an unconditional table `min-width` can instead widen the entire page. Scope styling to the relevant component; inspect static and generated tables together. These choices identify risks and possible remedies; rendered visual and keyboard verification belongs to `quarto-render-troubleshooting`.

HTML includes:

```yaml
format:
  html:
    include-in-header: header.html
    include-before-body: before.html
    include-after-body: after.html
```

Warn when raw HTML, JavaScript, widgets, or HTML-only layout features are expected to work the same way in PDF, DOCX, PowerPoint, or ePub.

## PDF via LaTeX

Common LaTeX PDF options:

```yaml
format:
  pdf:
    documentclass: article
    classoption:
      - 11pt
      - a4paper
    pdf-engine: xelatex
    include-in-header: header.tex
    keep-tex: true
```

Use LaTeX PDF when the user needs publisher templates, LaTeX packages, Beamer, mature academic PDF workflows, or precise TeX control.

Do not debug long TeX logs in this skill. If a render failure requires log analysis, defer to `quarto-render-troubleshooting`.

## PDF via Typst

Common Typst output:

```yaml
format:
  typst:
    toc: true
    number-sections: true
```

Use `format: typst` for Typst-backed PDF output. Do not configure Typst PDF as ordinary `format: pdf` unless the user has a specific advanced reason.

Consider Typst when the user wants simpler or faster PDF production and does not require a LaTeX-specific template, package, or publisher workflow.

Treat Typst options as distinct from LaTeX options. Do not assume LaTeX includes, packages, or document classes transfer to Typst.

## DOCX

Common DOCX output:

```yaml
format:
  docx:
    toc: true
    number-sections: true
    reference-doc: custom-reference.docx
```

Use `reference-doc` when Word styling, institutional templates, or repeatable DOCX formatting matter.

Do not try to reproduce complex HTML/CSS styling in DOCX. Prefer Word styles through the reference document.

Treat `reference-doc` as a style source, not a complete layout contract. Verify generated DOCX behavior when the task depends on:

- headers, footers, first-page behavior, or page numbers
- landscape sections or section breaks
- table widths, column distribution, font size, or line breaks
- captions, appendix labels, or table/figure wrappers
- Word-specific review workflows or comments

For Word-oriented prose and tables, avoid fragile raw LaTeX notation when Unicode or plain-text statistical notation is safer across DOCX readers.

Post-render scripts can be reasonable for narrow DOCX cleanup when built-in Quarto options and `reference-doc` styles are insufficient. Keep them scoped to the intended file type, documented, idempotent, guarded against non-DOCX renders, and verified after render.

When the question becomes "did the DOCX/PDF/HTML artifact actually render correctly?", hand off to `quarto-render-troubleshooting`.

## Citations and Rendered References

Use bibliography, CSL, `cite-method`, language, and reference-heading options when they affect rendered output. Correct configuration is only the first step: rendered citations and references may still need verification for raw keys, heading language, DOI output, and style behavior.

Do not turn citation data cleanup into a large bibliography-management workflow here. Use this skill for format behavior, and use `quarto-render-troubleshooting` when the rendered references need inspection.

## Presentations

Quarto presentation format families are `revealjs` for HTML slides, `pptx` for editable Office slides, and `beamer` for LaTeX/PDF academic slides. Browser-first decks usually start with `revealjs`; Office template or post-editing workflows use `pptx`; LaTeX/PDF academic requirements use `beamer`.

For practical presentation YAML, slide structure, revealjs/PowerPoint/Beamer options, speaker notes, slide numbers, templates, verification boundaries, and handoffs, read [`presentations.md`](presentations.md).

## Books, Websites, Manuscripts, and ePub

Review only output-format behavior here.

For books, format options usually live in `_quarto.yml` because chapters are rendered as a combined output. Project structure belongs to `quarto-project-configuration`.

For websites, review HTML output behavior, themes, page layout, resources, and format links only when they affect rendered output. Navigation and site structure belong to `quarto-project-configuration`.

For manuscripts or journal formats, keep guidance shallow unless the user is clearly using Quarto manuscript or journal tooling.

For ePub, keep styling expectations modest and check for HTML-only features that may not transfer cleanly.

## Minimal Multiformat Notes

Keep multiformat guidance small in this skill:

- HTML-only features may not work in PDF, DOCX, PowerPoint, or ePub.
- Raw LaTeX is usually PDF-oriented.
- Raw HTML is usually HTML-oriented.
- Multiple rendered formats can overwrite outputs when names or extensions collide.
- `format-links` can help expose alternate formats in HTML contexts.

Full cross-format design belongs to future `quarto-multiformat-compatibility`.

## Custom Formats, Extensions, and Lua Filters

Use custom formats, extensions, or Lua filters only when ordinary format options, CSS/SCSS, reference documents, includes, or templates are insufficient.

Custom formats should derive from an appropriate base format and have a concrete reuse case.

Lua filters are advanced output-behavior tools. This skill should usually warn, classify, or point to official docs rather than create filters.

## Official Sources

- Quarto all formats: https://quarto.org/docs/output-formats/all-formats.html
- Quarto format reference: https://quarto.org/docs/reference/
- Quarto HTML basics: https://quarto.org/docs/output-formats/html-basics.html
- Quarto lightbox figures: https://quarto.org/docs/output-formats/html-lightbox-figures.html
- Quarto HTML themes: https://quarto.org/docs/output-formats/html-themes.html
- Quarto PDF basics: https://quarto.org/docs/output-formats/pdf-basics.html
- Quarto PDF engines: https://quarto.org/docs/output-formats/pdf-engine.html
- Quarto Typst: https://quarto.org/docs/output-formats/typst.html
- Quarto MS Word: https://quarto.org/docs/output-formats/ms-word.html
- Quarto revealjs: https://quarto.org/docs/presentations/revealjs/
- Quarto PowerPoint: https://quarto.org/docs/presentations/powerpoint.html
- Quarto Beamer: https://quarto.org/docs/presentations/beamer.html
- Quarto book output: https://quarto.org/docs/books/book-output.html
- Quarto including other formats: https://quarto.org/docs/output-formats/html-multi-format.html
- Quarto custom formats: https://quarto.org/docs/extensions/formats.html
- Quarto filters: https://quarto.org/docs/extensions/filters.html
