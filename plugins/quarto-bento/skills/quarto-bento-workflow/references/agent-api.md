# Checked JSON Operations

**Reference baseline:** Quarto-Bento CLI `0.1.0`; agent protocol `version: 1`; Bento contract revision `3d6f7f1fcdf2308e875345ce4f1e0ec0820c914b` (Bento 1.2.6). Reviewed 2026-10-17 against product commit `a1b8025f522a5c4c70d10e613f9a7923dc6f761c`. This is a local operational summary, not a replacement schema. For another version, inspect its own contract before writing.

**Contents:** snapshot and identity; patch envelope; operation limits; supported slide creation; result/error handling.

## Snapshot Before Mutation

```sh
qbento get deck.qmd > snapshot.json
```

Check the exit code before treating stdout as a snapshot. A successful snapshot contains `version`, `contractRevision`, `docId`, `revision`, `deck`, `provenance`, `ownership` and `pending`. It reflects **saved** state, not a fresh calculation or uncaptured browser/HTML edits. Render a new, trusted project once with authorization before calling `get`; another QMD beside an already bound `.qbento/` is not a new editable deck.

Select the requested slide/element by inspecting the snapshot. Existing element IDs are **slide-scoped**; use the returned ID verbatim, including slashes. `provenance` and `ownership` use JSON-encoded `[slideId, elementId]` keys (`null` for the slide level). These distinguish authored, computed, Bento-only and detached content, and field ownership. Do not infer editable authorship just from `type: "text"`.

## Patch Envelope

A request is a **regular UTF-8 JSON file**, not a symlink, no larger than 1 MiB including whitespace. Use a JSON serializer available in the environment. Top-level fields are exactly `version`, `docId`, `expectedRevision`, `operations`.

Illustrative shape only; replace the identity, revision and IDs with the latest snapshot, and limit fields to the actual request:

```json
{
  "version": 1,
  "docId": "COPY_FROM_GET",
  "expectedRevision": 1,
  "operations": [
    {
      "op": "element.patch",
      "slideId": "results",
      "elementId": "finding/paragraph:1",
      "fields": { "x": 120, "w": 620 }
    }
  ]
}
```

```sh
qbento patch deck.qmd patch.json
```

Never submit the illustrative ID/revision without observing them. Do not infer the next revision by arithmetic: a changed batch increments once; a no-op keeps its revision. Ordinary operations are applied sequentially to an in-memory copy and committed once only if **every** step is valid. A later invalid operation must not be described as a partial successful patch.

## Supported Operations and Properties

| `op` | Required properties besides `op` | Purpose |
| --- | --- | --- |
| `element.patch` | `slideId`, `elementId`, nonempty `fields` | Modify permitted properties of one existing native object |
| `slide.patch` | `slideId`, nonempty `fields` | Modify slide properties |
| `slide.move` | `slideId`, `afterId` | Move after an existing slide; `null` means first, not last |
| `slide.create` | `slideId`, `afterId`, `slide` | Create one bounded native slide with authored text and optional shapes |
| `slide.hide`, `slide.show` | `slideId` | Reversibly hide/show without deleting source |

Normally a batch has **1–100 operations**. `slide.hide` and `slide.show` must each be the **sole operation in their request**; follow with a fresh revision for any later edits. There is no generic element creation, deletion, source-code execution, or arbitrary JSON-pointer operation in this API version.

Element fields accepted by the operation boundary:

```text
x y w h rotation opacity
fontSize fontFamily fontWeight color align valign lineHeight letterSpacing
fill stroke strokeWidth strokeStyle strokeDash radius
html content src markup rows columns header option
```

Slide fields: `background name notes transition unnumbered`.

The native **element type's schema still applies**. A listed field is not valid on every type; `src` on text, negative widths, string coordinates, unknown enums and prototype keys are rejected. Nested properties cannot be patched through dotted names; supported arrays/data are replaced as whole validated values. `null` is not a delete instruction. Do not use a field absent from this API merely because Studio can edit it (for example, displayed-code language selection has a Studio workflow).

For a simple authored paragraph, its native text is `html`; bounded emphasis/links must remain within the source codec. Editing `html` on **computed** output does not change its producer and creates a conflict, not a valid shortcut to changing results. Visual-only property changes may also become pending source changes when QMD explicitly owns those properties.

## Creating a Slide Is a Bounded Workflow

Use QMD for arbitrary semantic content; use `slide.create` only within its subset:

- The native `slide.id` must equal `slideId`. The slide contains **1–50 elements**; at least one is text. The first text element supplies the heading; later text elements supply paragraphs or supported lists. Decorative shapes remain visual state.
- A minimal text element needs native fields such as `id`, `type: "text"`, `html`, `x`, `y`, `w`, `h`; optional styling must pass the installed schema. Use a simple one-line heading; do not set separate `slide.title` text.
- New native IDs begin with an ASCII letter, followed only by letters, digits, `_`, `:`, `.` or `-`, at most 200 characters. Choose fresh IDs against source, saved deck, generated baseline and pending creations. Visual hiding does not release an identity.
- `afterId: null` inserts first. Use an observed final slide ID to append. The target can be a slide created earlier in the same batch.
- Images, tables, charts, display equations, executable producers and declared provenance metadata are **not supported creation payloads**. Author those through QMD or use an implemented Studio workflow. Do not invent `type: "card"`/`"kpi"` from QMD component classes.
- Creation needs a source-backed execution baseline matching the entire current QMD. `STALE_SOURCE` requires inspecting pending work and obtaining permission for recalculation, not editing hashes. Plain nonempty speaker notes are supported subject to source mapping; no inferred executable notes.

A newly created slide first becomes a durable pending `create-slide` change, not source text. Its QMD heading and body containers appear only through an inspected, applied sync plan; geometry and decoration remain retained separately.

## Interpreting Responses and Stopping Safely

`get`/`patch` success exits 0 with JSON on stdout. A patch returns the snapshot envelope plus `sourceUnchanged: true`, `renderNeeded: true`. Verify the requested properties in the result or a subsequent `get`; preserve pending changes outside the task.

Failures exit 1 with JSON on stderr (`error`, `message`, optional `details`). The source-checkout task wrapper can add runner text; do not confuse that with application JSON. Some commands expose a generic `QBENTO_ERROR` with the specific condition in `message`, so inspect both.

- `STALE_REVISION`: reread, verify the target and intervening edits, then rebuild only the still-authorized intent. Never just replace the revision in an old payload.
- `UNRELATED_DOCUMENT`: stop; confirm the correct QMD/project. Never substitute another `docId` or reset its sidecar.
- `AGENT_UNKNOWN_OPERATION`, `AGENT_UNKNOWN_FIELD`, `AGENT_INVALID_TARGET`, `AGENT_UNSUPPORTED_CREATION`: narrow to supported operations or switch surface; do not work around validation by editing internal state.
- `AGENT_INPUT_TOO_LARGE`, `AGENT_INVALID_JSON`, `AGENT_INPUT_FILE`: fix the request file, not the project. Multiple smaller requests are separate transactions and each needs a current revision; do not split an operation that needs atomicity blindly.
- `UNCAPTURED_HTML_EDITS`, `STALE_SOURCE`, `UNSUPPORTED_SYNC` and recovery diagnostics: preserve work and follow the synchronization reference. Persistent busy/stale responses require investigation, not an unbounded retry loop.

## Pinned Product Sources

- [Agent API, operations, limits and error contract](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/AGENT-API.md)
- [Native API implementation](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/src/core/agent.ts)
- [Exact command dispatch and JSON failure handling](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/src/cli.ts)
