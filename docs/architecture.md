# Architecture

`r-workflow-plugins` is a monorepo of portable agent plugins for analytical, research, and publishing workflows, centered on R without forcing every domain-specific tool to be R-only. It is not an R package or an agent runtime.

## Responsibilities and Boundaries

- **Monorepo:** common catalog, repository policy, and documentation. It does not impose a shared runtime on all plugins.
- **Plugin:** unit of distribution, versioning, release, and independently usable workflow scope, stored under `plugins/<plugin-name>/`.
- **Skill:** unit of focused agent instruction and task activation, under `skills/<skill-name>/SKILL.md`. Its description should make its activation boundary clear.
- **Skill resources:** `references/` for detailed guidance, `scripts/` for justified deterministic helpers, `assets/` for genuinely reusable artifacts; omit unused directories.
- **Agent adapters:** runtime-specific manifests, marketplace entries, and optional skill UI metadata. Shared instructions should not be copied for each supported agent.

These are **responsibility boundaries, not a mandatory inheritance or dependency chain**. An agent can combine relevant skills from different plugins. Each plugin should still be usable on its own; a core plugin may help others, but should not become an installation prerequisite without a demonstrated need.

### Planned Domain Separation

- `r-analytic-core`: how to work with analytical R code; not a replacement for statistical procedures.
- `r-applied-analysis`: applied analysis decisions and workflows; specialized measurement models belong to `r-psychometrics`.
- `r-psychometrics`: measurement-oriented methods and diagnostics; reusable Monte Carlo infrastructure belongs to `r-simulation-methods`.
- `r-simulation-methods`: generating conditions/replications and evaluating operating characteristics, including psychometric simulations when a simulation is the principal task.
- `r-package-development`: R package engineering and maintenance, not general data analysis.
- `quarto-publishing`: Quarto authoring, reports, formats, projects, slides, rendering, and delivery. The primary engine is detected from the actual project (R, Python, Julia, or prose-only), not assumed.
- `quarto-bento`: an independently distributed companion for the Quarto-Bento application: project identity, CLI/API/Studio operations, retained visual state, reviewed synchronization and recovery. Generic Quarto skills remain optional companions, not duplicates.
- `rmarkdown-workflows`: maintaining classic R Markdown projects and outputs; when converting them to Quarto, `quarto-publishing` owns the migration target.

The domain map is provisional; see [global roadmap](roadmap.md). The catalogs list `quarto-publishing`, `r-analytic-core` and `quarto-bento` with **independent tag-pinned versions**. `r-analytic-core` provides one core skill; `quarto-bento` provides one workflow skill with three operational references. Current versions and source refs belong in plugin manifests and marketplaces, not duplicated as release state throughout this document. The remaining candidates have not been scaffolded; avoid creating new plugins before their boundaries and initial skills are reviewed.

## Plugin Layout

Plugins live at `plugins/<plugin-name>/`. The currently implemented plugin includes:

```text
plugins/quarto-publishing/
├── .codex-plugin/plugin.json
├── .claude-plugin/plugin.json
├── skills/<skill-name>/SKILL.md
├── README.md
├── CHANGELOG.md
├── docs/architecture.md
└── docs/roadmap.md
```

Agent manifests and resources are added only for actually supported capabilities. Skill-level `agents/openai.yaml` and `references/` are present in the current plugin; `scripts/` or `assets/` require concrete uses, not empty scaffolds. See `AGENTS.md` and [naming conventions](naming-conventions.md).

Plugin-specific architecture documents describe an **intended mature scope**; plugin-specific roadmaps describe an **incremental path**. Neither should be confused with functionality that has already shipped. For the working example, see [`quarto-publishing` architecture](../plugins/quarto-publishing/docs/architecture.md) and its [roadmap](../plugins/quarto-publishing/docs/roadmap.md).

## Distribution and Release Boundaries

- Codex public marketplace: `.agents/plugins/marketplace.json`.
- Claude Code public marketplace: `.claude-plugin/marketplace.json`.
- Plugin-specific manifests: `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json` where enabled.
- Published plugin entries currently use Git subdirectory sources pinned to plugin-specific release tags (`<plugin-name>-v<semver>`).
- Working on `main` or updating a plugin's `Unreleased` changelog does **not** change what a tag-pinned install receives.
- Local development may use a temporary local-path marketplace; it must not replace the released catalog unintentionally.
- Gemini CLI can consume individual compatible skills; a native Gemini extension requires a dedicated `gemini-extension.json` adapter that is not yet included.

See [release process](release-process.md) and [agent setup](agent-setup.md) for operational details.

## Evolution Rules

Keep `SKILL.md` instruction-first; use references on demand. Prefer improving activation/handoff rules and testing actual tasks before adding routers, new skills, scripts, templates, or new host adapters. Maintain sanitized evidence of reusable lessons, and keep private/raw testing artifacts out of released plugins.
