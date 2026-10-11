# r-workflow-plugins

`r-workflow-plugins` is a monorepo of portable plugins for AI agents working on R-centered analytical and research workflows. Its broader scope covers programming, applied analysis, psychometrics, simulation, package development, and reproducible publishing.

The repository is **plugin-oriented, not a package of R functions or an agent framework**. A plugin is the independently distributed and versioned unit; a skill is a focused, reusable unit of agent instruction. Shared skills and references should stay portable across agent runtimes where practical, with thin runtime-specific distribution metadata.

## Plugin Map

Only `quarto-publishing` is currently distributed through the public marketplaces. `r-analytic-core` has a **locally tagged `v0.1.0` release**, but is not yet in either public catalog; pushing its tag and updating both marketplaces are separate publication steps. The remaining entries are proposed areas, **not installed plugins or promised releases**; their scope can be refined before implementation.

| Plugin | Responsibility | Status |
| --- | --- | --- |
| [`quarto-publishing`](plugins/quarto-publishing/) | Quarto documents, reports, presentations, configuration, computation strategy, and render verification. Engine-aware across R/knitr, Python/Jupyter, Julia, and prose-only documents. | **Published: v0.2.2** |
| [`r-analytic-core`](plugins/r-analytic-core/) | Research-first R coding: model-by-model editability, intentional repetition, proportional live verification. | **Local release v0.1.0 (not yet marketplace-published)** |
| `r-applied-analysis` | Applied statistical analysis workflows, from descriptive work through regression and related models. | Planned |
| `r-psychometrics` | Measurement, factor analysis, IRT, invariance, DIF, and related psychometric workflows. | Planned |
| `r-simulation-methods` | Data-generating mechanisms, Monte Carlo study design, execution, evaluation, and reporting. | Planned |
| `r-package-development` | R package architecture, APIs, documentation, testing, and release-related practices. | Planned |
| `rmarkdown-workflows` | Classic R Markdown maintenance and workflows; full migration into Quarto belongs primarily to the Quarto plugin. | Planned |

See the [global roadmap](docs/roadmap.md) for candidate scopes and development rules, and the [architecture](docs/architecture.md) for boundaries and responsibilities.

## Installation

### Codex

Register the public marketplace:

```bash
codex plugin marketplace add brianmsm/r-workflow-plugins
```

The published marketplace currently offers `quarto-publishing`; install or enable it from the catalog. A skill can be invoked by name, for example `$quarto-render-troubleshooting`. The separately versioned `r-analytic-core` release will be installable from this catalog only after its release tag is available remotely and its marketplace entry is added.

### Claude Code

```bash
claude plugin marketplace add brianmsm/r-workflow-plugins
claude plugin install quarto-publishing@r-workflow-plugins
```

Plugin skills are namespaced, e.g. `/quarto-publishing:quarto-render-troubleshooting`.

### Gemini CLI

The plugin is **not** yet packaged as a native Gemini extension. Gemini CLI can use individual skills through its skill installation or linking workflow; see the [agent setup guide](docs/agent-setup.md) for the distinction and example commands.

## Repository Layout

- `plugins/<plugin-name>/`: self-contained, independently versioned plugins.
- `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`: focused agent instructions, with optional `references/`, `scripts/`, `assets/`, and agent metadata.
- `.agents/plugins/marketplace.json`: Codex public catalog.
- `.claude-plugin/marketplace.json`: Claude Code public catalog.
- `docs/`: repository-wide [architecture](docs/architecture.md), [roadmap](docs/roadmap.md), [naming conventions](docs/naming-conventions.md), [release policy](docs/release-process.md), and [agent setup](docs/agent-setup.md).
- `AGENTS.md`: instructions for agents contributing to this repository.

The published marketplace entries point to **plugin-specific Git release tags**, not to in-progress changes on `main`. Work-in-progress changes belong in the relevant plugin's `CHANGELOG.md` under `Unreleased` until a new release is ready. See [release process](docs/release-process.md).

For `quarto-publishing` specifically, its own [architecture](plugins/quarto-publishing/docs/architecture.md) describes the mature target and its [roadmap](plugins/quarto-publishing/docs/roadmap.md) describes incremental delivery. The global roadmap is not a substitute for either.
