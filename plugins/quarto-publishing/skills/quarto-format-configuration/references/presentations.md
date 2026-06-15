# Quarto Presentation Format Patterns

## Purpose

Use this reference for format-level decisions and YAML for Quarto presentation outputs. It is not a slide-design guide; keep audience, narrative sequence, and slide-density decisions in `quarto-report-design`.

## Contents

- Choose the Presentation Format
- Common Slide Structure
- Revealjs
- PowerPoint
- Beamer
- Code, Figures, Tables, and Citations in Slides
- Render Verification
- Handoffs
- Official Sources Checked

## Choose the Presentation Format

Quarto presentation formats are related but not interchangeable:

- Use `revealjs` for HTML slide decks, browser presentation, rich web delivery, and decks that may also be printed or exported to PDF after render.
- Use `pptx` for editable Microsoft PowerPoint or Office slide decks, institutional PowerPoint templates, and workflows that require manual post-editing in PowerPoint.
- Use `beamer` for LaTeX/PDF academic slides, TeX-oriented themes, and scholarly workflows that require Beamer or PDF as the primary artifact.

Prefer `revealjs` unless the user has a specific Office, PowerPoint template, LaTeX, Beamer, or PDF-first academic requirement. Choose based on delivery environment, editability, institutional template requirements, PDF needs, web presentation needs, and the user's expected review workflow.

## Common Slide Structure

Slides are usually created with headings:

- Level 2 headings commonly create slides.
- Level 1 headings commonly create sections or title slides.
- Horizontal rules can separate slides without titles.
- Use `slide-level` when the default heading structure does not match the document.

Example:

```yaml
format:
  revealjs:
    slide-level: 2
```

Headings above `slide-level` divide the slide show into sections. Headings below `slide-level` create content within a slide, with format-specific behavior such as Beamer blocks.

## Revealjs

Minimal revealjs YAML can be as small as:

```yaml
format: revealjs
```

Use a keyed format block when adding options:

```yaml
format:
  revealjs:
    theme: simple
    slide-number: true
```

Practical options and patterns:

- `theme` selects a built-in revealjs theme.
- `slide-number: true` enables slide numbers. It can also take number-format strings such as `c/t`.
- `show-slide-number` limits where slide numbers appear: `all`, `print`, or `speaker`.
- `incremental: true` makes lists incremental globally. Use `.incremental` and `.nonincremental` divs to control individual lists.
- Insert `. . .` on its own line to create a pause within a slide.
- Use `.columns` and `.column` divs for multi-column slides.
- Use `.smaller` on crowded slides before reaching for dense formatting.
- Use `.scrollable` when content must overflow vertically, but treat it as a practical fallback rather than a design goal.
- Be careful combining `.scrollable` with image auto-stretch. Scrollable slides can make auto-stretched images size poorly or disappear; consider `auto-stretch: false`, `.r-stretch` only where needed, or `.nostretch` on scrollable slides.
- Speaker notes use a `.notes` div. Revealjs speaker view opens with the `S` key.
- Keep speaker notes plain and self-contained; do not make them depend on external JavaScript or runtime services.
- `footer` and `logo` add repeated footer text and a logo. Use slide-specific `{footer=false}` to remove a global footer on a slide.
- Code blocks can use many HTML code-block capabilities, but revealjs is still a slide format. Keep code blocks short, use `code-block-height` for taller blocks, and verify overflow.
- `syntax-highlighting: idiomatic` is not currently supported for revealjs and falls back to default Skylighting with a warning.
- Treat revealjs PDF export as rendered artifact verification. Do not claim the PDF version was checked unless it was actually generated and inspected.

Speaker notes example:

```markdown
## Results

Main slide content.

::: {.notes}
Presenter-only notes.
:::
```

Columns example:

```markdown
:::: {.columns}
::: {.column width="45%"}
Left content.
:::

::: {.column width="55%"}
Right content.
:::
::::
```

## PowerPoint

Minimal PowerPoint YAML:

```yaml
format: pptx
```

Use a PowerPoint reference template when the generated deck must follow institutional or brand layouts:

```yaml
format:
  pptx:
    reference-doc: template.pptx
```

Practical guidance:

