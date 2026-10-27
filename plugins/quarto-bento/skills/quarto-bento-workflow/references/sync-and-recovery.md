# State, Synchronization and Recovery

**Version scope:** published Linux app `0.1.1` remains the pinned source for
ordinary sync/recovery. The installed **isolated, unpublished 0.2.0 tarball**
passed focused Linux synthetic checks for design initialization, output,
widget import and native state; additional 0.2 Studio/print behavior is grounded
in the product's local test evidence, **not** a clean published source release.
Commands are product operations, not agent tools. Confirm the actual CLI/help
before using version-specific syntax; do not guess internal state formats.

**Contents:** environment; operation effects; selected sync and post-Apply; Studio; capture; identity/recovery; diagnostics and verification.

## Environment Without Hidden Dependencies

Use the intended **exact CLI** and confirm its version with `--version` and
`doctor`; a separate candidate installed under an npm prefix must be invoked
through its absolute launcher, **not** by replacing PATH/mise globally. The
published `0.1.1` app and unpublished `0.2.0` candidate both keep Quarto/R,
Deno and Chromium as external runtimes; this agent plugin installs none of them.
Use approved source execution only; an installed CLI does not grant render
permission.

For installation, consult the [pinned npm guide](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/NPM.md). If the user deliberately selects a source checkout, run its documented `deno task qbento` from that checkout against an absolute QMD path. Keep the chosen binary/version stable within a task; do not assume mise or any developer checkout is present. App `0.1.1`, JSON protocol v1 and the **agent plugin version in its own manifest** are independent.

## Operation Effects

| Operation | What it does / may execute |
| --- | --- |
| `status`, `diff`, `get` | Inspect an existing saved baseline; no new computation or HTML capture |
| `patch` | Write checked saved state and pending edits; no QMD write and no Quarto execution |
| `sync` / `sync --select selection.json` | Preview all changes or a reviewed selected subset (`0.1.1`); inspectable QMD plan, **no source write or Quarto execution** |
| `sync --apply plan.json` | Apply the **exact reviewed plan** to QMD with identity/source/state checks; no Quarto execution; semantic pending/approval may remain until render |
| `render` | Execute Quarto and publish combined generated content + retained design; may refuse pending conflicts |
| `reconcile` | **Execute QMD** to compare current source results and saved state, then return a plan |
| `reconcile --apply resolution.json` | **Re-execute QMD** to verify the reviewed plan, then apply its offered decisions to saved state; needs execution authorization, does not write QMD or replace reviewed source synchronization |
| `edit` | Run a local persistent Studio server; render first **only when there is no baseline** |
| `capture [edited.html]` | Import a matching publication-generation native HTML edit into saved state; no general HTML import |
| `recover ... inspect` | Inspect supported interrupted render/sync transaction evidence |
| `recover ... finish/rollback` | Mutating recovery, only when offered and authorized |
| `design inspect/init/export/preview/apply` (**app 0.2 only**) | Inspect/export reusable themes, initialize a truly new QMD with a local package or preview/apply a reviewed design update; **init/apply mutate registry**, not QMD computed data |
| **Studio Save view** (**app 0.2**) | Persist a reviewed Plotly3D camera and refresh static PNG; visual state/capture, **not** a QMD source patch or execution receipt |
| `init [--extension-only]` | Install offline Quarto extension/configuration; not document creation |
| `quarto-recover` | Specific interrupted ordinary Quarto integration recovery; not a generic reset |
| `validate deck.bento.html` | Validate native document envelope and IDs; not visual correctness |

**Both** `reconcile` preview and `reconcile --apply` may execute QMD. A no-execution request prohibits either phase, `render`, and first `edit` when it would initialize by rendering. `sourceUnchanged: true` does **not** mean no computation or side effects occurred. Do not rely on early error rejection as an execution guard or invent flags such as `--no-execute`, `--cache-refresh`, or `--force`.

## Browser Render Handoff in Restricted Agent Environments

