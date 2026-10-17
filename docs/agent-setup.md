# Agent Setup

`r-workflow-plugins` distributes common skill instructions through runtime-specific adapters. **`quarto-publishing v0.2.2` and `r-analytic-core v0.1.0` are available in the public marketplaces**, each pinned to its independent Git release tag. `quarto-bento` is a local `0.0.0` draft requiring a separate development installation; it is not in these public catalogs. Other plugins in the [global roadmap](roadmap.md) remain planned.

Common content lives under `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`, with optional skill-local `references/`, `scripts/`, `assets/`, and `agents/openai.yaml`. Do not copy the same skill body into separate Codex, Claude, or Gemini trees.

## Published Catalog vs Local Development

The catalogs on `main` currently use **Git subdirectory sources pinned to plugin release tags**. The catalog itself may update on `main`, but a pinned plugin source does not install unreleased modifications from `main`. The latest `quarto-publishing` pin is `quarto-publishing-v0.2.2`.

- Codex catalog: `.agents/plugins/marketplace.json`.
- Claude Code catalog: `.claude-plugin/marketplace.json`.
- Plugin-specific Codex metadata: `plugins/<plugin-name>/.codex-plugin/plugin.json` (published: `quarto-publishing`, `r-analytic-core`; local draft: `quarto-bento`).
- Plugin-specific Claude metadata: `plugins/<plugin-name>/.claude-plugin/plugin.json` (published: `quarto-publishing`, `r-analytic-core`; local draft: `quarto-bento`).
- A full Gemini CLI extension would require `plugins/quarto-publishing/gemini-extension.json`; no such adapter has been released.

Importantly, **adding a local clone as a marketplace does not automatically switch a `git-subdir` tag-pinned plugin to working-tree content**. To test unpublished Codex changes, use a temporary local catalog entry with `source: {"source": "local", "path": "./plugins/quarto-publishing"}` rooted in the appropriate local marketplace directory, then restore the release catalog before committing. Alternatively, test skill discovery independently through the development agent's skill-loading facilities. Do not repoint the published catalog to a development branch merely for personal testing.

See [release process](release-process.md) for the publication sequence.

## Codex

Register the public catalog:

```bash
codex plugin marketplace add brianmsm/r-workflow-plugins
```

Install or enable either plugin from the catalog in the Codex app, or from the Codex CLI, for example:

```bash
codex plugin add r-analytic-core@r-workflow-plugins
```

Explicit skill invocation for research-first R coding is `$r-analytic-coding-principles`. As another example, a publishing skill can be invoked with:

```text
$quarto-render-troubleshooting
```

To inspect/refresh registered catalogs, the Codex CLI also provides:

```bash
codex plugin marketplace list
codex plugin marketplace upgrade
```

The published catalog entries are `git-subdir` sources pinned to `quarto-publishing-v0.2.2` and `r-analytic-core-v0.1.0`, not `local` sources. For testing later unpublished changes, keep any developer override separate from these public entries. Users must refresh their catalog/installation according to their runtime to pick up a new plugin or version.

Reference: [OpenAI's plugin packaging and marketplace documentation](https://developers.openai.com/plugins/build/plugins).

## Claude Code

Register the public catalog and install the plugin:

```bash
claude plugin marketplace add brianmsm/r-workflow-plugins
claude plugin install quarto-publishing@r-workflow-plugins
claude plugin install r-analytic-core@r-workflow-plugins
```

Claude Code plugin skills are namespaced, for example:

```text
/quarto-publishing:quarto-render-troubleshooting
/r-analytic-core:r-analytic-coding-principles
```

For testing **working-tree changes** directly from the repository root, use:

```bash
claude --plugin-dir ./plugins/quarto-publishing
```

Claude Code's plugin version resolution gives priority to the version in `.claude-plugin/plugin.json` over any marketplace-level plugin `version`, then falls back to a Git commit when no version is supplied. This repository therefore records each plugin release version in its own manifest and does **not** duplicate that field on marketplace entries. A pinned `git-subdir` `ref` determines which source commit is fetched; the manifest version controls the plugin's displayed release identity. These are distinct concerns.

The `homepage` points to plugin-specific documentation, while `repository` points to the whole monorepo. A `$schema` field is optional editor metadata, not a distribution requirement.

Reference: [Claude Code plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces).

## Gemini CLI

**Native extension distribution is not implemented.** Gemini CLI extensions require a `gemini-extension.json` at the extension root, and `plugins/quarto-publishing/` does not currently contain it. Therefore these commands are **not ready for this repository**:

```bash
# Not supported yet for this plugin directory:
gemini extensions link ./plugins/quarto-publishing
gemini extensions install ./plugins/quarto-publishing
```

However, Gemini CLI supports **standalone Agent Skills**, so individual Quarto skills can be used without turning the plugin into a native extension.

### Link a local skill for development

From the root of a local clone:

```bash
gemini skills link ./plugins/quarto-publishing/skills/quarto-report-design
gemini skills list
```

Repeat the link operation for other skills as needed. For remote installation of a specific skill, Gemini CLI documents `--path` to select a skill subdirectory in a Git repository:

```bash
gemini skills install https://github.com/brianmsm/r-workflow-plugins.git --path plugins/quarto-publishing/skills/quarto-report-design
```

These skill-level methods follow current Gemini CLI documentation but **have not been end-to-end verified for this repository**. They are not equivalent to installing `quarto-publishing` as one native Gemini extension. For a fully pinned test, use a checkout of the desired release tag rather than an in-progress branch when linking locally.

Gemini CLI can also discover skills placed in `~/.gemini/skills/` or the workspace's `.gemini/skills/`, along with their `.agents/skills/` aliases. Do not copy or symlink skills into the public plugin tree just to support an additional runtime.

References: [Gemini CLI Agent Skills](https://geminicli.com/docs/cli/skills/) and [extension reference](https://geminicli.com/docs/extensions/reference/).

## Adding Another Runtime

Before adding a new manifest or installation recipe, verify the target host's actual distribution format, whether it can load these `SKILL.md` directories directly, and how it resolves plugin versions and paths. Support for individual skills should not be described as support for complete plugin installation. Keep host-specific metadata small and leave substantive instructions in shared skill folders.
