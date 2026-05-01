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

## Version Field Policy

Use the same versioning policy for every plugin:

- During the initial scaffold, set `.codex-plugin/plugin.json` to `0.0.0`.
- Do not create a public tag for scaffold-only `0.0.0` plugin states.
- For the first usable release, update `plugin.json` to `0.1.0` in the release commit.
- Tag the first usable release as `<plugin-name>-v0.1.0`.
- For patch releases, update `plugin.json` to the released patch version, for example `0.1.1`, and tag `<plugin-name>-v0.1.1`.
- During later feature development, keep `plugin.json` at the latest released version until the next release commit.
- Track unreleased work in the plugin `CHANGELOG.md` under `## [Unreleased]`.
- When the next release is ready, move the relevant changelog entries from `Unreleased` to the new version section, update `plugin.json`, and create the plugin-specific tag.

Avoid pre-release versions such as `0.2.0-alpha.0` unless the project intentionally wants to publish and support a pre-release build.

Example cycle:

```text
Phase 0 scaffold:
  plugin.json: 0.0.0
  public tag: none

Phase 1 usable release:
  plugin.json: 0.1.0
  tag: quarto-publishing-v0.1.0

Patch release:
  plugin.json: 0.1.1
  tag: quarto-publishing-v0.1.1

Development toward 0.2.0:
  plugin.json: 0.1.1
  changelog: ## [Unreleased]

Release 0.2.0:
  plugin.json: 0.2.0
  tag: quarto-publishing-v0.2.0
```

Recommended changelog shape:

```markdown
## [Unreleased]

### Added

- Initial split of multiformat compatibility guidance.
- Draft migration workflow from R Markdown to Quarto.

## [0.1.0]

- First functional release.
```

Before releasing a plugin:

- update the plugin `CHANGELOG.md`;
- update `.codex-plugin/plugin.json`;
- validate included skills;
- create the plugin-specific Git tag.

Future release automation should be added only when repeated manual steps make it worthwhile.
