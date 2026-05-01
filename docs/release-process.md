# Release Process

The release process is intentionally lightweight while the repository is early.

Each plugin is versioned independently. Public tags should follow:

```text
<plugin-name>-v<semver>
```

For example:

```text
quarto-publishing-v0.1.0
```

During local development, `.agents/plugins/marketplace.json` may point to local paths such as `./plugins/quarto-publishing`. For publication, marketplace entries can be updated to point to Git tags or other stable release sources.

Before releasing a plugin:

- update the plugin `CHANGELOG.md`;
- update `.codex-plugin/plugin.json`;
- validate included skills;
- create the plugin-specific Git tag.

Future release automation should be added only when repeated manual steps make it worthwhile.