In a known browser-incompatible agent sandbox, **Quarto/R can run before Chromium fails**. Do not trial-render there merely to diagnose browser IPC; inspect QMD, native state and permissions with nonexecuting commands instead. Preserve any partial computation if an earlier attempt already failed.

For trusted, reviewed source, **execution permission** and permission to cross the **sandbox trust boundary** are distinct. When the user has not already authorized that specific external environment and source, obtain explicit approval before elevation or handoff; a general edit request is insufficient. Where a host supports one-command elevation (e.g. Codex shell tool `sandbox_permissions: "require_escalated"`), use its actual approved tool mechanism, never an invented `qbento` flag. `--approve-for-me` does not elevate Bash automatically. A denial is binding: no global sandbox weakening, reusable command allowlist, unsafe Chromium flags or unauthorized retry.

When elevation is unavailable, hand off instead of executing inside the broken sandbox:

1. **Agent preflight (no QMD execution):** review source, code/hooks, inputs, binding, `docId`/revision, pending native work, hashes and any execution counter. For a genuinely new project, do not require a nonexistent pre-render `get`/`docId`; first apply the [NO_BASELINE recovery check](#bound-project-identity-before-recovery).
2. **Trusted local operator:** independently check the whole QMD and saved HTML-visible content against the approved publication scope. Recheck hashes/state/counter, then execute only the exact, authorized `qbento render <deck.qmd>` **once** in the approved environment. Existing permission covering the exact source and external host need not be solicited repeatedly. For untrusted QMD/unattended production, use an isolated render worker.
3. **Independent postflight:** verify executed source, saved and HTML `docId`, retained edits, published/computed values, state/inputs and counter. Report denied/aborted or failed renders as **pending/incomplete**, not a completed publication.

Source-only and explicitly no-execution tasks do not need a render handoff; it is an optional authorized execution path, **not** a plugin API or dependency.

## Preview, Review, Apply

Decide independently whether the task requires **inspection**, **source Apply**, or **execution**. These are not an unconditional command chain.

**Inspect (no QMD execution):**

```sh
qbento status deck.qmd
qbento get deck.qmd > snapshot.json
qbento sync deck.qmd > plan.json
```

Use only applicable commands: `get` requires an existing saved baseline, and `sync` is unnecessary for design-only or data-only work. Check each exit status. Before applying a plan, inspect its **complete proposed QMD**, selected/excluded IDs, source spans, identities, annotations, deletions and diagnostics. The [agent API reference](agent-api.md#selectively-synchronize-authored-changes-011) owns request/schema and exact source-scope rules; do not edit the plan or its hashes to make it fit. Source-only approval need not authorize unrelated annotations.

**Apply to QMD (only after plan/source-scope review):**

```sh
qbento sync deck.qmd --apply plan.json
```

**Render (separate optional step requiring QMD execution and HTML publication scope):**

```sh
qbento render deck.qmd
```

A requested edit may already authorize its reviewed Apply and render **within the approved trust boundary**; do not ask redundantly. Conflicting content, deletion/detachment or a new external execution environment requires new permission. Never render solely to persist design or apply optional annotations. A data-only task normally changes authorized inputs and renders only if execution is allowed; preserve QMD bytes, pending work and native overrides. If a real conflict prevents it, stop rather than silently widening scope.

## Select Only Authorized Pending Changes (`0.1.1`)

Use exact `pending[].id` values from a **successful** `qbento get`, not slide/element IDs. For the `selection.json` fields, complete preview and `sync --select`/Apply commands, see [agent-api.md](agent-api.md#selectively-synchronize-authored-changes-011); do not duplicate the request schema here.

The resulting plan may include **necessary technical identities** and separately optional `.qbento-design` annotations. Inspect every proposed source patch before Apply; an out-of-scope optional patch means defer Apply or seek approval, **not** alter a signed plan or change frontmatter to suppress it. A selection does not imply HTML publication permission. In Studio **Revisar cambios**, changing the default all-selected set invalidates the previous preview; obtain a fresh plan and confirm deletions separately. Creation groups are atomic.

**Version distinction:** application `0.1.0` lacks the selected-sync contract;
app `0.1.1` provides it, and the candidate `0.2.0` retains bounded checked sync.
Neither is the independently versioned **agent plugin**. Detect the installed
app instead of inferring its commands from a plugin tag.

## Source Selection Is Not an HTML Publication Filter

`qbento sync --select` limits **QMD writes**, not the saved native content included in `qbento render`. An excluded authored `pending[].id` may remain absent from synchronized **QMD** while its changed text is still visible in published **HTML**. This is retained-state behavior, not incorrect selection.

**Before authorizing HTML publication:** compare the **entire** `qbento get` saved deck and all pending authored values with QMD and the user-approved visible/forbidden content. If saved text is forbidden in output, **STOP before render** without deleting pending work. If visibility is unclear, clarify the publication scope; if explicitly accepted, a reviewed sync and separately authorized render may proceed. The operator repeats this review against the final saved deck before the one-shot execution and checks the delivered HTML afterwards.

`slide.hide` is not a privacy filter: HTML may retain hidden content. In app
0.2, **scrollable complete-output continuations** and offline widget data also
belong to the publication-scope review; a clipped viewport is not evidence
that excluded content stays unpublished. Never rewrite the master HTML,
change internal state, discard drafts or invent selective publication. A
separate sanitized project requires explicit review/authorization.

## Successful Apply May Leave Pending Work

A successful Apply updates **QMD**, not the last executed native projection. Verify `appliedChangeIds`, `pendingRetained: true`, `renderNeeded: true`, and the transaction/backup receipt; selected semantic pending can remain until render, and **excluded** pending may remain after it. **"QMD updated; render pending"** is a valid outcome.

Two normal app 0.1.1 paths differ:

- **With `sync-approved.json`:** structural identity/creation/deletion/normalization Apply can retain an approval marker. Another Apply may yield `APPROVAL_PENDING`; reconciliation `SYNC_APPROVAL_PENDING`; preview `RECOVERY_OR_BUSY` naming the marker.
- **Without a marker:** a text-only Apply with stable identities can leave pending work and no marker. A new sync preview can yield `SOURCE_CONFLICT` because the executed baseline predates the successful QMD write.

Use the original successful receipt (`appliedChangeIds`, `sourceHash`, `receiptPath` when present), current QMD, native pending and any intervening **independent source/state changes** to distinguish expected baseline lag from a real conflict. A `SOURCE_CONFLICT` is never automatically harmless. If only expected lag remains, execute **one approved render** and verify saved HTML/state; otherwise preserve the receipt and stop. Never rerun Apply, clear the marker or start recovery merely because a completed Apply awaits rendering.

## Studio and Browser Work

`qbento edit deck.qmd` prints a `127.0.0.1` URL and keeps a server alive. Track that process using the available terminal manager; do not launch duplicate servers because a tool read timed out. **Guardar proyecto** saves design/pending edits to `.qbento/`; Bento's native **Save** downloads an HTML copy instead. Other labels: **Revisar cambios** previews all or selected pending edits and invalidates prior previews when selection changes; **Aplicar** writes reviewed QMD; **Recalcular** executes; **Comparar con QMD** executes a comparison; **Guardar decisiones** applies reconciliation decisions to saved state and re-executes QMD for plan validation; it does not write source text.

Use the browser for controls not exposed by the JSON API: supported card/KPI creation, source-aware layouts, diagram **Relaciones**, or visual checks. All members of a managed component's pending creation belong together; geometry alone does not establish membership. An absent browser tool is not permission to forge Studio HTTP payloads or internal `.qbento/` data. Explain unsupported tasks or author appropriate QMD within scope instead.

The user-facing `.qbento/design.json` registry is separate from internal
`project.json`/`state.json`/journals. In app 0.2, prefer checked local design
packages and **Diseños y temas** (role styles, variants, slots) before applying
many one-off positional patches; new `design init` and existing `design
preview/apply` have distinct mutation scopes. Do not copy another project's
state or `docId` to reuse its theme. Preserve authored QMD selectors and
current saved overrides; verify the applied presentation, not just JSON syntax.

## Interactive Widgets, Scroll and PDF in App 0.2.0 Candidate

For supported **2D scatter/bar and 3D `scatter3d` points/lines**, use
**Interactuar** to interact with the actual inline widget in Studio/HTML/
Presenter and **Escape / Volver al diseño** to restore native editing. This
is temporary exploration, not a QMD change. In 3D **Save view** explicitly
persists the live camera and refreshes the static PNG; Studio checks project,
source, revision and current image identity. Verify through supported saved
state/reopening and the real PNG, **not** a fabricated `slide.patch` camera
field, a hand-edited HTML camera blob or a reversed update to R.

A standalone HTML view additionally needs **native Save** of the edited copy
and the normal *same-generation* checked `qbento capture` if it is to be
retained by the bound QMD project. Changing the camera does not authorize
publishing other pending native drafts. R computation and imported inert
htmlwidget data remain separate provenance paths; read-only import **does
not** execute the exported original htmlwidget script.

For computed source/code/stdout/table with `bento-overflow: scroll`, check
actual scrolling (including the last row) in the correct native rectangle.
The full computed payload must survive Save/reopen; interactive clipping is
**not** permission to truncate it. Combined Presenter PDF uses **labeled
continuation pages** after native slides, with static SVG/PNG widget fallbacks.
Before asserting print completeness, inspect actual PDF pages and last output
values; the product's 0.2 Linux evidence checked 14 pages with `ROW120` and
`CELL040`. PDF/print can still differ across browsers/platforms, and there
is no invented `qbento pdf` command.

A `widget-src` path is a checked local inert-data import, **not** an exemption
from QMD execution/publication safety, arbitrary HTML rendering or offline
network restrictions. Do not treat its scripts as producer receipts or allow
unsafe Chromium flags to manufacture a passing interaction.

## Native HTML Capture and Rebuild

Preserve a local HTML file edited via native Save. Capture only a compatible copy from the **same project/document and emitted generation**:

```sh
qbento capture deck.qmd edited-copy.html
```

Capture checks publication receipt, identity and generation, and accepts one
capture per publication generation. App 0.2 camera metadata in a native Save
copy is only a **request**: capture checks matching original static/widget
identity and recaptures the approved pixels locally; it is not trusted R
execution evidence. Re-render an accepted project before another native-copy
editing cycle. A foreign, stale, receipt-less, encrypted or collaborative copy is not a general import source; never edit its receipt or the project's `docId` to match.

For reconstruction, retain QMD, input data/assets and required `.qbento/` project/state/design resources. Do not blanket-ignore or delete `.qbento/` as cache. A rebuilt base deck with missing retained design is not recovery of the old appearance. **Generated master `deck.bento.html` is not the saved design database.** Never use Python/string replacement or a direct HTML edit to claim a retained position/style change; use supported `get`/`patch`/fresh `get` or a verified Studio project save instead. Copying and editing a **separate** HTML artifact is legitimate within its explicit scope, but it is not a persistent Bento design edit unless the supported matching-generation `capture` succeeds.

## Bound Project Identity Before Recovery

One `.qbento/` project binds to **one QMD**. App 0.1.1 verifies this for `status`, `diff`, `get` and Studio. On `PROJECT_SOURCE_MISMATCH`, locate the correct QMD; on `PROJECT_BINDING_MISSING`, restore **verified matching** metadata from backups/Git. Do not invent another `docId`, rebind a sibling deck or delete the sidecar to clear an error.

**Residual backup-only N01 in app 0.1.1:** `project.json` plus recoverable `state.previous.json` but no current `state.json`/HTML can return `NO_BASELINE`. An initial `edit`/render may then create a different `docId`, lose retained design/pending and overwrite the backup. Before treating a missing baseline as new, inspect `.qbento/project.json`, `state.json`, `state.previous.json`, `render-transaction.json`, `sync-transaction.json`, `sync-approved.json`, and relevant Git/backups. If anything recoverable exists, **preserve and stop**; plan supported recovery rather than bootstrapping, copying previous state blindly or changing IDs. Only an actually fresh project can receive an authorized first render. Source-only QMD edits need no rendering.

This differs from a successful Apply awaiting render, which still has a current baseline and receipt/pending state; do not invoke generic recovery for ordinary post-Apply lag.

## Refusals and Safe Recovery

Inspect both the JSON `error` and `message`; some CLI paths report a generic `QBENTO_ERROR` with a more specific message prefix.

| Evidence | Response |
| --- | --- |
| `STALE_REVISION` or project busy | Wait only for an identified live operation; reread, inspect intervening changes, and rebuild the remaining authorized intent. Persistent failure without progress: stop and report. |
| `STALE_SOURCE` on creation | Source and last execution differ. Review pending changes; authorized recalculation may refresh the baseline. Do not discard changes or run expensive/no-execute source without permission. |
| `UNRELATED_DOCUMENT`, conflicting `docId`, `PROJECT_SOURCE_MISMATCH` | Confirm the QMD/project association; preserve both. Do not relabel the sidecar, overwrite another deck's state or assume multiple QMDs per directory. |
| `PROJECT_BINDING_MISSING` | Restore verified metadata for the same QMD from backup/Git. Do not fabricate an association or replace saved state. |
| `NO_BASELINE` | Follow the [N01 recovery preflight](#bound-project-identity-before-recovery); preserve recoverable state rather than initialize. |
| `APPROVAL_PENDING`, `SYNC_APPROVAL_PENDING`, `RECOVERY_OR_BUSY` naming `sync-approved.json` | Check a successful Apply receipt/marker: authorized render may be the normal continuation. Do not repeat Apply or delete state files. |
| `SOURCE_CONFLICT` after Apply (including **without** `sync-approved.json`) | Compare successful receipt, QMD/resulting source, current pending state and external edits. An old executed baseline may explain the refusal; genuine divergence still requires review. Render only when that distinction is verified and execution authorized. |
| `INVALID_SELECTION`, `PARTIAL_DELETE_SELECTION` | Reread `get`, inspect selected/excluded pending IDs and coupled component/deletion dependencies; build a fresh selection. |
| `UNCAPTURED_HTML_EDITS` | Preserve and capture the matching local copy before rendering. Never remove it simply to bypass the guard. |
| Computed-content conflict | Do not sync a rendered value into producer code. Inspect producer/input change options; restore or explicitly detach only when authorized. |
| `UNSUPPORTED_SYNC`, `UNMAPPED_DESIGN`, ambiguous identity | Retain pending work. Use supported codecs/source ownership; request review rather than guessing a lossy conversion. |
| Interrupted transaction | `qbento recover deck.qmd inspect`; read available actions and evidence. Execute `finish`/`rollback` only for a supported, authorized choice. |
| `DESIGN_REGISTRY_RECOVERY_REQUIRED` | Separate registry journal: preserve versions/marker and consult its product recovery contract. Generic `recover` does not repair it. |
| `MISSING_DESIGN` | Restore the named retained resources from backup/Git, or explain unavailable appearance; no fabricated recovery. |

For source/Bento conflicts, **both** reconciliation phases execute QMD: preview computes current producer results, and Apply re-executes to verify the unchanged plan. An approved plan is not permission for a new execution; preserve the source and saved state if permission is absent.

A resolution file has `{ "plan": <unchanged preview JSON>, "choices": [{ "changeId": <observed change.id>, "action": <offered action> }] }`. Check offered actions against each `plan.changes[]` entry and use a JSON serializer for the reviewed choice. **Both** operations execute QMD and require execution permission; they are separate decisions, not an automatic sequence:

```sh
qbento reconcile /path/to/deck.qmd > reconcile-plan.json
```

After inspecting the plan and authorizing the actual offered decisions **and re-execution**:

```sh
qbento reconcile /path/to/deck.qmd --apply resolution.json
```

Use only offered actions, which can include `keep-source`, `keep-bento` or `detach` **when that item supports them**. Check the returned `resolved`, `remaining` and `renderNeeded`: a resolved choice can still require reviewed source sync or a later authorized render. `STALE_RECONCILE_STATE`, `STALE_RECONCILE_SOURCE` or `STALE_RECONCILE_PLAN` means fresh execution-authorized preview and re-evaluation of the choice, not changing hashes or force-applying the old file. Confirm newly destructive/detaching choices, but do not ask again if the user already authorized the exact decisions and their necessary executions.

## Distinguish Layout Diagnostics

- `OVERFLOW`: an **element box** extends past the slide bottom after retained design. Move/resize that box; this does not measure text clipping, rotation, horizontal edges or shadows.
- `TEXT_OVERFLOW`: text/list/KaTeX/displayed code **content** escapes its saved box, even if the box is entirely on-slide. Increase height/width or adjust typography; semantic shortening requires separately authorized source sync. Studio read-only diagnostics after Save can clear the warning **without re-executing QMD**; later render rechecks it.
- `TEXT_MEASUREMENT_UNAVAILABLE`: the text was **not reliably measured** (e.g. Chromium unavailable, rotated text). Do not call it a pass or pretend it is overflow; use an available local browser/visual inspection or report that measurement remains unverified, without changing global sandbox settings.
- `NATIVE_CONTENT_OVERFLOW`: measured table/chart content exceeds its saved
  frame; reapply a compatible layout and inspect full metrics. `NATIVE_CONTENT_UNMEASURED`:
  unknown native metrics require review, not an invented fit. For app 0.2,
  also treat `EXECUTION_LAYOUT`/invalid overflow options as pre-execution
  refusals: fix the original literal chunk options rather than suppress the
  error, dropping computed rows or re-running blindly.
- Component-specific `KPI_CONTENT_OVERFLOW`, `CARD_CONTENT_OVERFLOW`, `LAYOUT_OVERFLOW`, `GRAPH_CONTENT_OVERFLOW` and related errors can **refuse** unsupported compositions. Fix roles, frames, source content or layout geometry within supported limits; do not suppress diagnostics, scale away content or rewrite producer results.

## Verification Appropriate to the Request

Check the mutated target and compare stable `docId`, expected IDs, requested values, unrelated work and pending items. When execution is requested, verify regenerated data output **and** retained geometry/style, not just command exit status. `validate` checks structure only. Open the actual rendered HTML/Studio for visual layout or interaction claims; warnings such as `OVERFLOW`, `TEXT_OVERFLOW`, or `TEXT_MEASUREMENT_UNAVAILABLE` are not a substitute for the relevant check. Never claim PDF export, pixel identity, a GUI operation, or a computation happened without evidence.

## Pinned Product Sources

The sources below describe **published app 0.1.1**. The 0.2.0 addendum was
reviewed from the app's dirty local candidate and its exact review tarball:
`docs/USAGE.md`, `docs/EXECUTION_LAYOUT.md`,
`docs/features/THEME_SLOTS.md` and
`docs/evidence/COMPOSITION-INTERACTIVITY-0.2.0.md`. Replace these provisional
product descriptions with a release-tagged source contract after 0.2 closes;
the currently published 0.1.1 links are **not** proofs of inline 0.2 widgets.

- [Usage, exact Studio labels and recovery cases](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/USAGE.md)
- [Ownership, sync and capture invariants](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/SYNC.md)
- [Reconciliation contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/src/core/reconcile.ts)
- [Linux npm installation and immutable package snapshot caveats](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/NPM.md)

- [0.1.1 selective sync, post-Apply and binding contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AGENT-API.md)
- [0.1.1 npm publication and installed CLI evidence](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/evidence/SYNC-SELECTION-0.1.1.md)