- Use PowerPoint when the user needs editable Office slides, institutional slide templates, or manual post-editing in PowerPoint.
- PowerPoint supports the common slide heading structure, incremental lists, columns, and speaker notes.
- Use `reference-doc` for a `.pptx` or `.potx` template.
- A robust PowerPoint reference template should contain layouts named `Title Slide`, `Title and Content`, `Section Header`, `Two Content`, `Comparison`, `Content with Caption`, and `Blank`.
- If a required layout is missing, Pandoc may warn and use the layout with that name from the default reference document.
- Do not assume revealjs-specific HTML behavior, browser interactivity, CSS, or JavaScript will translate to PowerPoint.
- Inspect the generated `.pptx` when template behavior, slide layouts, figure/table placement, or speaker notes matter.

## Beamer

Minimal Beamer YAML:

```yaml
format: beamer
```

Use Beamer options when configuring academic PDF slides:

```yaml
format:
  beamer:
    theme: Madrid
    slide-level: 2
```

Practical guidance:

- Use Beamer when LaTeX/PDF academic slides are required, not merely because the user wants a PDF version of slides.
- `theme`, `colortheme`, `fonttheme`, `innertheme`, and `outertheme` control Beamer themes.
- `slide-level` controls which headings create slides.
- Incremental lists work globally with `incremental: true`; `.incremental`, `.nonincremental`, and `. . .` also apply to local slide behavior.
- Use `.columns` and `.column` divs for Beamer columns. Width and alignment attributes may matter more in Beamer than in browser slides.
- In Beamer, headings below `slide-level` can become Beamer `block` environments; `.alert` and `.example` can produce alert/example block variants.
- Frame attributes can be added through heading classes, such as `.fragile` when a frame needs the LaTeX `[fragile]` option.
- Beamer defaults to `echo: false` and `warning: false`, so executable code source and warnings are hidden unless overridden.
- Route LaTeX/PDF failures, theme problems, block rendering surprises, and overflow verification to `quarto-render-troubleshooting`.

## Code, Figures, Tables, and Citations in Slides

- Keep executable code chunks and code output short enough for a slide.
- Prefer figures and tables sized specifically for slides.
- Avoid dense tables; summarize on the slide and move detail to a report, appendix, handout, or notes when needed.
- Avoid overflowing code output. Use chunk options or smaller outputs rather than relying on slide overflow.
- Citations are possible with Pandoc-style citation syntax and bibliography metadata, but keep references slide-appropriate.
- Do not turn a deck into a manuscript with heavy bibliography mechanics unless the user asks for scholarly slides.
- Route dense methodological content to a companion report or appendix rather than overcrowding slides.

## Render Verification

- For revealjs, open the rendered HTML and check slide navigation when possible.
- For revealjs PDF export, only claim PDF export was checked if the PDF was actually generated and inspected.
- For PowerPoint, inspect the generated `.pptx` when template/layout behavior, figure/table placement, or speaker notes matter.
- For Beamer, verify the generated PDF. If rendering fails, inspect the LaTeX log and route to `quarto-render-troubleshooting`.
- Do not claim visual review unless the artifact was opened or inspected.

## Handoffs

- Use `quarto-report-design` for audience, narrative sequence, academic/executive/technical/teaching deck design, and slide density.
- Use `quarto-authoring-core` for slide Markdown, chunks, labels, figures, tables, citations, equations, and cross-references.
- Use `quarto-render-troubleshooting` for failed renders, generated artifact verification, browser inspection, PowerPoint inspection, PDF inspection, or LaTeX/Beamer errors.
- Use `quarto-computation-performance` if slides execute expensive models, simulations, or external artifact generation.
- Use future `quarto-multiformat-compatibility` only when the real problem is maintaining equivalent slides or handouts across several output formats.

## Official Sources Checked

Last reviewed: 2026-06-15

- [Quarto Presentations](https://quarto.org/docs/presentations/)
- [Quarto Revealjs](https://quarto.org/docs/presentations/revealjs/)
- [Quarto PowerPoint](https://quarto.org/docs/presentations/powerpoint.html)
- [Quarto Beamer](https://quarto.org/docs/presentations/beamer.html)
- [Revealjs format reference](https://quarto.org/docs/reference/formats/presentations/revealjs.html)
- [PowerPoint format reference](https://quarto.org/docs/reference/formats/presentations/pptx.html)
- [Beamer format reference](https://quarto.org/docs/reference/formats/presentations/beamer.html)
- [Quarto Citations](https://quarto.org/docs/authoring/citations.html)
