# Quarto-Bento Plugin Architecture

## Distribution Boundary

This plugin is the independently installable, versioned **agent companion** for the Quarto-Bento application. A separate application repository or JSON API does not automatically require a new plugin; independence is chosen here so consumers can adopt and update Bento-specific operating guidance separately from general Quarto skills.

Initial implementation: **one skill**, `quarto-bento-workflow`, plus three local task references. No router, duplicate performance/design/troubleshooting skills, runtime clone, MCP wrapper or global `AGENTS.md` rule. The monorepo's [architecture](https://github.com/brianmsm/r-workflow-plugins/blob/feeaf6c71b70a1f5cac46b5f723d3ba613ac32e0/docs/architecture.md) and [release procedure](https://github.com/brianmsm/r-workflow-plugins/blob/feeaf6c71b70a1f5cac46b5f723d3ba613ac32e0/docs/release-process.md) govern distribution; draft `0.0.0` was unpublished and setting manifest `0.1.0` alone does not create a public tag/catalog entry.

## Three Editing Surfaces

| Surface | Responsibility | Boundary |
| --- | --- | --- |
| QMD and inputs | Semantic source, code, declared components and explicit visual attributes | Inspect saved Bento state first; preserve identity and unsynchronized work |
| Versioned CLI JSON API | Checked existing-object edits and bounded slide actions in saved state | Mandatory document/revision identity; API is not the whole Studio feature set |
| Studio/browser | Supported visual authoring and UI operations, layout preview and interactive inspection | Save project is not native HTML Save; do not claim browser work from a CLI result |

QMD is authoritative for meaning and computation; the sidecar normally governs design. Explicit source visual attributes are the non-obvious exception. A pending authored edit, computed provenance and a detached output are distinct states; no last-writer-wins policy is introduced by the skill. Selective sync only scopes QMD source writes; a later HTML render composes retained native state, so HTML visibility requires a separate publication authorization check.

The operational entrypoint requires preflight only where relevant: an untouched, genuinely new QMD cannot produce a saved snapshot until an authorized render; a source-only edit without a Bento baseline need not render. **Before treating `NO_BASELINE` as new, inspect recovery artifacts:** the residual backup-only N01 scenario is not corrected by 0.1.1. Existing saved decks must have binding and pending work inspected before mutation/recomputation. The product, not the skill, implements locking, compare-and-swap, schema checks and source patch atomicity.

## Resources and Provenance

`SKILL.md` owns selection, sequencing and authorization decisions. `agent-api.md` owns JSON operation details; `authoring-components.md` owns the implemented source subset; `sync-and-recovery.md` owns persistence, capture, execution effects and recovery. Each records the same supported product version and immutable source revision. Do not treat examples in a target roadmap as implemented API.

Baseline: locally installed and npm-published app CLI **0.1.1**, JSON **v1**, pinned Bento **1.2.6** contract, product documentation at `1b7e265bda07c060215051302f252a7289f4a1f9` (0.1.1 functional changes at `78c1641`; 2026-10-17 review). The agent plugin manifest declares **`0.1.0`** for the scoped first release; its version is independent of application `0.1.1`. Linux is the application's validated platform scope. Portable instruction layout does not establish Windows/macOS support, native Claude behavior, or identical pixels across machines.

The 0.1.1 CLI/Studio expose selective source sync by pending change ID; a successful Apply may leave approved changes pending until render. The skill owns this lifecycle and refusal handling, not new product implementation.

## Optional Cross-Plugin Composition

A task about narrative can consult `quarto-report-design`; an execution-cost issue can consult `quarto-computation-performance`; an R edit can consult `r-analytic-coding-principles`. These names are hints for available capabilities, not guaranteed tool invocations or relative filesystem dependencies. Do not load all companion references for a simple position change.

Bento rules continue to constrain operations: pending state must not be dropped by a general QMD edit, `qbento` flags are not Quarto passthroughs, and both reconciliation preview and apply can execute QMD. Generic format choices and revealjs/PPTX/Beamer remain in `quarto-publishing`. Additional generic-plugin handoff edits require a demonstrated routing problem; no such edits are part of this initial implementation by default.

## Growth Gate

Split a capability only if repeated tasks establish a distinct activation/workflow and the split reduces ambiguity. New app operations first require checking the actual released contract, updating the appropriate reference and testing behavior; they do not require an automatic new skill or a matching plugin/app version number. Keep supported, tested and planned behavior distinct.
