# State, Synchronization and Recovery

**Reference baseline:** Quarto-Bento CLI `0.1.0`, Linux; product commit `a1b8025f522a5c4c70d10e613f9a7923dc6f761c`, reviewed 2026-10-17. Commands below are product operations, not agent-specific tools. Consult the installed help when versions differ; preserve work rather than guessing state-file formats.

**Contents:** environment; operation effects; safe plans; Studio; capture; refusals/recovery; verification.

## Environment Without Hidden Dependencies

Prefer a user's existing `qbento`; inspect `--version`, `help`, and `doctor`. npm package `@brianmsm/quarto-bento@0.1.0` provides a Node launcher for bundled application source, executed by **external Deno**; **Quarto** and computation packages are also external. Node >=22 is declared. R is needed only when the source uses it; Chromium supports browser review, text measurement and certain rich-table/Plotly/PDF workflows. No automatic environment management is part of this plugin.

If installation is actually requested, follow the product's pinned npm guide rather than assuming the CLI is missing because it is not in one shell's `PATH`. A source checkout can run `deno task qbento` **from its root** with an absolute presentation path. Do not run a task named `qbento` in an arbitrary presentation folder. Source `src/cli.ts` has `help`/`doctor`; do not assume the npm launcher's `--version` switch exists in that source entrypoint.

## Operation Effects

| Operation | What it does / may execute |
| --- | --- |
| `status`, `diff`, `get` | Inspect an existing saved baseline; no new computation or HTML capture |
| `patch` | Write checked saved state and pending edits; no QMD write and no Quarto execution |
| `sync` | Build an inspectable source plan; no QMD write or model execution |
| `sync --apply plan.json` | Apply the **exact reviewed plan** to QMD with identity/source/state checks; not a render |
| `render` | Execute Quarto and publish combined generated content + retained design; may refuse pending conflicts |
| `reconcile` | **Execute QMD** to compare current source results and saved state, then return a plan |
| `reconcile --apply resolution.json` | **Re-execute QMD** to verify the reviewed plan, then apply its offered decisions to saved state; needs execution authorization, does not write QMD or replace reviewed source synchronization |
| `edit` | Run a local persistent Studio server; render first **only when there is no baseline** |
| `capture [edited.html]` | Import a matching publication-generation native HTML edit into saved state; no general HTML import |
| `recover ... inspect` | Inspect supported interrupted render/sync transaction evidence |
| `recover ... finish/rollback` | Mutating recovery, only when offered and authorized |
| `init [--extension-only]` | Install offline Quarto extension/configuration; not document creation |
| `quarto-recover` | Specific interrupted ordinary Quarto integration recovery; not a generic reset |
| `validate deck.bento.html` | Validate native document envelope and IDs; not visual correctness |

**Neither reconciliation phase is a non-executing substitute for `status`.** A user prohibition on execution includes initial `edit`, `render`, `reconcile` preview **and `reconcile --apply`**, even with an existing resolution file. Source preservation and execution permission are separate: `sourceUnchanged: true` does not mean that no calculations or producer side effects occurred. Malformed/stale requests may be rejected before execution; do not depend on such a rejection to satisfy a no-execution constraint. Do not invent passthroughs such as `qbento render --no-execute`, `--cache-refresh`, or `--force`; check actual CLI arguments and engine behavior first.

## Preview, Review, Apply

```sh
qbento status deck.qmd
qbento get deck.qmd > snapshot.json
qbento sync deck.qmd > plan.json
# Check successful exit and read the exact proposed fragments before applying.
qbento sync deck.qmd --apply plan.json
# Recompute only within the user's execution authorization.
qbento render deck.qmd
```

These are **decision-separated steps**, not a command chain to run blindly. Plan review checks source identity/hash, state revision, changed spans, new source identities, annotations, deletions, conflicts and whether the result stays within the request. Applying a plan file without reading it is not review. Do not manufacture/edit its hashes, approval lists or expected fragments to make it pass.

Approval to implement a specific edit can authorize its reviewed sync and requested render; it does not require asking the same question at every step. New content decisions, conflicting values, source deletion, detachment and changes outside the authorized scope need clarification. `slide.hide` is reversible visibility, not source deletion permission. Annotations or identity patches may be necessary, including weak bindings outside the edited paragraph; inspect their scope rather than assuming they are cosmetic.

**Do not run a sync/apply merely to update data-backed results or retain visual overrides.** A plan can contain optional `.qbento-design` annotations even when `pending` is empty. These are still source edits; `changes` in a valid plan are not automatically necessary or authorized. A request to preserve QMD means its bytes stay unchanged (including IDs, whitespace and annotations), unless the user separately approves source edits. Normally update the authorized data, inspect pending state and use `render`; the retained sidecar design does not require first applying an annotation-only plan. Verify the source hash/diff afterwards. If a real conflict prevents this, stop and explain rather than widening the operation silently.

A plan may cover several pending items. Do not automatically apply unrelated edits because they appear in the same file; use supported selective review in Studio or seek authorization. Do not assume a CLI `--select` flag exists. Preserve pending work not applied by this task. After a successful source sync, render only if allowed; otherwise explicitly leave the output stale and report what is saved versus generated.

## Studio and Browser Work

