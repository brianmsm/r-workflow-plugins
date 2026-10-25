# QMD Authoring for Quarto-Bento

**Reference baseline:** installed CLI `0.1.1`, Linux; product commit `1b7e265bda07c060215051302f252a7289f4a1f9`, reviewed 2026-10-17. The product's authoring document mixes target design with implemented subsets; this reference uses the latter. Ordinary Quarto/revealjs behavior is not proof of Bento projection or round-trip support.

**Contents:** new source; identities; implemented components; reusable design; annotation levels; analytical examples; delivery and diagnostics.

## A New Presentation

Use one QMD presentation per directory. Keep source and inputs together, and render only trusted, authorized source. Before rendering an existing QMD with `NO_BASELINE`, look for saved `.qbento/` recovery material (especially `state.previous.json`) as described in the synchronization reference; a missing current state is **not** proof of an empty design. A minimal file is sufficient; neither `format: revealjs` nor a guessed `format: bento` is required for the `qbento render` workflow.

```qmd
---
title: Research update
---

## Finding {#finding-slide}

::: {#finding-text}
A supported authored statement.
:::

## Next step {#next-step}

::: {#next-action}
Discuss the result with collaborators.
:::
```

```sh
qbento render deck.qmd
qbento get deck.qmd
```

The regular native projection starts slides at **top-level H1 or H2**; H3–H6 and headings inside components remain content. YAML `title` is deck metadata, not an additional source slide. Do not import revealjs-only `slide-level`, theme, or fragment assumptions without a confirmed Bento contract.

Explicit heading/block IDs and named executable chunks aid stable mapping. Plain headings/paragraphs are also supported: sync may propose visible identity patches for weak source bindings. Preserve existing IDs; do not mass-generate `qb:*` markers or rename identities once design is attached. A semantic source ID, native slide-scoped element ID and animation/morph identity are different concepts.

## Declarative Components

Use small, directly inspectable source structures. Syntax below is Quarto-Bento-specific, not native Bento object types.

| Source component | Implemented shape / consequence |
| --- | --- |
| `.bento-card` | Identified div with supported authored text/headings/code or mapped computed figures; background is native decoration |
| `.bento-layout` | `bento-layout-name="two-column"` with two identified direct children, or a compatible named registry definition with its declared child count |
| `.bento-kpi` | Identified label/value/optional detail roles, one paragraph each; literal or supported computed inline value |
| `.bento-chart` | Bounded native bar/straight-line chart from explicit simple table data; not arbitrary ECharts configuration |
| `.bento-code` | One displayed, **non-executable** fence; never wrap a runnable `{r}` chunk |
| `.bento-diagram`, `.bento-timeline` | Bounded literal nodes/edges or milestones; use their documented source schema, not free-form Mermaid/HTML |

A layout example (each nested div has its own identity):

```qmd
## Findings {#findings}

:::: {#grid .bento-layout bento-layout-name="two-column"}
::: {#first-card .bento-card}
### Main result
An authored observation.
:::
::: {#second-card .bento-card}
### Implication
An authored implication.
:::
::::
```

Use **`bento-layout-name`**, not `layout="two-column"`; Quarto interprets the latter as its own layout syntax and Bento refuses it. QMD geometry/styles retain source ownership. Moving an individual child cannot safely invert coupled parent geometry; `UNMAPPED_DESIGN` is a reason to review ownership, not force coordinates. Avoid explicit child geometry that parent fitting would overwrite.

A KPI role schema:

```qmd
## Overview {#overview}

:::: {#participants .bento-kpi}
::: {#participants-label bento-role="label"}
Participants
:::
::: {#participants-value bento-role="value"}
120
:::
::: {#participants-detail bento-role="detail"}
Descriptive count
:::
::::
```

Here `120` is **literal text**. For a data-linked result, author an appropriate Quarto inline expression with its actual producer/data, rather than typing the rendered value into Bento. Role containers are direct, identified children in label/value/detail order, without extra classes. Studio-created KPIs also begin as literal authored values; the form does not create a calculation.

## Content Limits That Affect Editing

