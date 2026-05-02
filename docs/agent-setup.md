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

Do not add adapter folders for other agents until there is a real, documented plugin or marketplace format to support.

## Codex

Codex reads the repo marketplace at:

```text
.agents/plugins/marketplace.json
```

The current Codex marketplace exposes:

```text
./plugins/quarto-publishing
```

The Codex plugin manifest is:

```text
plugins/quarto-publishing/.codex-plugin/plugin.json
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

Claude plugin and marketplace manifests intentionally omit explicit plugin versions while this repository is distributed from Git. Claude Code can then use the source commit SHA for update detection. If explicit Claude plugin versions are added later, bump them only in release commits and avoid declaring conflicting versions in both the marketplace and the plugin manifest.
