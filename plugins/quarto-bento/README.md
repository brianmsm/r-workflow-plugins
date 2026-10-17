# Quarto-Bento Agent Plugin

A portable companion for agents using **Quarto-Bento**: QMD authoring/computation, retained visual design, structured `qbento` operations, reviewed synchronization and recovery.

**Plugin status:** local development `0.0.0`, not published in the monorepo marketplaces. This is **not** the application release number: the application baseline is `@brianmsm/quarto-bento 0.1.0`, JSON agent protocol v1, with verified product scope on Linux. The plugin does not install or bundle the application, runtimes, assets or fonts.

## One Skill, Three Operational References

- [`quarto-bento-workflow`](skills/quarto-bento-workflow/SKILL.md): identify the actual project, choose QMD/API/Studio, preserve source and state ownership, separate save/sync/render, and stop unsafe mutations.
- [`agent-api.md`](skills/quarto-bento-workflow/references/agent-api.md): snapshot/IDs, request envelopes, supported operations, atomic batches, bounded slide creation and refusals.
- [`authoring-components.md`](skills/quarto-bento-workflow/references/authoring-components.md): new-source branch, stable IDs, supported components and authoring limits.
- [`sync-and-recovery.md`](skills/quarto-bento-workflow/references/sync-and-recovery.md): operation effects, execution permissions, plan review, Studio, capture, recovery and verification.

Each reference records the product revision it describes and links to immutable source documentation. It is usable without the product's development checkout. Check the installed application version before applying it to another release.

## Use and Local Development

With the skill available to the agent, a request can be as simple as:

> Use Quarto-Bento to update this presentation while preserving its design and pending edits.

Codex can explicitly invoke `$quarto-bento-workflow`; optional `agents/openai.yaml` describes that interface. Substantive instructions are shared with other agents, and do not require a particular MCP server or terminal manager. Automatic selection must be tested, not assumed.

To test the unpublished plugin in Codex, use a **separate local development marketplace** pointing at this plugin's directory, following the [repository setup guide](https://github.com/brianmsm/r-workflow-plugins/blob/feeaf6c71b70a1f5cac46b5f723d3ba613ac32e0/docs/agent-setup.md). Adding the public marketplace alone will not install this draft. Claude Code has a matching manifest and can load a local directory via `claude --plugin-dir ./plugins/quarto-bento` from the monorepo root; manifest validity does not imply a Claude behavior test.

The application itself must be available as `qbento`, a portable launcher, or a compatible source checkout. The skill detects which is available; no absolute developer path is embedded. App installation, changes to project configuration, commits and publication remain separately authorized operations.

## Composition, Not Duplication

`quarto-publishing` retains generic authoring, narrative, performance, format configuration and rendering expertise. `r-analytic-core` retains research R coding conventions. They are useful optional companions; this plugin owns only the Bento-specific identity/state/CLI/codec/recovery contract, which stays in force when another capability is consulted. Do not import revealjs styling assumptions into Bento or duplicate existing skills under new names.

Read [architecture](docs/architecture.md), [roadmap](docs/roadmap.md), [validation cases](docs/validation-cases.md) and [initial findings](docs/pilot-findings.md). Raw local tests belong outside the distributable plugin; any validation summary must distinguish application tests, agent behavior, source integrity, rendered output and visual/UI evidence.
