# State, Synchronization and Recovery

**Reference baseline:** installed Quarto-Bento CLI `0.1.1`, Linux; product commit `1b7e265bda07c060215051302f252a7289f4a1f9`, reviewed 2026-10-17. Commands below are product operations, not agent-specific tools. Consult the installed help when versions differ; preserve work rather than guessing state-file formats.

**Contents:** environment; operation effects; selected sync and post-Apply; Studio; capture; identity/recovery; diagnostics and verification.

## Environment Without Hidden Dependencies

Prefer a user's existing `qbento`; inspect `--version`, `help`, and `doctor`. npm package `@brianmsm/quarto-bento@0.1.1` provides a Node launcher for bundled application source, executed by **external Deno**; **Quarto** and computation packages are also external. Node >=22 is declared. R is needed only when the source uses it; Chromium supports browser review, text measurement and certain rich-table/Plotly/PDF workflows. No automatic environment management is part of this plugin.

If installation is requested, consult the pinned npm guide. On the verified host, the installed `qbento 0.1.1` through mise is already available; prefer that executable. A source checkout can run `deno task qbento` **from its own root** against an absolute QMD path, but do not silently switch executables or versions mid-task. Check the executable's actual help and availability before making version-specific claims. The app version (`0.1.1`), JSON API (`1`) and companion plugin version (`0.0.0`) are independent.

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
| `init [--extension-only]` | Install offline Quarto extension/configuration; not document creation |
| `quarto-recover` | Specific interrupted ordinary Quarto integration recovery; not a generic reset |
| `validate deck.bento.html` | Validate native document envelope and IDs; not visual correctness |

**Neither reconciliation phase is a non-executing substitute for `status`.** A user prohibition on execution includes initial `edit`, `render`, `reconcile` preview **and `reconcile --apply`**, even with an existing resolution file. Source preservation and execution permission are separate: `sourceUnchanged: true` does not mean that no calculations or producer side effects occurred. Malformed/stale requests may be rejected before execution; do not depend on such a rejection to satisfy a no-execution constraint. Do not invent passthroughs such as `qbento render --no-execute`, `--cache-refresh`, or `--force`; check actual CLI arguments and engine behavior first.

## Browser Render Handoff in Restricted Agent Environments

A restricted Codex/Linux `workspace-write` sandbox can prevent Chromium from starting even when outbound networking is enabled: local browser IPC may fail with `Operation not permitted` before `DevToolsActivePort` appears. **A `qbento render` executes Quarto/R before Chromium capture.** If this failure mode is already known for the current runtime and the task needs browser-dependent publication, **do not invoke render as a diagnostic trial**; that can execute the producer, leave the saved/published result stale, and tempt an unsafe second execution. Checking `qbento get`, project binding, QMD source and pending work does **not** execute code.

