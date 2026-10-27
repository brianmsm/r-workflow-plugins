---
name: quarto-bento-workflow
description: "Use ONLY for work with the Quarto-Bento application (qbento), its Bento QMD authoring, or retained .qbento/ project state: checked geometry, pending source sync, native render, capture and recovery. Exclude ordinary Quarto slide-format or YAML changes and independent HTML-copy edits."
---

# Quarto-Bento Workflow

QMD/inputs own semantics and computation; checked `.qbento/` state retains design unless QMD
explicitly owns a visual field. Generated `*.bento.html` is output, not saved design.

## Scope and Task References

- If activated for ordinary Reveal.js/PPTX/Beamer, unrelated HTML copies, or notes-only summaries,
  handle that work **without Bento state operations**. Incidental mentions of Bento do not establish a
  Bento task.
- **Read only the reference needed:** [agent-api.md](references/agent-api.md) for JSON snapshots,
  checked patching and selected-source schemas;
  [sync-and-recovery.md](references/sync-and-recovery.md) for execution effects, Apply lifecycle, HTML
  visibility, Studio, capture and recovery;
  [authoring-components.md](references/authoring-components.md) for QMD/component syntax, reusable
  theme/slot designs, computed layouts, scroll output and bounded inline widgets.

## Required Invariants

1. **MUST verify saved design.** For existing objects, use a successful `qbento get` →
   identity/revision-checked `qbento patch` → **fresh `get`**. Check requested fields, stable `docId`,
   revision and unrelated pending edits. For Studio-only work, use **Guardar proyecto** and verify
   saved state. Editing generated HTML or internal `.qbento/state.json` is not retained design; an
   independent HTML copy is separate unless matching-generation `qbento capture` succeeds.
2. **MUST review source Apply.** Inspect the **complete** sync plan: selected/excluded `pending[].id`,
   source spans/resulting QMD, auxiliary identity edits, `annotations.patches` and deletions. Optional
   `.qbento-design` patches need source authorization; supporting technical identities may already be
   within scope. If an edit exceeds permission, **STOP before Apply**. Do not rewrite the plan or
   invent `--no-annotations`; follow
   [agent-api.md](references/agent-api.md#selectively-synchronize-authored-changes-011).
3. **MUST gate HTML publication separately.** Selected QMD sync does **not** filter saved native text
   from generated HTML. Compare the **whole saved deck and pending work** with allowed/forbidden
   output. If excluded text may not be published, stop without discarding it; clarify unclear
   visibility. `slide.hide` or editing master HTML is not a privacy filter. Follow [publication checks](references/sync-and-recovery.md#source-selection-is-not-an-html-publication-filter).
4. **MUST verify the requested result.** Distinguish **saved native state**, **synchronized source**
   and **rendered HTML/computation** using actual artifacts/receipts. Preserve failed or incomplete
   work rather than claiming success; structural validation alone is not proof of visual fit.

## Choose the Task Path

- **Preflight and version gate:** identify QMD/project and **actual CLI** (`qbento --version`). Both
  Linux app versions `0.1.1` and `0.2.0` are npm-published; `0.2.0` is tagged in the app repository
  and adds version-gated features. Earlier isolated candidate tests remain historical evidence,
  not proof of every released UI workflow. JSON agent API v1 and agent-plugin version are
  independent. **Do not call `design` or use 0.2-only QMD options with a 0.1.1 CLI.** On
  existing state inspect binding, `status` and successful `get`. Before treating
  `NO_BASELINE` as new, inspect `.qbento/` previous state/recovery journals (backup-only **N01** may
  lose design/pending). New QMD needs authorized first render before native `get`; source-only edits do
  not.
- **Visual-only:** persist `get → patch → get` or verified Studio project save; do not sync/execute
  QMD just for native geometry. On 0.2, prefer [reusable themes/variants/slots](references/authoring-components.md#reusable-design-and-explicit-ownership)
  for recurring compositions, then targeted native overrides; avoid bulk per-element scripting when
  named design is sufficient. Keep source-owned geometry separate from saved state.
- **Authored sync:** select exact `pending[].id` values, preview and review the unchanged plan, Apply
  only approved QMD patches, and verify receipt/source/retained pending; see
  [agent-api.md](references/agent-api.md#selectively-synchronize-authored-changes-011).
- **After Apply:** pending work or `RECOVERY_OR_BUSY`/`SOURCE_CONFLICT` may reflect expected
  unrendered source; compare successful receipt, source and any independent changes before further
  action. **Both** `reconcile` preview and `reconcile --apply` execute QMD; no-execution requests
  prohibit both. See [state details](references/sync-and-recovery.md#successful-apply-may-leave-pending-work).
- **Browser-incompatible sandbox:** do **not** trial-render there: Quarto/R may execute before
  Chromium fails. For reviewed trusted source, use an exactly scoped, authorized one-shot host
  execution/handoff when the user permits that trust boundary; if denied or unavailable, stop before
  QMD execution. Do not rely on Auto-review elevation, weaken browser security or retry partial
  execution blindly. See [host-render handoff](references/sync-and-recovery.md#browser-render-handoff-in-restricted-agent-environments).
- **Computed source and 0.2 output:** execute producers only within the user's scope. Preserve source
  and computed provenance; consult [authoring](references/authoring-components.md#computed-code-and-output-layout-app-020)
  for opt-in source/result layouts and scrolling. Output visibility/scroll/PDF and Plotly camera
  saving are **not** permission to reverse-write R/data or to publish unapproved native content; use
  [Studio/output workflow](references/sync-and-recovery.md#interactive-widgets-scroll-and-pdf-in-app-020).
  Preserve runnable `{r}` versus displayed `{#id .r}` code identity.

## Composition

For **new or substantially redesigned teaching decks**, plan the learning progression with
`quarto-report-design`'s pedagogical and slide-deck guidance **when available**, before choosing
Bento layouts, slots or motion. For a targeted native edit, consult only the needed advice;
the absence of a companion skill must not block an otherwise supported Bento task. Choose the
output engine before applying motion:
use Reveal.js-specific `auto-animate` only for Reveal.js, and Bento-native
motion for Bento. When migrating a Reveal.js QMD, retain its original source
attributes and disclose loss of animation fidelity in the Bento projection;
see [motion and migration](references/authoring-components.md#progressive-motion-and-revealjs-migration).
Bento still owns supported QMD constructs, retained design, source synchronization
and authorized rendering.

Other Quarto/R skills remain optional, never runtime dependencies. Preserve Bento identity,
source ownership and execution boundaries when composing; installation alone is not proof a
companion skill was read.
