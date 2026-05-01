# Agent Instructions

These instructions apply to Codex work in this repository.

- Keep repository files in English.
- Prefer simple structures that match the content that exists today.
- Do not create placeholder folders.
- Do not create `references/`, `scripts`, or `assets` unless there is a real need.
- Keep `SKILL.md` files concise and focused on reusable instructions.
- Use only `name` and `description` in skill frontmatter unless another field is truly required.
- Prioritize `$plugin-creator` and `$skill-creator` when creating or updating plugins and skills.
- Avoid overdesigning the architecture before there is real plugin content to support it.
- Do not duplicate cross-cutting rules unnecessarily across future plugins.
- Keep cross-plugin policy in root docs instead of copying it into each plugin.

## References

Before changing repository structure, naming conventions, or release/versioning behavior, check:

- `docs/architecture.md`
- `docs/naming-conventions.md`
- `docs/release-process.md`

For plugin-specific growth plans, check the plugin's own `docs/architecture.md` and `docs/roadmap.md` when they exist.