For inspected, trusted QMD, distinguish **permission to execute the source** from **permission to execute it outside the agent sandbox**. A capable host may grant a single native command escalation (`sandbox_permissions: "require_escalated"` with a justification in Codex's shell **tool call**, not a CLI flag). `--approve-for-me` changes who reviews requests; it does **not** elevate a regular `qbento render` automatically. The agent saying "I will ask" is not approval evidence. Never add a reusable `prefix_rule`, globally weaken the sandbox, disable Chromium's security, or grant broad network access to fix a local IPC restriction. A denial is binding.

When native elevation cannot be demonstrated, a **separately authorized external operator** is the supported fallback; this is a handoff, not an undocumented `qbento` API feature:

1. **Agent preflight (non-executing):** inspect the QMD and its computation/Quarto hooks, input files, successful `get`, `docId`, current revision, pending changes, source/input digests and execution counter when present. State exactly which source and command need approval. Leave the project intact; do not try to render/reconcile inside the known-broken sandbox.
2. **Trusted operator:** independently inspect the code and approve executing the **whole QMD**, not just Chromium. Recheck source/input hashes, binding, pending/approval state, the full saved deck's **HTML-visible content against the approved publication scope**, and previous execution counter immediately before invoking the exact `qbento render <deck.qmd>` **once** in an appropriately authorized environment where Chromium works. Do not use a broad command allowlist or automatically repeat a failed render. For untrusted QMD or unattended production, use a separately isolated render worker rather than unconstrained host execution.
3. **Independent verification:** after successful external execution, use non-executing `qbento get` and inspect the actual output. Verify the original `docId`, revision/retained design, still-pending foreign work, authorized QMD/input bytes, computed values in **both saved state and delivered HTML**, and the expected producer execution count. Distinguish an operator-rendered artifact from an agent-rendered one. If the operator denies/aborts, report render **pending**, not complete.

A saved/source-only or no-execution task **does not require** this fallback. If a failed render already executed QMD, preserve it and report the partial computation rather than initiating a retry. This workflow is portable at the handoff boundary; specific Codex permission fields are advisory examples only and are not present in every agent runtime.

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

## Select Only Authorized Pending Changes (`0.1.1`)

Obtain `qbento get` **successfully** before any ID/revision-bound operation. Use [agent-api.md](agent-api.md) for the strict versioned `selection.json` schema (fields `version: 1`, `docId`, `expectedRevision`, `selectedChangeIds`, optional `confirmedDeleteIds`). Selection uses exact `pending[].id`, not native slide/element IDs. Keep the same installed `qbento` throughout.

```sh
qbento get /path/to/deck.qmd > snapshot.json
# Serialize the exact IDs from successful get into selection.json.
qbento sync /path/to/deck.qmd --select selection.json > plan.json
# Review all selected/excluded IDs, source spans, identities, annotations and destructive edits.
qbento sync /path/to/deck.qmd --apply plan.json
```

**Selection is not source-edit authorization.** Deletion confirmation is separate. A selected deletion that consumes excluded element/subtree edits refuses `PARTIAL_DELETE_SELECTION`. A card/KPI's creation members must be selected together or entirely excluded. Supporting technical source identities and **optional** `.qbento-design` annotations can appear beyond the chosen text. **MUST check `annotations.patches` and every source span before Apply**: the exact `pending[].id` does not automatically authorize a separate optional heading class/comment. If an optional patch is outside scope, **STOP before Apply**, request the additional source authorization or disclose that selective sync remains incomplete; there is no documented CLI switch to remove annotations from an existing signed plan. Do not change `qbento-annotations` frontmatter without separate source-edit permission, and never hand-edit plan contents to bypass this decision. Necessary technical identity patches are distinct from optional metadata and must be assessed in scope. Studio's **Revisar cambios** starts with everything selected; changing checkboxes invalidates the old plan, and deletion confirmation has its own controls. Excluded pending changes remain. Ordinary `sync` still previews all; on CLI `0.1.0`, neither `--select` nor Studio selection is supported.

## Source Selection Is Not an HTML Publication Filter

`qbento sync --select` authorizes **which pending authored changes are written to QMD**. It does **not** choose which saved native text will appear in a future `qbento render`. In CLI `0.1.1`, the published native Bento deck retains saved authored edits that may still be pending and excluded from source sync. An excluded `pending[].id` can therefore remain excluded from **QMD** but its changed wording can still be visible in the **published HTML**. This is supported retained-state behavior, not evidence that selection applied the wrong QMD patch.

**Gate the delivered content independently before any external render or operator authorization.** Compare the requested HTML-visible/forbidden text with the current successful `qbento get` deck and *all* pending authored values, plus QMD and any other native content. Do not rely on inspecting selected/excluded IDs or the rendered QMD alone. If the user explicitly forbids a saved draft or confidential note from the published HTML, but that material remains in the saved native deck, **STOP before render** and report a publication blocker while preserving the pending state; do not proceed with an operator handoff. If the request only specifies source selection and does not clarify whether excluded pending text may be publicly visible, ask about publication scope before rendering. If the user explicitly accepts the saved native text in HTML, ordinary reviewed sync and an independently authorized render may proceed.

`slide.hide` is a visual/navigation setting, not confidential-data removal: a standalone HTML can still contain the retained content. Do not change source, delete pending work, overwrite internal state, detach computed content, manufacture a sanitizing flag, or edit the generated master HTML to make the result *look* compliant. A separate, independently reviewed sanitized publication project is a different workflow requiring express user authorization and source/state verification; the `0.1.1` CLI has no documented selective-HTML-publish switch. The operator must repeat this check against the final saved deck **immediately before** the one-shot render and independently inspect the delivered output afterwards.

## Successful Apply May Leave Pending Work

A successful Apply receipt reports `appliedChangeIds`, `pendingRetained: true` and `renderNeeded: true`. **“QMD updated; render pending” can be a correct stopping state.** The source has been updated but the saved executed baseline is still old. Selected pending edits may remain until the next verified render; **excluded** pending changes remain even after that render. Confirm the receipt, applied IDs and actual QMD changes rather than interpreting nonempty `pending` as failure.

Two normal post-Apply paths exist in CLI `0.1.1`:

- **With an approval marker:** structural identity acquisition, creation, deletion or normalization can retain `.qbento/sync-approved.json`. A second Apply may return `APPROVAL_PENDING`, reconciliation may return `SYNC_APPROVAL_PENDING`, and a fresh sync preview may return `RECOVERY_OR_BUSY` **naming that marker**. Check the successful Apply receipt and marker before diagnosing an interrupted transaction.
- **Without an approval marker:** for example, a selected authored-text edit with already stable QMD identities can Apply successfully while keeping `pending` and creating **no** `sync-approved.json`. A premature new `sync` preview may instead return `SOURCE_CONFLICT`, because QMD now contains the applied edit but the last **executed** baseline has not advanced. An absent marker does not invalidate a successful Apply.

For either path, compare the prior successful Apply receipt (including `appliedChangeIds`, `sourceHash` and `receiptPath` where available), the current QMD/source, pending state and any **intervening independent edits**. `SOURCE_CONFLICT` is **not automatically benign**: if source or state changed independently, or the receipt does not establish the expected source, stop and review that conflict rather than rendering through it. If evidence instead confirms only the expected post-Apply baseline lag, run **one independently authorized** `qbento render deck.qmd` and verify the resulting state/output. If execution is not authorized, preserve source, receipt, all pending changes and any marker, and report the outstanding render. Never blindly repeat Apply, manually clear a marker or initiate recovery solely because a valid Apply awaits execution.

## Studio and Browser Work

`qbento edit deck.qmd` prints a `127.0.0.1` URL and keeps a server alive. Track that process using the available terminal manager; do not launch duplicate servers because a tool read timed out. **Guardar proyecto** saves design/pending edits to `.qbento/`; Bento's native **Save** downloads an HTML copy instead. Other labels: **Revisar cambios** previews all or selected pending edits and invalidates prior previews when selection changes; **Aplicar** writes reviewed QMD; **Recalcular** executes; **Comparar con QMD** executes a comparison; **Guardar decisiones** applies reconciliation decisions to saved state and re-executes QMD for plan validation; it does not write source text.

Use the browser for controls not exposed by the JSON API: supported card/KPI creation, source-aware layouts, diagram **Relaciones**, or visual checks. All members of a managed component's pending creation belong together; geometry alone does not establish membership. An absent browser tool is not permission to forge Studio HTTP payloads or internal `.qbento/` data. Explain unsupported tasks or author appropriate QMD within scope instead.

The documented `.qbento/design.json` registry is a user-facing design configuration with its own schema. Editing it, when explicitly requested, is different from rewriting internal `project.json`/`state.json`/journals; preserve revision/recovery rules and confirm referenced layouts.

## Native HTML Capture and Rebuild

Preserve a local HTML file edited via native Save. Capture only a compatible copy from the **same project/document and emitted generation**:

```sh
qbento capture deck.qmd edited-copy.html
```

Capture checks publication receipt, identity and generation, and accepts one capture per publication generation. Re-render an accepted project before another native-copy editing cycle. A foreign, stale, receipt-less, encrypted or collaborative copy is not a general import source; never edit its receipt or the project's `docId` to match.

For reconstruction, retain QMD, input data/assets and required `.qbento/` project/state/design resources. Do not blanket-ignore or delete `.qbento/` as cache. A rebuilt base deck with missing retained design is not recovery of the old appearance. **Generated master `deck.bento.html` is not the saved design database.** Never use Python/string replacement or a direct HTML edit to claim a retained position/style change; use supported `get`/`patch`/fresh `get` or a verified Studio project save instead. Copying and editing a **separate** HTML artifact is legitimate within its explicit scope, but it is not a persistent Bento design edit unless the supported matching-generation `capture` succeeds.

## Bound Project Identity Before Recovery

One `.qbento/` directory belongs to **one QMD**. In installed 0.1.1, `status`, `diff`, `get` and Studio check this binding. `PROJECT_SOURCE_MISMATCH` means inspect the requested QMD and correct the project directory; do **not** rename a `docId`, delete a sidecar or adopt a sibling deck. `PROJECT_BINDING_MISSING` means saved/recoverable state exists without matching `.qbento/project.json`; restore the matching metadata from verified backup/Git, not an invented binding. For checked requests, a successful `get` is still needed to obtain the current `docId` and revision.

**Residual N01 (observed in app 0.1.1, functional source `78c1641`):** with valid `project.json` and a recoverable `state.previous.json`, but missing `state.json` **and** generated HTML, readers return `NO_BASELINE`. A first `edit`/`render` can bootstrap another `docId`, discard the recoverable design/pending changes and later overwrite the previous-state backup. This is **not** fixed by the 0.1.1 source-binding corrections or later publication-only docs. Before acting on `NO_BASELINE`, inspect `.qbento/` non-destructively for `project.json`, `state.json`, `state.previous.json`, `render-transaction.json`, `sync-transaction.json`, `sync-approved.json`, other recovery evidence and relevant Git/backups. If recoverable artifacts remain, preserve them and stop automatic `edit`/render/initialization; determine a supported explicit recovery plan before any new baseline or writes. Do not silently promote `state.previous.json` into current state, adopt another identity, or claim a product fix. A completely fresh QMD with no such artifacts may be initialized by an **authorized** first render. A QMD-only wording change may be made without execution if that is the full authorized scope.

This backup-only `NO_BASELINE` branch is **different** from a successful Apply awaiting render: that normal state has a valid current baseline, approved-source marker/receipt and retained pending changes. Do not run generic recovery merely because a successful Apply retained work.

## Refusals and Safe Recovery

Inspect both the JSON `error` and `message`; some CLI paths report a generic `QBENTO_ERROR` with a more specific message prefix.

| Evidence | Response |
| --- | --- |
| `STALE_REVISION` or project busy | Wait only for an identified live operation; reread, inspect intervening changes, and rebuild the remaining authorized intent. Persistent failure without progress: stop and report. |
| `STALE_SOURCE` on creation | Source and last execution differ. Review pending changes; authorized recalculation may refresh the baseline. Do not discard changes or run expensive/no-execute source without permission. |
| `UNRELATED_DOCUMENT`, conflicting `docId`, `PROJECT_SOURCE_MISMATCH` | Confirm the QMD/project association; preserve both. Do not relabel the sidecar, overwrite another deck's state or assume multiple QMDs per directory. |
| `PROJECT_BINDING_MISSING` | Restore verified metadata for the same QMD from backup/Git. Do not fabricate an association or replace saved state. |
| `NO_BASELINE` | Inspect for project metadata, previous-state backup and transaction artifacts **before** bootstrap. N01 backup-only projects require preservation and diagnosis, not automatic `edit`/render. |
| `APPROVAL_PENDING`, `SYNC_APPROVAL_PENDING`, `RECOVERY_OR_BUSY` naming `sync-approved.json` | Check a successful Apply receipt/marker: authorized render may be the normal continuation. Do not repeat Apply or delete state files. |
| `SOURCE_CONFLICT` after Apply (including **without** `sync-approved.json`) | Compare successful receipt, QMD/resulting source, current pending state and external edits. An old executed baseline may explain the refusal; genuine divergence still requires review. Render only when that distinction is verified and execution authorized. |
| `INVALID_SELECTION`, `PARTIAL_DELETE_SELECTION` | Reread `get`, inspect selected/excluded pending IDs and coupled component/deletion dependencies; build a fresh selection. |
| `UNCAPTURED_HTML_EDITS` | Preserve and capture the matching local copy before rendering. Never remove it simply to bypass the guard. |
| Computed-content conflict | Do not sync a rendered value into producer code. Inspect producer/input change options; restore or explicitly detach only when authorized. |
| `UNSUPPORTED_SYNC`, `UNMAPPED_DESIGN`, ambiguous identity | Retain pending work. Use supported codecs/source ownership; request review rather than guessing a lossy conversion. |
| Interrupted transaction | `qbento recover deck.qmd inspect`; read available actions and evidence. Execute `finish`/`rollback` only for a supported, authorized choice. |
| `DESIGN_REGISTRY_RECOVERY_REQUIRED` | Separate registry journal: preserve versions/marker and consult its product recovery contract. Generic `recover` does not repair it. |
| `MISSING_DESIGN` | Restore the named retained resources from backup/Git, or explain unavailable appearance; no fabricated recovery. |

For source/Bento conflicts, **both** reconciliation phases execute QMD and need execution permission: preview computes the current producer results, and a valid apply executes again to verify that its exact plan is still current. They are not read-only replacements for `status`. Never apply a fabricated resolution or assume that the reviewed plan is an authorization for another execution.

A resolution file has the shape `{ "plan": <the complete, unchanged preview JSON>, "choices": [{ "changeId": <one observed change.id>, "action": <offered action> }] }`. For example, **after independently authorizing preview and apply**:

```sh
qbento reconcile /path/to/deck.qmd > reconcile-plan.json
# Inspect change IDs, source/current values and the per-item offered actions.
```

```python
import json
from pathlib import Path

plan = json.loads(Path("reconcile-plan.json").read_text())
change_id = "PASTE_THE_REVIEWED_CHANGE_ID"
action = "keep-source"  # Only if offered for that change.
item = next(row for row in plan["changes"] if row["change"]["id"] == change_id)
if action not in item["actions"]:
    raise ValueError("Action is not offered for this change")
payload = {"plan": plan, "choices": [{"changeId": change_id, "action": action}]}
Path("resolution.json").write_text(json.dumps(payload, indent=2) + "\n")
```

```sh
# This re-executes Quarto and saves checked decisions, not QMD source edits.
qbento reconcile /path/to/deck.qmd --apply resolution.json
```

Use only offered actions, which can include `keep-source`, `keep-bento` or `detach` **when that item supports them**. Check the returned `resolved`, `remaining` and `renderNeeded`: a resolved choice can still require reviewed source sync or a later authorized render. `STALE_RECONCILE_STATE`, `STALE_RECONCILE_SOURCE` or `STALE_RECONCILE_PLAN` means fresh execution-authorized preview and re-evaluation of the choice, not changing hashes or force-applying the old file. Confirm newly destructive/detaching choices, but do not ask again if the user already authorized the exact decisions and their necessary executions.

## Distinguish Layout Diagnostics

- `OVERFLOW`: an **element box** extends past the slide bottom after retained design. Move/resize that box; this does not measure text clipping, rotation, horizontal edges or shadows.
- `TEXT_OVERFLOW`: text/list/KaTeX/displayed code **content** escapes its saved box, even if the box is entirely on-slide. Increase height/width or adjust typography; semantic shortening requires separately authorized source sync. Studio read-only diagnostics after Save can clear the warning **without re-executing QMD**; later render rechecks it.
- `TEXT_MEASUREMENT_UNAVAILABLE`: the text was **not reliably measured** (e.g. Chromium unavailable, rotated text). Do not call it a pass or pretend it is overflow; use an available local browser/visual inspection or report that measurement remains unverified, without changing global sandbox settings.
- `NATIVE_CONTENT_OVERFLOW`: a simple native **table/chart's measured contents** no longer fit its saved frame; enlarge/reapply a suitable layout and verify final metrics. `NATIVE_CONTENT_UNMEASURED`: custom/unsupported native metrics cannot be measured by the simple adapter; inspect in Studio or retain the design, not an invented automatic fit.
- Component-specific `KPI_CONTENT_OVERFLOW`, `CARD_CONTENT_OVERFLOW`, `LAYOUT_OVERFLOW`, `GRAPH_CONTENT_OVERFLOW` and related errors can **refuse** unsupported compositions. Fix roles, frames, source content or layout geometry within supported limits; do not suppress diagnostics, scale away content or rewrite producer results.

## Verification Appropriate to the Request

Check the mutated target and compare stable `docId`, expected IDs, requested values, unrelated work and pending items. When execution is requested, verify regenerated data output **and** retained geometry/style, not just command exit status. `validate` checks structure only. Open the actual rendered HTML/Studio for visual layout or interaction claims; warnings such as `OVERFLOW`, `TEXT_OVERFLOW`, or `TEXT_MEASUREMENT_UNAVAILABLE` are not a substitute for the relevant check. Never claim PDF export, pixel identity, a GUI operation, or a computation happened without evidence.

## Pinned Product Sources

- [Usage, exact Studio labels and recovery cases](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/USAGE.md)
- [Ownership, sync and capture invariants](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/SYNC.md)
- [Reconciliation contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/src/core/reconcile.ts)
- [Linux npm installation and immutable package snapshot caveats](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/NPM.md)

- [0.1.1 selective sync, post-Apply and binding contract](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/AGENT-API.md)
- [0.1.1 npm publication and installed CLI evidence](https://github.com/brianmsm/quarto-bento/blob/1b7e265bda07c060215051302f252a7289f4a1f9/docs/evidence/SYNC-SELECTION-0.1.1.md)
