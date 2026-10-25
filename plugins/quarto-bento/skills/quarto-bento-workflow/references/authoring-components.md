# QMD Authoring for Quarto-Bento

**Reference baseline:** installed CLI `0.1.1`, Linux; product commit `1b7e265bda07c060215051302f252a7289f4a1f9`, reviewed 2026-10-17. The product's authoring document mixes target design with implemented subsets; this reference uses the latter. Ordinary Quarto/revealjs behavior is not proof of Bento projection or round-trip support.

**Contents:** new source; identities; implemented components; reusable design; annotation levels; analytical examples; delivery and diagnostics.

## A New Presentation

Use one QMD per directory and keep its inputs nearby. Render only within the authorized execution/publication scope; an existing project reporting `NO_BASELINE` needs the [recovery preflight](sync-and-recovery.md#bound-project-identity-before-recovery) before initialization. A fresh QMD needs neither `format: revealjs` nor an invented `format: bento` for `qbento render`.

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

**Ownership:** QMD visual attributes own explicitly sourced fields; compatible saved native edits override other fields; registry theme/layout values provide defaults. Reconcile source-owned geometry before moving coupled children; proximity does not establish grouping.

**Studio:** **Aplicar diseño** requires a selected layout, explicit object-to-column assignments and **Vista previa de posiciones** before applying; unmatched objects retain position. Free-object geometry is a saved snapshot: after editing a named definition in **Diseños y temas**, reapply it. Source components using a named layout pick up regenerated defaults. See the [pinned registry contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/DESIGN_REGISTRY.md).

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

Annotation options affect **optional QMD source patches** during reviewed sync; Save/render do not add them. They require stable heading identities but never replace technical `qb:*` IDs. Preserve user-authored declarations; source-edit authorization is handled in [selected sync](agent-api.md#selectively-synchronize-authored-changes-011). Nested `format: ... annotations:` is not implemented.

## Analytical Output Without Faking Provenance

**Literal tables:** a bare Markdown pipe table or an identified wrapper containing **exactly one contiguous literal pipe table** can project to native state. Keep prose and other semantic blocks outside that wrapper. Keep headers and cells short enough to fit on one line at their allotted native width (`qbento 0.1.1` refuses unsupported wrapping with `UNSUPPORTED_TABLE_LAYOUT`); place long units, such as "Mean outcome (arbitrary units)", in nearby prose instead of a column heading.

**Computed tables are a separate supported path:** an identified, single-producer R chunk emitting a compatible pipe table (for example `knitr::kable(..., format="pipe")`) is not a *literal* table wrapper and retains its execution provenance. See the computed-output rules below. If a render refuses either table type, preserve the source and obtain review/authorization before a new execution.

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

- **Computed content:** use an inline expression such as `` `r mean(values$x)` `` only when `values` is produced by a real executed chunk. Supported `knitr::kable(..., format="pipe")` tables retain producer provenance; `gt`/`gtsummary` need image generation. Do not substitute literal values for computed results or reverse-edit native cells, charts or figures into executable code.
- **Fidelity limits:** native bar/line charts have bounded labels/precision and require a frame at least 242px tall with space for labels/legend. Rich table cells/captions/spans and unbound producers may refuse. Math uses the pinned KaTeX subset; browser/font metrics determine fit. Check the [pinned authoring contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AUTHORING.md) before unusual output.

## Computation, Integration and Output

R, Python and other engines require the actual document's runtime/dependencies; a prose-only QMD need not require R. Preserve the code/inputs, figure labels and provenance. A `.bento-kpi` computed value, figure image or generated table must update through execution. Performance guidance can come from `quarto-computation-performance` when available, but do not externalize analyses or change code organization simply because Bento is used.

Only use ordinary `quarto render` integration **after** a deliberate `qbento init deck.qmd` installation. Its custom format is `qbento-html`, with product-supplied hooks/filters. `init` refuses replacing existing project configuration; `init ... --extension-only` leaves integration choices to the user. Do not rewrite an existing `_quarto.yml` or remove hooks as a shortcut.

- **Editable handoff:** preserve the QMD, inputs/assets, project binding and `.qbento/` state/design. Generated `.bento.html` is a static offline presentation, not a substitute for saved state; native HTML edits require the matching Save/capture workflow.
- **PDF/print:** use Bento's supported browser print/PDF representation; hidden slides are omitted. Do not invent `qbento pdf`/`export` or claim untested print dialogs.
- **Plotly:** Studio **Presentar con gráficos** can save a separate offline interactive viewer; ordinary HTML/PDF display static SVG. Generating the viewer requires compatible local Plotly/producer dependencies and Chromium, but opening the saved viewer does not require R, Plotly or a local server. This is not universal browser certification.
- **Rich tables:** supported `gt`/`gtsummary` need Chromium for faithful 2× PNGs and may refuse oversized output; adjust producer/layout instead of dropping rows or silently shrinking. Report the output actually generated and verified.

## Pinned Product Sources

- [Implemented authoring subsets and target-only cautions](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AUTHORING.md)
- [Canonical examples](https://github.com/brianmsm/quarto-bento/tree/1b7e265bda07c060215051302f252a7289f4a1f9/examples)
- [Usage, publication and composition limits](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/USAGE.md)
- [Public design-registry schema](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/DESIGN_REGISTRY.md)
