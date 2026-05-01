# Quarto Publishing

`quarto-publishing` is a plugin for Quarto publishing workflows with R.

Its initial scope includes Quarto documents, analytical reports, websites, books, manuscripts, revealjs slides, `_quarto.yml` configuration, render troubleshooting, and reproducible R-based publishing workflows.

This plugin is not focused on classic R Markdown. R Markdown should appear only when migrating to Quarto, comparing behavior, or maintaining interoperability with Quarto projects.

## Structure

- `.codex-plugin/plugin.json`: Codex plugin manifest.
- `docs/architecture.md`: intended mature architecture for the plugin.
- `skills/quarto-publishing-workflow/SKILL.md`: initial workflow skill.
- `skills/quarto-publishing-workflow/agents/openai.yaml`: OpenAI-facing skill metadata.

The plugin is in an early state and should stay small until real publishing workflows require more structure.

For the intended mature architecture of this plugin, see [`docs/architecture.md`](docs/architecture.md).
