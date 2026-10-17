---
name: quarto-bento-workflow
description: Create, edit, synchronize, render or recover Quarto-Bento presentations using qbento, Bento Studio or .qbento/ state. Preserve QMD and visual design. Not for ordinary revealjs/PPTX/Beamer or a merely bento-shaped layout.
---

# Quarto-Bento Workflow

Use the product's checked CLI and Studio to keep QMD meaning/computation, retained visual design, and pending edits consistent. This skill is an operational companion, not a replacement for general Quarto authoring or slide-narrative expertise.

## Establish the Target

- Locate the actual QMD, project directory, CLI and requested artifact. Verify `qbento --version`, `qbento help` and `qbento doctor` as needed. This reference baseline is **CLI 0.1.0, agent JSON v1, Linux**; different versions require checking their actual contracts before mutation.
- Prefer the installed `qbento`. A known source checkout can instead run `deno task qbento` from its own root against an absolute QMD path. Do not require a personal checkout path, silently install runtimes, or switch tool versions mid-task.
- **New project:** use a separate directory for its single QMD, prepare trusted source, then run the first authorized `qbento render`. `get`/`status` need an existing baseline. `init` installs Quarto integration; it does not create a presentation.
- **Existing project:** inspect `qbento status` and `qbento get` before changing source, state or recomputing. Resolve the QMD's association, saved `docId`, revision, pending changes and ownership. Do not treat missing state or `MISSING_DESIGN` as permission to discard/recreate a designed project.

For creating QMD or choosing components, read [authoring-components.md](references/authoring-components.md). For installation details, execution effects, pending work or conflicts, read [sync-and-recovery.md](references/sync-and-recovery.md).

## Choose the Editing Surface

| Task | Surface |
| --- | --- |
| Meaning, calculations, new data-backed content or unsupported native creation | QMD/inputs, after checking pending Bento work and source identity |
| Existing element/slide fields or supported native slide actions | `get` → checked `patch`; read [agent-api.md](references/agent-api.md) before constructing a request |
| Visual controls not exposed by the JSON API, layout preview or visual inspection | Studio/browser if available; do not invent a CLI equivalent |

QMD owns authored content and computations. `.qbento/` normally owns geometry, typography and decoration, **except visual properties explicitly authored in QMD**, which keep source ownership. Computed numbers/figures are not literal authored text: update their producer, or obtain explicit authorization for a supported detach. A visual patch cannot rewrite analytical code or freeze old results as styling.

## Edit, Review and Execute Separately

1. Read IDs, provenance and current revision from the saved snapshot. Use exact slide/element IDs, not positional guesses. Create bounded payloads through `qbento patch`, not edits to `.qbento/state.json` or generated HTML.
2. A successful patch/Studio **Guardar proyecto** saves state; it does not write QMD or refresh HTML. Inspect pending changes and the reported `sourceUnchanged`/`renderNeeded` result.
3. For source changes, obtain `qbento sync deck.qmd > plan.json`; inspect the exact fragments, identity/annotation additions, removals, diagnostics and scope **before** `qbento sync deck.qmd --apply plan.json`. If the user already authorized those changes, technical review is sufficient; do not ask for redundant confirmation. Ask about new ambiguous/destructive decisions, detachment, or unrelated pending edits. Never forge plan hashes or deletion approvals. **A data-only or design-only request does not authorize source sync. If QMD must stay unchanged, preserve its bytes, including comments/IDs/annotations; optional design annotations are not required to retain sidecar design.**
4. Recompute with `qbento render deck.qmd` only when execution is allowed and needed. **Both `reconcile` preview and a valid `reconcile --apply resolution.json` re-execute QMD; apply reruns the producer to verify the reviewed plan before saving decisions. Each requires execution authorization, even when QMD bytes stay unchanged or a plan already exists. `edit` without a baseline performs an initial render.** Do not use these to evade a no-execution request or assume Quarto CLI flags pass through `qbento`.
5. Verify the requested persisted state and/or regenerated output, preserving unrelated pending work. For a no-source-edit request, compare the QMD before/after rather than only its visible prose. Report which layer changed: source, saved design, pending journal, or delivered HTML. Do not equate a successful save with a current render, or a valid envelope with visual quality.

## Refusals and Recovery

On `STALE_REVISION` or busy state, reread and reconsider the target; never blindly replay against an incremented revision. On `STALE_SOURCE`, review pending work and the execution permission before recalculation. On an identity mismatch, uncaptured HTML, unsupported sync or computed conflict, stop that mutation and use [sync-and-recovery.md](references/sync-and-recovery.md). Repeated refusal without new evidence is a stopping condition, not an invitation to force state.

Preserve `.qbento/`, backups and edited HTML. Never delete state, receipts, locks, or pending edits merely to make rendering succeed. Use `recover ... inspect` before selecting an available recovery action. The public design registry is a separate documented interface; it is not permission to rewrite internal project journals.

## Compose Capabilities Without Duplicating Them

When available and relevant, use `quarto-authoring-core` for generic QMD syntax, `quarto-report-design` for audience/narrative, `quarto-computation-performance` for execution strategy, `quarto-format-configuration` for ordinary formats, and `quarto-render-troubleshooting` for underlying Quarto/runtime failures. `r-analytic-coding-principles` may help with R code. Load only what the task needs; these are **optional capabilities**, not installation dependencies or fixed cross-plugin filesystem paths.

Keep Bento identity, state, permissions and execution contracts active across any handoff. Revealjs CSS/options are not Bento instructions; `format: bento` is not the installed integration format. A generic Quarto render or cache suggestion must not bypass Bento's pending-work checks. If a requested capability or tool is unavailable, describe the limitation rather than claim a check or supported conversion.
