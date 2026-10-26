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
  [authoring-components.md](references/authoring-components.md) for new QMD/component syntax,
  supported tables and design registry.

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

- **Preflight:** identify the Bento QMD/project and `qbento --version` (tested Linux app `0.1.1`, JSON
  v1; plugin version is independent). For existing state inspect binding, `status` and successful
  `get`. Before treating `NO_BASELINE` as new, inspect `.qbento/` project/previous state and recovery
  journals: backup-only **N01** can lose design/pending on bootstrap. Preserve recoverable state. A
  genuinely new QMD needs an authorized first render before native `get`, but source-only edits need
  no render.
- **Visual-only:** persist `get → patch → get` or verified Studio project save; do not sync or execute
  QMD just for native geometry.
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
- **Computed source:** execute producers only within the user's scope; preserve genuine producer
  provenance and QMD bytes when source edits are prohibited. Consult [authoring reference](references/authoring-components.md#analytical-output-without-faking-provenance) for
  supported output.

## Composition

For teaching or presentation-communication decisions, consult `quarto-report-design` **when
available and relevant**: its pedagogical guidance owns the explanation, while its slide-deck
guidance owns audience, structure and density. Read only the needed advice; an ordinary native
Bento edit does not require another skill. Choose the output engine before applying motion:
use Reveal.js-specific `auto-animate` only for Reveal.js, and Bento-native
motion for Bento. When migrating a Reveal.js QMD, retain its original source
attributes and disclose loss of animation fidelity in the Bento projection;
see [motion and migration](references/authoring-components.md#progressive-motion-and-revealjs-migration).
Bento still owns supported QMD constructs, retained design, source synchronization
and authorized rendering.

Other Quarto/R skills remain optional, never runtime dependencies. Preserve Bento identity,
source ownership and execution boundaries when composing; installation alone is not proof a
companion skill was read.
