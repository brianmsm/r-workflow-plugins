# Agent Setup

`r-workflow-plugins` keeps plugin content portable and adds small metadata adapters for each agent runtime.

Shared content lives in:

- `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`
- `plugins/<plugin-name>/skills/<skill-name>/references/`

Agent-specific metadata lives in:

- `.agents/plugins/marketplace.json` for Codex.
- `.claude-plugin/marketplace.json` for Claude Code.
- `plugins/<plugin-name>/.codex-plugin/plugin.json` for Codex.
- `plugins/<plugin-name>/.claude-plugin/plugin.json` for Claude Code.
- `plugins/<plugin-name>/skills/<skill-name>/agents/openai.yaml` for OpenAI-facing skill UI metadata.
- Possible future `gemini-extension.json` files for Gemini CLI, once a supported distribution shape is chosen.

Do not add adapter folders for other agents until there is a real, documented plugin or marketplace format to support.

## Codex

Codex can add this public marketplace from the CLI:

```bash
codex plugin marketplace add brianmsm/r-workflow-plugins
```

Codex reads the repo marketplace at:

```text
.agents/plugins/marketplace.json
```

The current Codex marketplace exposes:

```text
./plugins/quarto-publishing
```

For local development, clone or open this repository in Codex, use the repo-scoped marketplace at `.agents/plugins/marketplace.json`, and install or enable the `quarto-publishing` plugin from that local marketplace.

The Codex plugin manifest is:

```text
plugins/quarto-publishing/.codex-plugin/plugin.json
```

Codex users can install or enable plugins from the Codex app, the Codex VS Code extension, or from Codex with `/plugins`.

Codex skills can be invoked by name when needed:

```text
$quarto-render-troubleshooting
```

## Claude Code

Claude Code reads the repo marketplace at:

```text
.claude-plugin/marketplace.json
```

Claude plugin manifests live inside each plugin:

```text
plugins/quarto-publishing/.claude-plugin/plugin.json
```

Claude Code namespaces plugin skills as:

```text
/quarto-publishing:<skill-name>
```

For example:

```text
/quarto-publishing:quarto-render-troubleshooting
```

Local testing can use:

```bash
claude --plugin-dir ./plugins/quarto-publishing
```

Marketplace installation can use:

```bash
claude plugin marketplace add brianmsm/r-workflow-plugins
claude plugin install quarto-publishing@r-workflow-plugins
```

Claude plugin and marketplace manifests currently pin `quarto-publishing` to the public plugin release version. Keep `.claude-plugin/marketplace.json`, `plugins/quarto-publishing/.claude-plugin/plugin.json`, and the Codex manifest version aligned in release commits.

## Gemini CLI

Gemini CLI support is experimental and local-only for now.

Gemini CLI extensions currently expect the extension root to contain:

```text
gemini-extension.json
```

In this monorepo, each plugin lives under:

```text
plugins/<plugin-name>/
```

That means remote installation from a GitHub subdirectory is not currently a reliable supported path for this repository.

Do not recommend this as a working installation command:

```bash
gemini extensions install https://github.com/brianmsm/r-workflow-plugins/tree/main/plugins/quarto-publishing
```

That URL points to a GitHub web page for a subdirectory, not to a standalone extension root. Gemini CLI currently documents `gemini extensions install <source>` for a Git repository URL or a local path, but it does not document a `--subdir`, `--path`, or `git-subdir` style option for installing an extension rooted inside a monorepo. Gemini CLI would need to treat `plugins/quarto-publishing/` as the extension root, while current extension installation is oriented around the source root.

Relevant upstream issues:

- `google-gemini/gemini-cli#25676`: [Support installing extensions from a Git repository subdirectory](https://github.com/google-gemini/gemini-cli/issues/25676)
- `google-gemini/gemini-cli#7808`: [Allow specifying a ref and path for Git-installed extensions](https://github.com/google-gemini/gemini-cli/issues/7808)

### Workaround A: Clone And Link The Plugin Directory

This is the preferred local workaround during development:

```bash
git clone https://github.com/brianmsm/r-workflow-plugins
cd r-workflow-plugins
gemini extensions link plugins/quarto-publishing
```

This treats `plugins/quarto-publishing` as the local extension root during development. Changes made in the checked-out plugin directory remain visible through the linked extension.

### Workaround B: Clone And Install A Local Copy

To install a local copy instead of linking the development directory:

```bash
git clone https://github.com/brianmsm/r-workflow-plugins
cd r-workflow-plugins
gemini extensions install ./plugins/quarto-publishing
```

This installs from the local plugin directory rather than from a GitHub subdirectory URL.

### Workaround C: Copy Skills Manually

The most portable part of the plugin is the skill content under:

```text
plugins/quarto-publishing/skills/
```

As a lower-level fallback, a user can manually copy relevant skill folders into a Gemini-recognized skills or extension structure. This is mainly useful when adapting skills from Codex or Claude Code workflows before a native Gemini distribution path is finalized.

Do not present Gemini CLI as fully supported yet. Use wording such as experimental, local workaround, not currently the primary supported remote installation path, and pending upstream support for Git subdirectory extension installation.