- **Text/lists:** bounded rich inline text, paragraphs and supported native lists can round-trip. Arbitrary HTML, widgets and inferred group membership are not general source import mechanisms.
- **Displayed code:** use a non-executable attributed fence, e.g. `{#example .r}`. A runnable `{r}` chunk and echoed executable code have computed provenance. Never promote displayed code to execution through a native edit or synchronization.
- **Notes:** one clear top-level identified `.notes` div per source slide. Native notes are plain text; rich Markdown, inline computation and ambiguous multiple containers are outside the bounded round-trip. Studio/API can create plain notes through reviewed synchronization when the source baseline permits it.
- **Images:** supported local PNG/JPEG/WebP or compatible self-contained SVG must lie within the project. Captions can synchronize through their mapped pair; changing an asset path, deleting a pair, numbered/computed captions and other unsupported edits must not be presented as generally reversible.
- **Tables/charts:** simple pipe tables and mapped computed tables can project; reverse cell/chart-data synchronization is not implemented. Edit their source or producer, not `rows`/`option` to fake data changes. Supported native charts require an empty category header, named numeric series and compatible geometry; missing values/precision/label limits are real.
- **Diagrams:** identified top-level nodes and source `from`/`to` edge attributes, bounded DAG (2–6 nodes, at most 3 columns, 2 nodes per column, 8 distinct edges). No computed labels or universal graph layout. Studio **Relaciones** is the supported endpoint control; dragging a connector endpoint detaches its anchor in the pinned editor.
- **Timelines:** 2–6 literal identified milestones; source order defines adjacency. Changing native z-order does not change the semantic sequence.

For uncommon composition, consult the pinned product examples/implemented section before authoring rather than inventing new `.bento-*` syntax. A native API operation can support fewer creation types than Studio or QMD.

## Reusable Design and Explicit Ownership

The optional `.qbento/design.json` is a **user-facing registry**, not an internal state journal. Create/edit it only when the user requests design changes, within its schema; normally prefer Studio **Diseños y temas** → **Guardar diseños**. Example (trimmed to supported properties):

```json
{
  "schemaVersion": 1,
  "layouts": {"three": {"columns": 3, "gap": 20, "padding": 10}},
  "themes": {"forest": {"background": "#e8fff0", "color": "#123a24", "accent": "#26734a", "fontFamily": "Arial, sans-serif"}},
  "activeTheme": "forest"
}
```

Layout names begin with a lowercase letter and contain lowercase letters, digits or hyphens (max 64 characters), with up to **64 layouts** and **32 themes**. Custom layouts require **1–6** columns; `two-column` is reserved. The number of identified **direct** QMD children must match `columns`, selected with `bento-layout-name="three"`. Themes support only `background`, `color`, `accent`, `fontFamily`; `activeTheme` must be explicit when themes are defined. This 256-KiB regular JSON file does not download fonts or run computations.

**Precedence:** explicitly authored QMD visual attributes control their own fields; allowed saved native edits are sparse overrides for other fields; registry theme/layout values are defaults, not a license to overwrite authored or manually saved fields. Studio **Aplicar diseño** requires choosing a layout, **explicitly assigning each intended object to a column**, and inspecting **Vista previa de posiciones** before applying; unmatched objects keep their positions. Free objects save geometry as a snapshot: after changing a named definition in **Diseños y temas**, *reapply* it to those objects. Source components referencing a named layout use its regenerated defaults. Changes to sourced geometry or coupling need reviewed source synchronization; do not infer grouping from proximity. See the [pinned registry contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/DESIGN_REGISTRY.md).

## Optional QMD Annotations

Only the **top-level QMD frontmatter scalar** is implemented; the default is `minimal`:

```yaml
---
title: Study summary
qbento-annotations: minimal  # none | minimal | detailed
---
```

- `none`: no optional `.qbento-design` heading class/reference comments; **technical IDs and required semantic edits remain**.
- `minimal` (default): a `.qbento-design` heading class for identified slides that have externally retained design.
- `detailed`: same class plus a bounded descriptive JSON comment referring to sidecar paths/categories, **not copied coordinates**.

These are optional *source mutations* proposed only during reviewed sync. Neither Save nor render creates them. They require suitable stable heading identities; they do not replace required technical `qb:*`/source IDs. A data/design-only task forbidding QMD edits must **not** apply an annotation-only proposal. Keep existing user QMD declarations authoritative. The earlier nested `format: ... annotations:` proposal is not implemented.

## Analytical Output Without Faking Provenance

