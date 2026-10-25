---
name: quarto-bento-workflow
description: "Use ONLY for work with the Quarto-Bento application (qbento), its Bento QMD authoring, or retained .qbento/ project state: checked geometry, pending source sync, native render, capture and recovery. Exclude ordinary Quarto slide-format or YAML changes and independent HTML-copy edits."
---

# Quarto-Bento Workflow

QMD/inputs own semantics and computation; checked `.qbento/` state retains design unless QMD
explicitly owns a visual field. Generated `*.bento.html` is **output**, never the saved design.

## Use and References

- **Use:** "Move a saved Bento heading", "sync one pending Bento text edit", or "recover
  `.qbento/` state". For an authorized native HTML **capture**, also use this workflow.
- **Do not use:** ordinary Reveal.js/PPTX/Beamer, Bento-like HTML styling, a notes-only
  summary or editing an independent HTML copy without capturing it. A negative mention
  of Bento does not turn an otherwise unrelated task into a Bento-state edit.
- Read only what the operation needs: [agent-api.md](references/agent-api.md) for checked
  JSON and selection; [sync-and-recovery.md](references/sync-and-recovery.md) for Apply,
  execution, capture and recovery; [authoring-components.md](references/authoring-components.md)
  for source components and the design registry.

## Required Checks

1. **MUST persist retained design.** On an existing saved object, use a successful
   `qbento get` → revision/identity-checked `qbento patch` → **fresh `qbento get`**.
   Confirm the requested fields, stable `docId` and other people's pending edits.
   For Studio-only features, save **Guardar proyecto** and verify saved state.
   For QMD-owned visual attributes, use the authorized source workflow instead.
   **NEVER** edit generated `*.bento.html` or internal `.qbento/state.json` as a shortcut.
   Editing a separate HTML copy is valid for its own scope, but is not retained
   design unless a supported, matching-generation `qbento capture` succeeds.
2. **MUST gate source edits before Apply.** Review the **complete** `sync` plan:
   selected/excluded pending IDs, necessary technical identities, optional
   `annotations.patches`, deletions and resulting QMD. Selecting an authored edit
   does **not** authorize a separate `.qbento-design` heading class/comment.
   If any optional patch exceeds the user's scope, **STOP before Apply**: request
   that extra source authorization or report synchronization as deferred.
   Do not rewrite the plan or invent `--no-annotations`. Changing the top-level
   `qbento-annotations` setting also requires source-edit permission. Necessary
   technical identity changes are distinct from optional annotations; do not
   demand redundant consent for supporting edits already within scope.
3. **MUST gate publication content separately from QMD sync.** `sync --select`
   writes only approved source changes; excluded authored edits can remain visible
   in the saved Bento deck and **appear in rendered HTML**. Before authorizing a
   render, check the full saved deck and pending edits against the user's **HTML
   publication** scope. If a pending draft is forbidden in output, STOP before
   render without discarding it; if visibility is unclear, clarify first.
   Do not treat `slide.hide` or an edited HTML copy as a privacy filter. See
   [sync-and-recovery.md](references/sync-and-recovery.md).
4. **MUST verify the requested outcome before claiming completion.** A tool success,
   generated-HTML modification or updated computation intermediate is insufficient.
   If a saved change or authorized render fails, preserve artifacts and report
   what was actually saved, synchronized or delivered versus still incomplete.

## Choose the Task Path

- **Preflight:** resolve the single QMD Bento project and installed `qbento --version`;
  verified Linux app is `0.1.1` (JSON v1); the agent plugin has its own
  independent version declared in its distribution manifest.
  For saved work, inspect `status` and a successful `get`. Before interpreting
  `NO_BASELINE` as fresh, check `.qbento/project.json`, `state.previous.json` and
  recovery/approval journals. The unresolved **N01** backup-only state can be
  destroyed by bootstrap: preserve it and **do not** run first `edit`/render.
  A genuinely new project needs an authorized first render for `get`/`patch`;
  an uninitialized source-only QMD edit need not render. See the recovery reference.
- **Visual-only:** `get` → `patch` → `get`, or verified Studio project save.
  Do not render or synchronize QMD merely to retain geometry or styling.
- **Authored sync:** use exact `pending[].id` values from `get` (not element IDs),
  preview `qbento sync ... --select selection.json`, apply the **unchanged** plan
  only when every patch is authorized, and verify receipt/QMD/pending exclusions.
- **Apply versus render:** Apply may leave `pendingRetained`/`renderNeeded`, with
  or without `sync-approved.json`. `RECOVERY_OR_BUSY` or `SOURCE_CONFLICT` on a
  premature new preview requires checking receipt, QMD and independent changes;
  it is not proof of failed Apply or harmless divergence. Render only when
  authorized. **Both** reconciliation preview and `reconcile --apply` execute QMD.
- **Chromium blocked by the agent sandbox:** NEVER trial-run an executing render
  in a known-incompatible sandbox: R/Quarto can run before Chromium fails. For
  trusted source, obtain a **separate, explicit** approval to run the exact render
  outside that sandbox. If native one-command elevation is unavailable or denied,
  STOP **before** executing QMD and hand off to an approved external renderer;
  then verify real saved state and HTML. Do not assume Auto-review automatically
  escalates Bash or rerun after a partial failure. See [sync-and-recovery.md](references/sync-and-recovery.md).
- **Computation:** run producers only when permitted; never replace computed
  output with an invented literal or edit source/optional annotations when QMD
  bytes must remain unchanged.

## Completion and Composition

Verify the **layer requested**: checked saved geometry/revision/pending state,
reviewed QMD diff/receipt, or actually regenerated HTML/computed values.
Distinguish **saved**, **source synchronized**, and **rendered** in the result.
Do not claim visual acceptance from structural `qbento validate` alone.

Other Quarto/R skills are optional for their own task-specific advice, not required
for a simple Bento edit. Keep Bento identity, source scope and no-execution
constraints active when composing; installation is not proof another skill was read.
