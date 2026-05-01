# r-workflow-plugins

`r-workflow-plugins` is a monorepo of portable plugins for AI agents that work with R.

Codex is the first consumer, but the repository is designed to stay agent-agnostic where practical. Plugins should package focused instructions and metadata without assuming that every future consumer has the same runtime or interface.

This repository is in an early initialization phase. At the moment, only the `quarto-publishing` plugin is being created.

## Current Plugin

- `quarto-publishing`: workflows for Quarto publishing with R, including documents, analytical reports, websites, books, manuscripts, revealjs slides, `_quarto.yml`, reproducible rendering, and render troubleshooting.

## Repository Shape

- Plugins live in `plugins/<plugin-name>/`.
- Each plugin includes `.codex-plugin/plugin.json`.
- Skills live under each plugin in `skills/<skill-name>/SKILL.md`.
- Codex marketplace metadata lives in `.agents/plugins/marketplace.json`.

The architecture will evolve as real plugin content is added.
