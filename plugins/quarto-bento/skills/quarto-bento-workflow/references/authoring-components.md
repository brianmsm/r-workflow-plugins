# QMD Authoring for Quarto-Bento

**Compatibility:** published Linux app `qbento 0.1.1` is the pinned baseline. The
**unpublished 0.2.0 Linux candidate** (review tarball SHA-256 `ae96fc64…`, source
HEAD `b52772e` **with uncommitted changes**, 2026-10-27) adds capabilities
explicitly marked below. These were exercised using an isolated npm CLI on
synthetic projects; they are **not yet an immutable application release**.
Check the *actual application version*, independently of the agent plugin;
do not issue `qbento design` or 0.2-only QMD options on app `0.1.1`.

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

### Progressive motion and Reveal.js migration

Choose the target engine *after* deciding what each teaching stage must show:

- **New Bento presentation:** author stable, independently readable QMD stages.
  Use supported native Bento `morph` / `morphId` or other effects only as a
  separately reviewed visual-design edit; retain the project's `.qbento/` state.
  The optional `.qbento-design` QMD annotation is a **pointer**, not the motion
  definition or a prerequisite for persisting native transitions.
- **Existing Reveal.js QMD imported into Bento:** preserve authored
  `auto-animate`, `auto-animate-id`, `data-id` and semantic IDs in the original
  source. In the tested `qbento 0.1.1`, those attributes survive Quarto's
  intermediate HTML but **do not become** native `morph` transitions or paired
  `morphId` values; the native projection uses `fade`. Warn about lost motion
  fidelity and use readable static stages, or obtain approval to reconstruct
  native motion manually and verify its playback. Do not remove the source
  animation declarations merely to make a Bento output.
- **Subsequent edits or migration back:** a native `morph` transition survived
  an ordinary QMD wording edit and subsequent render with stable slide IDs in
  one additional synthetic test **without** `.qbento-design`. This does not
  establish safety for changing/deleting identities. `qbento sync` proposes
  only an optional annotation for native motion, **not** Reveal.js attributes;
  copying QMD back to Reveal.js therefore does not automatically export Bento
  effects. Retain the native sidecar for future Bento edits and reauthor
  transitions for the target engine when needed.

