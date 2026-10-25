# Quarto-Bento Agent Plugin

A portable companion for agents using **Quarto-Bento**: QMD authoring/computation, retained visual design, structured `qbento` operations, selective source synchronization and conservative recovery.

**Plugin manifest version:** `0.1.0`, defining the scoped first release. The version field alone does **not** publish a tag or marketplace listing; distribution is controlled by the `quarto-bento-v0.1.0` tag and its catalog pins. This version belongs to the agent plugin, **not** to the application: the separately installed/published application baseline is `@brianmsm/quarto-bento 0.1.1`, JSON agent protocol v1, with verified product scope on Linux. Application `0.1.0` remains a historical compatibility baseline. The plugin does not install or bundle the application, runtimes, assets or fonts.

## Scoped 0.1.0 Support and Evidence

The scoped initial release targets **reviewed, trusted local QMD projects on Linux** using the installed `qbento 0.1.1` CLI. Native Codex actor evidence covers saved-design edits, approved selective source synchronization, conservative privacy/recovery stops, ordinary non-Bento negative controls, and one **completed first-render authoring case with a short-header Markdown table**. For executable QMD and public-facing HTML, review all QMD chunks, hooks, inputs, native pending content, and the complete potential HTML visibility before a separately authorized one-shot host render. Source-only `sync --select` never filters retained native HTML content.

This is a deliberately **narrower local acceptance policy** than the earlier strict experimental gate: neither R1-NEW (`NOT_CLEAN`) nor R2-LOCAL (`PASS_LOCAL` under a different protocol) has been reclassified as one of two strict H2 CLEAN rounds. The new table/first-render trial passed the local S/T/A/H checks; its `TEXT_MEASUREMENT_UNAVAILABLE` diagnostics mean **visual text fit was not independently measured**. The native app's backup-only N01 recovery risk remains; do not bootstrap a recoverable project as new. No Windows/macOS, native Claude-agent task execution, unrestricted untrusted QMD execution, complete Studio/browser acceptance, rich/wrapped tables, or cross-machine pixel fidelity is certified. Claude manifest validity is **structural compatibility only**.

## One Skill, Three Operational References

- [`quarto-bento-workflow`](skills/quarto-bento-workflow/SKILL.md): identify the actual project, choose QMD/API/Studio, preserve source and state ownership, separate save/sync/render, and stop unsafe mutations.
- [`agent-api.md`](skills/quarto-bento-workflow/references/agent-api.md): snapshot/IDs, request envelopes, supported operations, atomic batches, bounded slide creation and refusals.
- [`authoring-components.md`](skills/quarto-bento-workflow/references/authoring-components.md): new-source branch, stable IDs, supported components and authoring limits.
- [`sync-and-recovery.md`](skills/quarto-bento-workflow/references/sync-and-recovery.md): operation effects, execution permissions, plan review, Studio, capture, recovery and verification.

Each reference records the product revision it describes and links to immutable source documentation. It is usable without the product's development checkout. Check the installed application version before applying it to another release.

## Use and Local Development

With the skill available to the agent, a request can be as simple as:

> Use Quarto-Bento to update this presentation while preserving its design and pending edits.

Codex can explicitly invoke `$quarto-bento-workflow`; optional `agents/openai.yaml` describes that interface. Substantive instructions are shared with other agents, and do not require a particular MCP server or terminal manager. Automatic selection must be tested, not assumed. **Retained design changes are complete only when a fresh `qbento get` confirms the saved fields; editing generated `.bento.html` is not persistent design work.** Selected source sync must separately authorize optional `.qbento-design` annotations, even when the semantic pending ID is approved. **Selected QMD synchronization is not selective HTML publication:** the saved native deck may still contain excluded authored drafts that appear in rendered output. Review the full saved/pending content against the user's publication permissions **before** approving any render; preserve and stop if private material would be exposed. On a known browser-incompatible Codex sandbox, a trusted, explicitly authorized host-render handoff can publish the deck without granting the whole agent unrestricted permissions; this is a **separate operator action**, not a built-in plugin renderer. See [sync and recovery](skills/quarto-bento-workflow/references/sync-and-recovery.md).

To test the unpublished plugin in Codex, use a **separate local development marketplace** pointing at this plugin's directory, following the [repository setup guide](https://github.com/brianmsm/r-workflow-plugins/blob/feeaf6c71b70a1f5cac46b5f723d3ba613ac32e0/docs/agent-setup.md). Adding the public marketplace alone will not install this draft. Claude Code has a matching manifest and can load a local directory via `claude --plugin-dir ./plugins/quarto-bento` from the monorepo root; manifest validity does not imply a Claude behavior test.

The application itself must be available as `qbento`, a portable launcher, or a compatible source checkout. The skill detects which is available; no absolute developer path is embedded. App installation, changes to project configuration, commits and publication remain separately authorized operations.

## Composition, Not Duplication

`quarto-publishing` retains generic authoring, narrative, performance, format configuration and rendering expertise. `r-analytic-core` retains research R coding conventions. They are useful optional companions; this plugin owns only the Bento-specific identity/state/CLI/codec/recovery contract, which stays in force when another capability is consulted. Do not import revealjs styling assumptions into Bento or duplicate existing skills under new names.

Read [architecture](docs/architecture.md), [roadmap](docs/roadmap.md), [validation cases](docs/validation-cases.md) and [initial findings](docs/pilot-findings.md). Raw local tests belong outside the distributable plugin; any validation summary must distinguish application tests, agent behavior, source integrity, rendered output and visual/UI evidence.
