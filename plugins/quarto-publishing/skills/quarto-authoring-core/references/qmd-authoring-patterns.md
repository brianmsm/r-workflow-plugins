# QMD Authoring Patterns

Use these compact patterns when reviewing or editing Quarto `.qmd` documents. Prefer official project conventions already present in the user's file, and check whether the document uses R/knitr, Python/Jupyter, Julia, or prose-only Markdown before assuming code behavior.

## Minimal Document YAML

```yaml
---
title: "Analysis Title"
author: "Author Name"
format: html
execute:
  warning: false
  message: false
---
```

For multi-format documents, keep format-specific detail proportional to the document:

```yaml
---
title: "Analysis Title"
format:
  html: default
  pdf: default
  docx: default
---
```

## Executable Cells

Prefer Quarto cell options as comments at the top of executable blocks. This pattern applies across engines; choose the code language that matches the document.

````markdown
```{r}
#| label: fig-sales-trend
#| echo: false
#| warning: false
#| message: false
#| fig-cap: "Monthly sales trend."

plot(sales$date, sales$value, type = "l")
```
````

For Python/Jupyter documents, the executable block uses `{python}` and the document or project may specify `jupyter: python3`. For Julia documents, check whether the workflow uses `engine: julia` or a Jupyter/IJulia kernel before changing execution assumptions.

Use labels that are unique, descriptive, lowercase, and hyphenated. Avoid underscores in labels that may be cross-referenced or rendered to PDF.

For a meaningful generated figure, `fig-cap` supplies the caption and `fig-alt` supplies alternative text; one does not automatically replace the other. Write the alternative from the actual display's comparison or message, with a nearby longer description when needed. Do not invent a trend from an example caption. Markdown images can use `![Caption](figure.png){fig-alt="Description of the displayed evidence"}`. Verify that the chosen renderer retains the alternative; decoration may intentionally have empty alt text.

## Scoped Analytical Edits

When a `.qmd` repeats model sections, sensitivity blocks, or cloned chunks, anchor edits narrowly:

- Match the chunk label, object-name prefix, and nearby heading before changing code or prose.
- Prefer scoped searches around the target section over repository-wide replacements.
- After editing, check that similarly named sections were not changed accidentally.
- If the change alters model comparisons, Results/Discussion meaning, or interpretation, use `quarto-report-design` as the primary guide.
- If the change would execute expensive models or simulations, use `quarto-computation-performance` before running anything.

## Cross-References

Use type-specific label prefixes:

- Figures: `fig-`
- Tables: `tbl-`
- Equations: `eq-`
- Sections: `sec-`

Figure and table cross-references normally include the localized type name. Prefer a sentence such as `See @fig-sales-trend` over adding another literal "Figure" before the reference; inspect the rendered wording when localization matters.

Examples:

````markdown
See @fig-sales-trend for the monthly pattern.

```{r}
#| label: fig-sales-trend
#| fig-cap: "Monthly sales trend."
plot(sales$date, sales$value, type = "l")
```
````

```markdown
As shown in @tbl-summary, the groups differ.
```

For a Markdown table:

```markdown
| Group | Mean |
|-------|------|
| A     | 10.2 |
| B     | 12.4 |

: Group summary {#tbl-summary}

See @tbl-summary.
```

For a computational table:

````markdown
```{r}
#| label: tbl-summary
#| tbl-cap: "Group summary."

summary_table
```
````

For an equation:

```markdown
$$
y = \alpha + \beta x
$$ {#eq-linear}

See @eq-linear.
```

For a stable section reference, add an explicit section ID:

```markdown
## Methods {#sec-methods}

See @sec-methods.
```

## Citations

Use Pandoc citation syntax and make sure cited keys exist in the bibliography:

```markdown
Prior work introduced this approach [@wickham2019].
Wickham [-@wickham2019] gives a practical treatment.
Several sources agree [@wickham2019; @xie2018, pp. 10-12].
```

Add bibliography metadata when citations are present:

```yaml
---
bibliography: references.bib
---
```

## Callouts

Use callouts for information that benefits from semantic emphasis:

```markdown
::: {.callout-note}
This note clarifies an assumption used in the analysis.
:::

::: {.callout-warning}
This result depends on incomplete input data.
:::
```

Prefer `note`, `tip`, `important`, `caution`, or `warning` according to the communication need.

## Raw HTML Components

Prefer native fenced divs, callouts, tables, and figures when they express the intended component. For intentional custom HTML or inline SVG, use an explicit raw block:

````markdown
```{=html}
<div class="summary-card">
  <p><strong>Finding</strong></p>
  <p>The evidence supports this bounded conclusion.</p>
</div>
```
````

Markdown and citation syntax inside a raw block are not processed as ordinary Markdown; keep them outside or use a native component. Nested, indented HTML without an explicit raw boundary can become escaped text inside a code block. After rendering, inspect each repeated component in the final HTML, not only whether an SVG element exists. Keep intentional code examples in documentation as code.

## R Markdown Interoperability

When lightly adapting R Markdown idioms inside `.qmd` files:

- Prefer Quarto `format:` over R Markdown `output:`.
- Prefer Quarto `#|` cell options over long chunk headers when editing `.qmd`.
- Keep compatible legacy syntax only when the user intentionally needs interoperability.
- Do not treat this reference as full migration guidance for R Markdown, Bookdown, Distill, Blogdown, Xaringan, ioslides, or Beamer projects.
