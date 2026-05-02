# Architecture

`r-workflow-plugins` is a monorepo for portable AI-agent plugins that support R workflows.

The architecture is intentionally small and evolutionary. Each plugin is the unit of distribution, and each skill is the unit of reusable instruction. Codex is the first consumer, but plugin content should avoid unnecessary Codex-only assumptions where a portable convention is reasonable.

## Plugin Layout

Each plugin lives in `plugins/<plugin-name>/` and includes:

- `.codex-plugin/plugin.json`
- `.claude-plugin/plugin.json` when Claude Code support is enabled
- optional `skills/<skill-name>/SKILL.md`
- plugin-level documentation when useful

Do not add empty architecture folders before there is real content for them.

Plugin-level architecture documents may describe the intended mature design for a specific plugin. For example, `plugins/quarto-publishing/docs/architecture.md` describes where the `quarto-publishing` plugin should grow, while `plugins/quarto-publishing/docs/roadmap.md` can describe the gradual path toward that design.

## Marketplace

During development, `.agents/plugins/marketplace.json` can point to local plugin paths such as `./plugins/quarto-publishing`. Claude Code support uses `.claude-plugin/marketplace.json` with the same shared plugin content.

Published entries may point to Git tags or other release sources later.

Future plugins will be designed in separate threads once their scope is concrete.
