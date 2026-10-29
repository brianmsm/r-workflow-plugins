# Agent Setup

Plugins contain shared `skills/<skill>/SKILL.md` instructions and only the adapters required by their supported hosts. Versions and tag pins are authoritative in plugin manifests and the public catalogs; see the [plugin map](../README.md) and [release process](release-process.md).

## Codex

Register the catalog once, then refresh it before installing new releases:

```sh
codex plugin marketplace add brianmsm/r-workflow-plugins
codex plugin marketplace upgrade r-workflow-plugins
codex plugin add r-data-wrangling@r-workflow-plugins
codex plugin add r-applied-analysis@r-workflow-plugins
codex plugin add r-psychometrics@r-workflow-plugins
codex plugin add r-simulation-methods@r-workflow-plugins
codex plugin list
```

Skip registration if that marketplace already exists. Plugin skills are exposed through native discovery; an explicit request can name the qualified skill, such as `$r-psychometrics:r-cfa-sem`. Natural-language selection is host/model-dependent. The Codex adapter is `.codex-plugin/plugin.json`; the catalog is `.agents/plugins/marketplace.json`.

The catalog uses Git subdirectories pinned to independent plugin tags. Adding a working clone as a marketplace does not override those source pins. Use a separate temporary local-path catalog for development, never change public pins to test a working tree.

Reference: [OpenAI plugin documentation](https://developers.openai.com/codex/plugins/).

## Claude Code

Use the existing registered marketplace or register it once:

```sh
claude plugin marketplace add brianmsm/r-workflow-plugins
claude plugin marketplace update r-workflow-plugins
claude plugin install --scope user r-data-wrangling@r-workflow-plugins
claude plugin install --scope user r-applied-analysis@r-workflow-plugins
claude plugin install --scope user r-psychometrics@r-workflow-plugins
claude plugin install --scope user r-simulation-methods@r-workflow-plugins
claude plugin list --json
```

Use a fresh session after installation. Invoke `/r-psychometrics:r-cfa-sem`, for example. For source-only development, `claude --plugin-dir ./plugins/r-psychometrics` loads that directory for the current session without installing it globally.

The adapter is `.claude-plugin/plugin.json`; the catalog is `.claude-plugin/marketplace.json`. The pinned source ref determines the fetched code; the plugin manifest records its displayed version. Do not duplicate plugin versions at marketplace level.

If the shell command is a custom version-manager wrapper, inspect it before automated testing. Use the already installed binary directly when merely requesting help must not change a global version choice. Installing plugins does not require installing or updating the agent binary.

Reference: [Claude Code marketplaces](https://code.claude.com/docs/en/plugin-marketplaces).

## Antigravity CLI

The four initial research-methods plugins include `.antigravity-plugin/plugin.json`. They share the same skill bodies and resource files as Codex and Claude. Native compatibility was tested with `agy 1.4.10`; this does not imply native Gemini CLI extension support.

The CLI accepts a local plugin directory. To install an exact release from an existing Git clone without changing its working branch, extract only the committed plugin payload into a new directory:

```sh
stage=$(mktemp -d)
git archive r-data-wrangling-v0.1.0 plugins/r-data-wrangling | tar -x -C "$stage"
agy plugin validate "$stage/plugins/r-data-wrangling" --strict
agy plugin install "$stage/plugins/r-data-wrangling"
agy plugin list --json
```

Repeat with the corresponding plugin name/tag for the other three releases. Retain the staged directory if needed for provenance; do not package ignored simulation output from a working directory. Use the installation location reported by `agy plugin list --json`; do not assume that a workspace test directory or a historical profile layout is the global install root. Global installation was verified with CLI 1.4.10, not with the IDE interface.

Antigravity's named remote marketplace syntax currently targets its official marketplace, not this repository's Codex/Claude catalog alias. Do not assume `plugin@r-workflow-plugins` is supported. Installation from a pinned local extraction avoids ambiguity about a monorepo URL or Git subdirectory.

Invoke `/r-applied-analysis:r-survey-analysis` for a packaged skill. A workspace-local test can instead place full plugins in `.agents/plugins/`. Individual complete skill folders can be placed in `.agents/skills/`, but this tests standalone skill loading rather than native plugin installation.

References: [plugin authoring](https://antigravity.google/docs/build-plugins/), [CLI plugin installation](https://antigravity.google/docs/plugins?tab=cli), and [marketplace contract](https://antigravity.google/docs/marketplace).

## Gemini CLI and Other Hosts

No `gemini-extension.json` adapter is distributed. A host's support for standalone Agent Skills is not proof that it installs the full plugin. The Antigravity CLI evaluation does not certify Gemini CLI, another model or another version.

Keep a skill's complete folder, including conditional references and assets. Local resource links in the new research skills stay inside that folder; optional developer-evidence links point to public tagged source. Do not create separate copies of the same instructions for each agent or make a sibling plugin an implicit dependency.

## Verification Boundaries

Check discovery, actual skill/reference reads and output behavior separately. Keep test workspaces and raw transcripts out of public releases; never bundle credentials or private user configuration. See [release evidence](research-methods-release-evidence.md) for the sampled native-host coverage and remaining limits.
