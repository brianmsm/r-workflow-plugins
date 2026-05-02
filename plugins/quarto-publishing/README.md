# Quarto Publishing

`quarto-publishing` is a Quarto-first, engine-aware plugin for publishing workflows.

Its initial scope includes Quarto documents, analytical reports, websites, books, manuscripts, revealjs slides, `_quarto.yml` configuration, render troubleshooting, and reproducible publishing workflows that may use R/knitr, Python/Jupyter, Julia, or prose-only Quarto documents.

Because this plugin lives in `r-workflow-plugins`, examples may emphasize R/knitr. The skills should still avoid assuming R when the user's files or project configuration indicate Python, Julia, Jupyter, or prose-only authoring.

This plugin is not focused on classic R Markdown. R Markdown should appear only when migrating to Quarto, comparing behavior, or maintaining interoperability with Quarto projects.

## Structure

- `.codex-plugin/plugin.json`: Codex plugin manifest.
- `docs/architecture.md`: intended mature architecture for the plugin.
- `docs/roadmap.md`: staged plan for growing toward the intended architecture.
- `skills/quarto-authoring-core/SKILL.md`: Quarto `.qmd` authoring and review skill.
- `skills/quarto-project-configuration/SKILL.md`: Quarto project configuration review skill.
- `skills/quarto-format-configuration/SKILL.md`: Quarto output format configuration review skill.
- `skills/quarto-report-design/SKILL.md`: Quarto report structure and analytical communication design skill.
- `skills/quarto-computation-performance/SKILL.md`: Quarto computation, cache, freeze, and long-render strategy skill.
- `skills/quarto-render-troubleshooting/SKILL.md`: Quarto render failure and output verification troubleshooting skill.
- `skills/*/agents/openai.yaml`: OpenAI-facing skill metadata.

The plugin is in an early state and should stay small until real publishing workflows require more structure.

For the intended mature architecture of this plugin, see [`docs/architecture.md`](docs/architecture.md).
For the staged implementation plan, see [`docs/roadmap.md`](docs/roadmap.md).
