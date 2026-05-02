# Quarto Format Configuration Patterns

Use these compact patterns when reviewing or editing Quarto output-format configuration. Prefer official project conventions already present in the user's repository.

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

## Presentations

Use `revealjs` for HTML slide decks:

```yaml
format:
  revealjs:
    theme: simple
    slide-number: true
    incremental: false
```

Use `pptx` for editable Office slides:

```yaml
format:
  pptx:
    reference-doc: template.pptx
```

Use `beamer` for LaTeX/PDF academic slides:

```yaml
format:
  beamer:
    theme: Madrid
    slide-level: 2
```

Revealjs, PowerPoint, and Beamer are not interchangeable. Choose based on delivery, editing needs, institutional templates, and PDF requirements.

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

Lua filters are advanced output-behavior tools. In v0.1.0, this skill should usually warn, classify, or point to official docs rather than create filters.

## Official Sources

- Quarto all formats: https://quarto.org/docs/output-formats/all-formats.html
- Quarto format reference: https://quarto.org/docs/reference/
- Quarto HTML basics: https://quarto.org/docs/output-formats/html-basics.html
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
