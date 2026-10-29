# Release Process

The release process is intentionally lightweight. **`quarto-publishing`, `r-analytic-core` and `quarto-bento`** have independently versioned, tag-pinned entries in both catalogs. Actual published versions are determined by each remote `source.ref`, not by local manifests alone; other plugin names remain plans.

Each plugin is versioned independently. Public tags should follow:

```text
<plugin-name>-v<semver>
```

For example:

```text
quarto-publishing-v0.1.0
```

The **published** `.agents/plugins/marketplace.json` and `.claude-plugin/marketplace.json` currently point to Git subdirectory sources pinned to plugin-specific release tags. A temporary local-path catalog is suitable for developer testing, but it must not replace the published tag pin. Merely adding the checkout as a marketplace does not override the catalog's remote tag-pinned source.

Claude Code marketplaces live in `.claude-plugin/marketplace.json`. Keep the marketplace as a catalog and avoid declaring per-plugin `version` fields there unless there is a deliberate release-channel reason. For plugins with Claude support, `plugins/<plugin-name>/.claude-plugin/plugin.json` is the Claude-side source of truth for that plugin's release version.

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
- For plugins with Claude support, update `plugins/<plugin-name>/.claude-plugin/plugin.json` to the same released plugin version and avoid duplicating that version in the root Claude marketplace.
- For plugins with Antigravity support, update `plugins/<plugin-name>/.antigravity-plugin/plugin.json` to that same version and validate it with the target CLI. Its existence does not migrate other manifest formats.

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

## Release Sequence

Keep unreleased work under `CHANGELOG.md` → `[Unreleased]`, without changing the released `version` fields or published marketplace pins. A normal commit on `main` is **not** a plugin release.

Before releasing a plugin:

- update the plugin `CHANGELOG.md`;
- update `.codex-plugin/plugin.json`;
- review any agent-specific manifests and marketplaces;
- validate included skills;
- create the plugin-specific Git tag at the commit containing the validated release manifests and changelog.

After creating a plugin release tag:

- push the release commit and tag to the remote and verify that the referenced tag exists both locally and on the remote;
- only after that, add or update the entries in `.agents/plugins/marketplace.json` and `.claude-plugin/marketplace.json` with `source.ref` pinned to `<plugin-name>-v<semver>`, then commit and push the catalog change;
- keep plugin release versions in plugin manifests, not duplicated as marketplace `version` fields, unless there is a deliberate release-channel reason.

**Atomic publication alternative:** when the remote supports `git push --atomic`, a local catalog commit can follow the independently tagged release commits and **branch plus new tags** can be pushed together atomically. Verify remote branch and peeled tag targets first; on failure, do not advertise the catalog pin as public. Otherwise use the two-phase remote-tag-first sequence above. The catalog commit must never move the release tags.

Do not move or reuse release tags to point to a newer development commit. The catalog commit that advances `source.ref` can follow the plugin-tagged commit, as already done for `quarto-publishing-v0.2.2`. Consumers must refresh their catalog/installation according to their agent runtime to receive an updated pin; modifying `main` alone does not publish a new plugin version.

Future release automation should be added only when repeated manual steps make it worthwhile.