These are compatibility observations, not equivalent animation semantics or a
universal visual acceptance. The observed source/native gap is tracked in
[qbento issue #1](https://github.com/brianmsm/quarto-bento/issues/1).

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

`.qbento/design.json` is a **user-facing design registry**, not an internal
journal. Prefer a theme/variant/slot for repeated course styling; use bounded
checked `get → patch → get` for **exceptions**, not as the default way to set
hundreds of repeated coordinates. A one-time composition script is reasonable
when a design cannot be expressed by native reusable mechanisms, but rerunning
it may overwrite later manual edits.

**Installed app 0.1.1:** named themes contain only `background`, `color`,
`accent`, `fontFamily`; `qbento design` commands, role styles and slots are **not
available**. Studio **Diseños y temas → Guardar diseños** saves a basic registry;
**Aplicar diseño** assigns existing objects explicitly into a selected layout.
Saved free-object positions are snapshots; modifying a layout name alone does
not relocate them.

**Candidate app 0.2.0:** registry schema **remains 1** and a theme may additionally
define `styles` (`title`, `heading`, `body`, `code`, `card`), bounded
`namedStyles` targeting `text`/`code`/`card`, and `variants` with role styles
and **up to 32 absolute slots** per variant on the existing 1280×720 canvas.
Select a variant on a top-level source heading (`bento-variant`) and a slot on
an identified top-level QMD div (`bento-slot`). The optional `defaultVariant`
applies where no variant is declared. A row/column slot accepts 1–6 identified
direct children; a named slot style must match their actual element targets.
This is **not** a recursive layout language or an automatic source-template
mechanism. Slots are **layout opportunities, not content requirements**: omit
unnecessary optional task, takeaway or card slots rather than filling them
with decorative text; select a different supported variant if a required role
does not fit the teaching stage. Named styles for `code` affect code
typography/color, **not** code panel fill; use an authored `.bento-card` or
supported native backing shape for that decoration.

```qmd
## Explanation {#explanation bento-variant="teaching"}

::: {#instruction bento-slot="task"}
Interpret the result before continuing.
:::
```

To share design **without sharing content or `docId`**, use a local validated
`qbento/design` **version-1 package**. Only on app 0.2: inspect it with
`qbento design inspect package.json`, then initialize a **fresh** QMD *before*
its first render via `qbento design init deck.qmd package.json`. On an existing
bound presentation, use checked `design preview` → reviewed `design apply`, or
Studio's supported **Diseños y temas** workflow. Never replace `.qbento/`,
skip a recovery marker or edit internal `state.json` to apply a theme. The
registry can be exported/reused, but has **no content, arbitrary CSS, scripts,
remote fonts or computation**.

**Precedence:** explicit sourced QMD fields own their properties; theme/variant/
slot values are regenerated defaults; compatible native visual overrides retain
their independent ownership. Theme changes do not necessarily recolor or move
old literal/native overrides. Reapply the layout or inspect sparse overrides;
parent-coupled adjustments may refuse `UNMAPPED_DESIGN`.

For candidate syntax see the application's local
`docs/features/THEME_SLOTS.md`, `docs/DESIGN_PACKAGES.md` and
`docs/DESIGN_REGISTRY.md`. The [pinned 0.1.1 registry
contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/DESIGN_REGISTRY.md)
**does not** contain the 0.2-only vocabulary.

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

## Computed Code and Output Layout (App 0.2.0 Candidate)

Use these **literal options on the original executable chunk**, not on a
non-executing `{#id .r}` display fence. A displayed example does not run R;
turning it into `{r}` changes its provenance and execution permission.

````qmd
```{r}
#| label: full-output
#| echo: true
#| output-location: column
#| bento-code-width: 40
#| bento-overflow: scroll
#| bento-overflow-height: 220
cat(sprintf("ROW%03d", seq_len(120)), sep = "\n")
```
````

- `output-location: default` preserves the source/result order; `column`
  arranges echoed source left and results right with a 24px gap. Source width
  `bento-code-width` is a percentage **10–90** (default 50). `slide` creates
  a derived result slide associated with its source chunk; it does **not**
  authorize a new QMD heading and refuses inside card/layout components.
- `layout-ncol: 1–6` distributes **multiple computed results**, not the
  echoed source. Multiple tables from one producer remain subject to identity
  limits. Keep independent R model decisions close to their explanation.
- `bento-overflow: scroll` is opt-in for **computed** echoed code, stdout and
  supported tables; `bento-overflow-height` is a literal **80–600 px** (default
  240). Scrolling retains full native content, not a truncated snapshot. In
  combined PDF, complete output appears in **labeled continuation pages**
  after the corresponding native slides. Verify final lines/rows and page
  extraction before declaring a PDF complete. This is not a general scrolling
  option for arbitrary authored HTML or unsized native card text.
- Ordinary compatible R 2D static figures default to **SVG** only when no
  explicit `dev`, `fig-format`, project or producer choice already controls
  the output. Generated computed charts/tables keep their source data/producer
  authority while compatible native layout/style remains saved.

The parser refuses unsupported, repeated, indirect or out-of-range options
**before** running the producer. Do not silently shrink computed metrics,
drop table rows or turn computed output into authored text to obtain a pass.

## Inline 2D/3D Plotly and Widget Imports (App 0.2.0 Candidate)

Supported inline offline interaction is restricted to Plotly **2D scatter/bar**
and **3D scatter3d points/lines**. Studio, standalone HTML and Presenter host
the widget in its native image rectangle; the static fallback is **SVG for 2D**
and **PNG for 3D**, including print/PDF and unavailable WebGL. Enable input
using **Interactuar**; **Escape / Volver al diseño** restores native editing.
Exploration does not change source R, data or saved native geometry.

For 3D, **Save view** is a separate, explicit authorization to persist the
*current camera* and refresh its PNG fallback. Unapproved rotation/zoom is
transient. Studio checks saved source/revision/static-image identity before
saving camera visual state, which stays **outside QMD** and BentoDoc's general
property grammar. After a standalone HTML Save, import the matching generation
via checked `qbento capture` rather than manually editing state or trusting
embedded pixels as an execution receipt. Recalculation can keep approved
camera/geometry while recomputing source data; verify both.

To import a preexisting **local R Plotly htmlwidget as inert data** rather than
execute or embed its scripts:

```qmd
## Result {#result}

::: {#local-widget widget-src="figures/plot.html"}
:::
```

`widget-src` must refer to a project-relative **regular** `.html`/`.htm`
file, valid UTF-8, ≤16 MiB, with no symlink/hardlink/path traversal. The
reader requires one supported identified Plotly htmlwidget payload and a
matching container. Its byte hash and source wrapper bind the import;
changed input requires recomputation. The restricted adapter imports **data**,
not arbitrary HTML execution, callbacks or proof that an R producer ran.
Network access is blocked inside the offline widget sandbox, but a QMD's
own executable chunks still require normal execution review.

## Computation, Integration and Output

R, Python and other engines require the actual document's runtime/dependencies; a prose-only QMD need not require R. Preserve the code/inputs, figure labels and provenance. A `.bento-kpi` computed value, figure image or generated table must update through execution. Performance guidance can come from `quarto-computation-performance` when available, but do not externalize analyses or change code organization simply because Bento is used.

Only use ordinary `quarto render` integration **after** a deliberate `qbento init deck.qmd` installation. Its custom format is `qbento-html`, with product-supplied hooks/filters. `init` refuses replacing existing project configuration; `init ... --extension-only` leaves integration choices to the user. Do not rewrite an existing `_quarto.yml` or remove hooks as a shortcut.

- **Editable handoff:** preserve the QMD, inputs/assets, project binding and `.qbento/` state/design. Generated `.bento.html` is a static offline presentation, not a substitute for saved state; native HTML edits require the matching Save/capture workflow.
- **PDF/print:** use Bento's supported browser print/PDF representation; hidden slides are omitted. Do not invent `qbento pdf`/`export` or claim untested print dialogs.
- **Plotly by version:** app `0.1.1` has a separate **Presentar con gráficos**
  interactive viewer and static SVG in ordinary output; the isolated 0.2.0
  candidate embeds a bounded inline 2D/3D viewer in Studio/HTML/Presenter
  with SVG/PNG fallback. Neither establishes universal browser/platform fit.
- **Rich tables:** supported `gt`/`gtsummary` need Chromium for faithful 2× PNGs and may refuse oversized output; adjust producer/layout instead of dropping rows or silently shrinking. Report the output actually generated and verified.

## Pinned Product Sources

The links below describe **published 0.1.1**. App `0.2.0` is currently a
**dirty local source candidate**, not a published immutable pin; its relevant
local files are `docs/AUTHORING.md`, `docs/EXECUTION_LAYOUT.md`,
`docs/features/THEME_SLOTS.md` and
`docs/evidence/COMPOSITION-INTERACTIVITY-0.2.0.md`. Do not cite HEAD `b52772e`
as if it captured the uncommitted 0.2 changes. Replace provisional product
provenance with an immutable app tag/commit after its release and recheck the
contracts then.

- [Implemented authoring subsets and target-only cautions](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AUTHORING.md)
- [Canonical examples](https://github.com/brianmsm/quarto-bento/tree/1b7e265bda07c060215051302f252a7289f4a1f9/examples)
- [Usage, publication and composition limits](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/USAGE.md)
- [Public design-registry schema](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/DESIGN_REGISTRY.md)
