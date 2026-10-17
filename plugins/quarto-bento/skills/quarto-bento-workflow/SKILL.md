---
name: quarto-bento-workflow
description: Create, edit, synchronize, render or recover Quarto-Bento presentations using qbento, Bento Studio or .qbento/ state. Preserve QMD and visual design. Not for ordinary revealjs/PPTX/Beamer or a merely bento-shaped layout.
---

# Quarto-Bento Workflow

This is an operational companion, not a replacement for general Quarto authoring or presentation design. Keep QMD/inputs, saved `.qbento/` state, and generated output distinct.

## Identify the Project and Runtime

- Resolve the requested QMD and its directory (one QMD presentation per directory). Check the **actual selected launcher** with `qbento --version`, `qbento help` and `qbento doctor` as relevant. The verified Linux baseline is installed `qbento 0.1.1`, JSON protocol **v1**; these are not the agent plugin version (`0.0.0`). Do not silently install, switch from a source checkout or assume the same commands exist on `0.1.0`.
- **Before treating `NO_BASELINE` as new**, inspect the existing `.qbento/` for project metadata, `state.previous.json`, transaction journals, approval markers or other recovery evidence without changing them. A valid binding and previous-state backup can coexist with missing `state.json`; the **known 0.1.1 N01 recovery gap** permits `edit`/`render` to replace recoverable identity/design. Preserve the files and stop bootstrap until recovery is resolved. Read [sync-and-recovery.md](references/sync-and-recovery.md).
- A genuinely uninitialized Bento project requires a first **authorized** `qbento render` before `get`/`patch`. A previously written QMD with no Bento state can still receive an authorized source-only edit **without** render. For saved projects, inspect `status` and a successful `get` before mutations; wrong QMDs refuse `PROJECT_SOURCE_MISMATCH`, while missing binding metadata can refuse `PROJECT_BINDING_MISSING`.

## Choose the Editing Surface

| Intent | Supported surface |
| --- | --- |
| Source semantics, computation, data, unsupported native creation | QMD/inputs, after checking Bento ownership/pending work; read [authoring-components.md](references/authoring-components.md) as needed |
| Existing object/slide fields and bounded slide actions | `get` then checked JSON `patch` with exact IDs and revision; read [agent-api.md](references/agent-api.md) |
| Native layout preview, card/KPI creation, interactive visual controls | Studio/browser; not every Studio operation has a JSON agent equivalent |

QMD owns meaning, producers and **visual fields explicitly declared in QMD**. `.qbento/` normally owns retained geometry, typography and decoration. Do not edit `state.json` or generated HTML to bypass checked operations. Computed content must come from a producer execution; an edited literal is not a new computed result without an explicitly authorized detach.

## Save, Select, Apply, and Render Are Separate

1. Inspect IDs, `provenance`, `ownership`, pending changes and revision through a **successful** `qbento get`. A saved `patch` or Studio **Guardar proyecto** changes Bento state/pending only; neither writes QMD nor updates HTML.
2. For approved authored changes, use `pending[].id` from `get` to create a versioned `selection.json`, and preview with `qbento sync deck.qmd --select selection.json > plan.json`. On `0.1.0`, this selection interface does not exist. Read [agent-api.md](references/agent-api.md) for its exact envelope, deletion consent and atomic component grouping.
3. Review the **entire** generated plan: selected/excluded change IDs, identity and optional annotation patches, source spans, deletions and conflicts. Apply the unchanged file with `qbento sync deck.qmd --apply plan.json` **only within the authorized source scope**. Studio selection changes invalidate its previous preview. A data/design-only task does not authorize source sync or optional `.qbento-design` annotation writes; preserve QMD bytes when source edits are prohibited. Never forge plan hashes or deletions, silently include excluded work, or request redundant confirmation for an already authorized reviewed change.
4. After Apply, interpret `appliedChangeIds`, `pendingRetained` and `renderNeeded`. **QMD updated; render pending** can be a correct stopping state **with or without** `.qbento/sync-approved.json`. `APPROVAL_PENDING`, `SYNC_APPROVAL_PENDING`, `RECOVERY_OR_BUSY` naming the marker, or even `SOURCE_CONFLICT` on a new preview without a marker can reflect the old executed baseline. **Verify the successful receipt, resulting QMD and intervening edits** before deciding; never assume all `SOURCE_CONFLICT` errors are harmless, replay Apply, delete markers or discard pending work. Read [sync-and-recovery.md](references/sync-and-recovery.md).
5. Execute `qbento render deck.qmd` only if needed **and authorized**; it recomputes the QMD independently and verifies applied changes while retaining excluded pending edits. Both reconciliation preview **and valid `reconcile --apply` execute QMD**; new-project `edit` also renders. No source write does not imply no code execution. Do not invent `qbento` passthrough flags to suppress execution.
6. Verify the requested layer separately: source bytes and producer values, saved design and `docId`, selected/excluded pending work, receipt/approval, and regenerated HTML. A valid JSON envelope is not proof of visual or interactive quality.

## Diagnose and Recover Without Resetting State

On `STALE_REVISION` reread and reconsider intervening work, not just the revision number. On foreign/missing binding, wrong HTML generation, `NO_BASELINE` with recovery artifacts, missing design, unsupported codecs, computed conflicts or interrupted journals, preserve QMD, `.qbento/`, HTML and backups. Use only supported and authorized recovery actions after inspection. Do not mistake a normal post-Apply approval for an interrupted transaction or automatically bootstrap N01 backup-only projects. See [sync-and-recovery.md](references/sync-and-recovery.md) for precise diagnostic branches, layout/overflow repairs, reconciliation choices and delivery modes.

## Optional Composition

Use available `quarto-authoring-core` and `quarto-report-design` for ordinary QMD/narrative guidance, `quarto-computation-performance` for execution strategy, `quarto-format-configuration` for conventional formats, `quarto-render-troubleshooting` for Quarto/runtime failures, and `r-analytic-coding-principles` for R source when relevant. None is a mandatory plugin dependency. Bento-specific state, pending and execution permissions remain in force across handoffs. Ordinary Reveal.js/PPTX/Beamer and Bento-like visual styles do not trigger this workflow; `format: bento` is not the installed integration format.
