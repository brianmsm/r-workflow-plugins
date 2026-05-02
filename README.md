# r-workflow-plugins

`r-workflow-plugins` is a monorepo of portable plugins for AI agents that work with R.

Codex is the first consumer, but the repository is designed to stay agent-agnostic where practical. Plugins should package focused instructions and metadata without assuming that every future consumer has the same runtime or interface.

This repository is in an early initialization phase. At the moment, only the `quarto-publishing` plugin is being created.

## Current Plugin

- `quarto-publishing`: Quarto-first publishing workflows for analytical and research-oriented documents, including R/knitr, Python/Jupyter, Julia, and prose-only projects.

## Installation

### Codex

Codex is the primary supported path for this repository.

Add the marketplace from the Codex CLI:

```bash
codex plugin marketplace add brianmsm/r-workflow-plugins
```

Then install or enable the `quarto-publishing` plugin from that marketplace in the Codex app, the Codex VS Code extension, or from Codex with `/plugins`.

Codex skills can be invoked by name, for example:

```text
$quarto-render-troubleshooting
```

Local development details are in [`docs/agent-setup.md`](docs/agent-setup.md).

### Claude Code

Claude Code is also currently supported.

Marketplace installation can use:

```bash
claude plugin marketplace add brianmsm/r-workflow-plugins
claude plugin install quarto-publishing@r-workflow-plugins
```

Claude Code namespaces plugin skills as:

```text
/quarto-publishing:<skill-name>
```

For example:

```text
/quarto-publishing:quarto-render-troubleshooting
```

### Gemini CLI

Gemini CLI support is experimental and local-only for now. Remote installation from the GitHub monorepo subdirectory is not currently the primary supported path.

See [`docs/agent-setup.md`](docs/agent-setup.md) for the current Gemini CLI limitations and local workarounds.

## Repository Shape

- Plugins live in `plugins/<plugin-name>/`.
- Each plugin can include agent-specific manifests such as `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json`.
- Skills live under each plugin in `skills/<skill-name>/SKILL.md`.
- Codex marketplace metadata lives in `.agents/plugins/marketplace.json`.
- Claude Code marketplace metadata lives in `.claude-plugin/marketplace.json`.
- Gemini CLI support may require a future `gemini-extension.json` adapter, but no native Gemini distribution adapter is committed yet.

The architecture will evolve as real plugin content is added.

For setup details by agent runtime, see [`docs/agent-setup.md`](docs/agent-setup.md).