`qbento edit deck.qmd` prints a `127.0.0.1` URL and keeps a server alive. Track that process using the available terminal manager; do not launch duplicate servers because a tool read timed out. **Guardar proyecto** saves design/pending edits to `.qbento/`; Bento's native **Save** downloads an HTML copy instead. Other labels: **Revisar cambios** previews; **Aplicar** writes reviewed QMD; **Recalcular** executes; **Comparar con QMD** executes a comparison; **Guardar decisiones** applies reconciliation decisions to saved state and re-executes QMD for plan validation; it does not write source text.

Use the browser for controls not exposed by the JSON API: supported card/KPI creation, source-aware layouts, diagram **Relaciones**, or visual checks. All members of a managed component's pending creation belong together; geometry alone does not establish membership. An absent browser tool is not permission to forge Studio HTTP payloads or internal `.qbento/` data. Explain unsupported tasks or author appropriate QMD within scope instead.

The documented `.qbento/design.json` registry is a user-facing design configuration with its own schema. Editing it, when explicitly requested, is different from rewriting internal `project.json`/`state.json`/journals; preserve revision/recovery rules and confirm referenced layouts.

## Native HTML Capture and Rebuild

Preserve a local HTML file edited via native Save. Capture only a compatible copy from the **same project/document and emitted generation**:

```sh
qbento capture deck.qmd edited-copy.html
```

Capture checks publication receipt, identity and generation, and accepts one capture per publication generation. Re-render an accepted project before another native-copy editing cycle. A foreign, stale, receipt-less, encrypted or collaborative copy is not a general import source; never edit its receipt or the project's `docId` to match.

For reconstruction, retain QMD, input data/assets and required `.qbento/` project/state/design resources. Do not blanket-ignore or delete `.qbento/` as cache. A rebuilt base deck with missing retained design is not recovery of the old appearance.

## Refusals and Safe Recovery

Inspect both the JSON `error` and `message`; some CLI paths report a generic `QBENTO_ERROR` with a more specific message prefix.

| Evidence | Response |
| --- | --- |
| `STALE_REVISION` or project busy | Wait only for an identified live operation; reread, inspect intervening changes, and rebuild the remaining authorized intent. Persistent failure without progress: stop and report. |
| `STALE_SOURCE` on creation | Source and last execution differ. Review pending changes; authorized recalculation may refresh the baseline. Do not discard changes or run expensive/no-execute source without permission. |
| `UNRELATED_DOCUMENT`, conflicting `docId` | Confirm actual QMD association. Preserve both projects; never override identity to reuse another deck's state. |
| `UNCAPTURED_HTML_EDITS` | Preserve and capture the matching local copy before rendering. Never remove it simply to bypass the guard. |
| Computed-content conflict | Do not sync a rendered value into producer code. Inspect producer/input change options; restore or explicitly detach only when authorized. |
| `UNSUPPORTED_SYNC`, `UNMAPPED_DESIGN`, ambiguous identity | Retain pending work. Use supported codecs/source ownership; request review rather than guessing a lossy conversion. |
| Interrupted transaction | `qbento recover deck.qmd inspect`; read available actions and evidence. Execute `finish`/`rollback` only for a supported, authorized choice. |
| `DESIGN_REGISTRY_RECOVERY_REQUIRED` | Separate registry journal: preserve versions/marker and consult its product recovery contract. Generic `recover` does not repair it. |
| `MISSING_DESIGN` | Restore the named retained resources from backup/Git, or explain unavailable appearance; no fabricated recovery. |

For source/Bento conflicts, `qbento reconcile deck.qmd` executes QMD to produce a plan. **`qbento reconcile deck.qmd --apply resolution.json` executes QMD again** to verify that the source results and decisions still match before committing saved state. The `--apply` input wraps the exact plan and `choices`; use only the per-item actions offered by the plan. A previous preview or a reviewed file does not authorize another execution by itself. If the user already authorized the resolution and its required executions, proceed within that scope without a redundant confirmation; otherwise clarify the missing execution permission before either phase. Choices can include `keep-source`, `keep-bento`, or `detach`, but are not universally available. Confirm what is being discarded or detached. Resolution changes saved state; writing chosen authored content to QMD still needs a fresh reviewed sync. A source change can invalidate an earlier plan.

## Verification Appropriate to the Request

Check the mutated target and compare stable `docId`, expected IDs, requested values, unrelated work and pending items. When execution is requested, verify regenerated data output **and** retained geometry/style, not just command exit status. `validate` checks structure only. Open the actual rendered HTML/Studio for visual layout or interaction claims; warnings such as `OVERFLOW`, `TEXT_OVERFLOW`, or `TEXT_MEASUREMENT_UNAVAILABLE` are not a substitute for the relevant check. Never claim PDF export, pixel identity, a GUI operation, or a computation happened without evidence.

## Pinned Product Sources

- [Usage, exact Studio labels and recovery cases](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/USAGE.md)
- [Ownership, sync and capture invariants](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/SYNC.md)
- [Reconciliation contract](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/src/core/reconcile.ts)
- [Linux npm installation and immutable package snapshot caveats](https://github.com/brianmsm/quarto-bento/blob/a1b8025f522a5c4c70d10e613f9a7923dc6f761c/docs/NPM.md)
