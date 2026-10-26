# Quarto Publishing

`quarto-publishing` is a Quarto-first, engine-aware plugin for publishing workflows.

Its scope includes Quarto documents, analytical reports, websites, books, manuscripts, revealjs slides, `_quarto.yml` configuration, render troubleshooting, and reproducible publishing workflows that may use R/knitr, Python/Jupyter, Julia, or prose-only Quarto documents.

Because this plugin lives in `r-workflow-plugins`, examples may emphasize R/knitr. The skills should still avoid assuming R when the user's files or project configuration indicate Python, Julia, Jupyter, or prose-only authoring.

This plugin is not focused on classic R Markdown. R Markdown should appear only when migrating to Quarto, comparing behavior, or maintaining interoperability with Quarto projects.

**Agent plugin version:** `0.2.3` in the Codex and Claude manifests; distribution is determined by its independent `quarto-publishing-v0.2.3` tag and pinned marketplace entries, not by the version field alone. Six skills are implemented, including on-demand pedagogical communication and slide-design references within `quarto-report-design`. The architecture proposes ten target skills; planned skills are not available merely because they appear there. Reveal.js animation instructions belong to its output-format reference, not to Bento.

## Implemented Structure

- `.codex-plugin/plugin.json`: Codex plugin manifest.
- `.claude-plugin/plugin.json`: Claude Code plugin manifest.
- `assets/`: Codex interface icon and logo assets.
- `docs/architecture.md`: intended mature architecture for the plugin.
- `docs/roadmap.md`: staged plan for growing toward the intended architecture.
- `skills/quarto-authoring-core/SKILL.md`: Quarto `.qmd` authoring and review skill.
- `skills/quarto-project-configuration/SKILL.md`: Quarto project configuration review skill.
- `skills/quarto-format-configuration/SKILL.md`: Quarto output format configuration review skill.
- `skills/quarto-report-design/SKILL.md`: Quarto report structure and analytical communication design skill.
- `skills/quarto-computation-performance/SKILL.md`: Quarto computation, cache, freeze, and long-render strategy skill.
- `skills/quarto-render-troubleshooting/SKILL.md`: Quarto render failure and output verification troubleshooting skill.
- `skills/*/agents/openai.yaml`: OpenAI-facing skill metadata.

The plugin remains under active development. New skills, scripts, and templates should be introduced only when repeated use and testing justify them.

For the intended mature architecture of this plugin, see [`docs/architecture.md`](docs/architecture.md).
For the staged implementation plan, see [`docs/roadmap.md`](docs/roadmap.md).
