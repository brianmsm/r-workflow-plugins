# QMD Authoring for Quarto-Bento

**Reference baseline:** CLI `0.1.0`, Linux; product commit `a1b8025f522a5c4c70d10e613f9a7923dc6f761c`, reviewed 2026-10-17. The product's authoring document mixes target design with implemented subsets; this reference uses the latter. Ordinary Quarto/revealjs behavior is not proof of Bento projection or round-trip support.

**Contents:** new source; identities; implemented components; producer boundaries; configuration and delivery.

## A New Presentation

Use one QMD presentation per directory. Keep source and inputs together, and render only trusted, authorized source. A minimal file is sufficient; neither `format: revealjs` nor a guessed `format: bento` is required for the `qbento render` workflow.

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

## Computation, Integration and Output

R, Python and other engines require the actual document's runtime/dependencies; a prose-only QMD need not require R. Preserve the code/inputs, figure labels and provenance. A `.bento-kpi` computed value, figure image or generated table must update through execution. Performance guidance can come from `quarto-computation-performance` when available, but do not externalize analyses or change code organization simply because Bento is used.

Only use ordinary `quarto render` integration **after** a deliberate `qbento init deck.qmd` installation. Its custom format is `qbento-html`, with product-supplied hooks/filters. `init` refuses replacing existing project configuration; `init ... --extension-only` leaves integration choices to the user. Do not rewrite an existing `_quarto.yml` or remove hooks as a shortcut.

Save `.qbento/` project/state/design and needed resources with the QMD and inputs for editable reproduction. Generated `.bento.html` is a deliverable, not a substitute for retained project state. Bento's native print/PDF representation and the separate supported Plotly viewer are not CLI commands named `export`, `pdf` or `preview`. The installed CLI has no such general operations. A static image of a chart is not evidence of an editable or interactive native chart.

## Pinned Product Sources

- [Implemented authoring subsets and target-only cautions](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/AUTHORING.md)
- [Canonical examples](https://github.com/brianmsm/quarto-bento/tree/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/examples)
- [Usage, publication and composition limits](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/USAGE.md)
- [Public design-registry schema](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/DESIGN_REGISTRY.md)