A plain identified Markdown table can project to a native table. **Keep every
header and cell short enough to fit on one line in its allotted native column**;
`qbento 0.1.1` conservatively refuses tables needing unmeasured cell wrapping with
`UNSUPPORTED_TABLE_LAYOUT`. For instance, prefer `| Group | N | Mean |` and put
"Mean outcome (arbitrary units)" in adjacent prose rather than as a long
column header. An identified table wrapper must contain exactly one literal pipe
table and no accompanying prose or other semantic blocks; place explanatory
paragraphs outside it. Refusal means no completed render: shorten/split the
source table, then require fresh review and authorization before trying again.

```qmd
## Descriptives {#descriptives}

| Group | N | Mean |
| --- | ---: | ---: |
| A | 30 | 2.1 |
| B | 35 | 2.8 |
```

A bounded native bar/line chart instead uses an empty category header and named numeric series:

```qmd
## Effects {#effects-slide}

::: {#effects .bento-chart bento-chart-kind="bar"}
| | Estimate | Other |
| --- | ---: | ---: |
| Alpha | -2.5 | 1.25 |
| Beta | 0 | 3 |
:::
```

For mathematics, author the actual QMD expression rather than editing native equation pixels:

```qmd
## Estimation {#estimation}

$$
\hat{\theta}=\frac{1}{n}\sum_{i=1}^n x_i
$$
```

A computed number can use Quarto inline R such as `` `r mean(values$x)` `` **only if `values` is genuinely created by an executed source chunk**. Computed `knitr::kable(..., format="pipe")` tables retain producer provenance; `gt`/`gtsummary` tables are handled as rendered images. Literal cells are not valid substitutes for recalculated values. Reverse cell, chart-data and computed-figure edits into executable R/Python are unsupported. Native bar/line charts use bounded options, labels and precision; chart frames need at least 242px height and space for labels/legend. Unsupported rich table cells/captions/spans or unmapped producers must not be passed off as faithful conversions. Mathematical output uses the pinned KaTeX-supported subset; browser/font metrics determine actual fit. See the [pinned authoring contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AUTHORING.md).

## Computation, Integration and Output

R, Python and other engines require the actual document's runtime/dependencies; a prose-only QMD need not require R. Preserve the code/inputs, figure labels and provenance. A `.bento-kpi` computed value, figure image or generated table must update through execution. Performance guidance can come from `quarto-computation-performance` when available, but do not externalize analyses or change code organization simply because Bento is used.

Only use ordinary `quarto render` integration **after** a deliberate `qbento init deck.qmd` installation. Its custom format is `qbento-html`, with product-supplied hooks/filters. `init` refuses replacing existing project configuration; `init ... --extension-only` leaves integration choices to the user. Do not rewrite an existing `_quarto.yml` or remove hooks as a shortcut.

Save the QMD, inputs, project identity, `.qbento/` state/design and other required resources for editable reproduction. The generated `.bento.html` is an **offline static presentation** (and can be edited through its supported native Save/capture cycle), not a substitute for durable project state. For PDF, use Bento's **native print/PDF representation** in a supported browser; hidden slides are omitted. Do not invent a `qbento pdf`/`export` command or claim all desktop print dialogs have been tested. For supported **Plotly**, Studio **Presentar con gráficos** opens/saves a separate offline viewer with interactive chart views; ordinary HTML/PDF show the **static SVG**, not a position-preserving interactive overlay. Generating/capturing the supported interactive Plotly views requires Chromium and a compatible local Plotly runtime (including its producer dependencies). **The delivered viewer bundles its interactive resources for offline viewing in a compatible browser**; recipients do not need a running R process, Plotly installation or local server merely to open that generated artifact. This does not certify every browser or platform. Supported `gt`/`gtsummary` tables need Chromium to generate faithful 2× PNGs and may refuse when content will not fit; adjust the producer/table layout rather than silently shrinking/removing rows. Report which output was actually generated and inspected.

## Pinned Product Sources

- [Implemented authoring subsets and target-only cautions](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AUTHORING.md)
- [Canonical examples](https://github.com/brianmsm/quarto-bento/tree/1b7e265bda07c060215051302f252a7289f4a1f9/examples)
- [Usage, publication and composition limits](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/USAGE.md)
- [Public design-registry schema](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/DESIGN_REGISTRY.md)
