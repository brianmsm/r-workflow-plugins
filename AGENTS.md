# Agent Instructions

These instructions apply to agents contributing to this repository.

- Keep repository files in English.
- Prefer simple structures that match the content that exists today.
- Do not create placeholder folders.
- Do not create `references/`, `scripts`, or `assets` unless there is a real need.
- Keep `SKILL.md` files concise and focused on reusable instructions.
- Use only `name` and `description` in skill frontmatter unless another field is truly required.
- Use official plugin and skill creator/validator tooling when available (for example, `$plugin-creator` and `$skill-creator` in Codex).
- Avoid overdesigning the architecture before there is real plugin content to support it.
- Do not duplicate cross-cutting rules unnecessarily across future plugins.
- Keep cross-plugin policy in root docs instead of copying it into each plugin.
- Treat normative Markdown (architecture, guidance, skills and decision documents) as the **current contract**, not a chronology. When a decision changes, inspect the document as a whole and its relevant references; replace, restructure or remove superseded material wherever necessary. Prefer **document-wide consistency over minimal textual patches**, whether the coherent change is small or extensive. Do not append dated overrides to obsolete rules.
- Preserve historical releases in plugin `CHANGELOG.md` files and Git history. Keep dated evidence only in documents explicitly intended as historical validation or research records. Do not create a parallel `NEWS.md` without a distinct justified purpose.

## References

Before changing repository structure, naming conventions, or release/versioning behavior, check:

- `docs/architecture.md`
- `docs/roadmap.md`
- `docs/naming-conventions.md`
- `docs/release-process.md`

Check `git status` before editing; preserve unrelated uncommitted work and keep raw/local QA artifacts out of public releases.

For intentional cross-plugin design choices (interactive research, classroom scripts, temporary QA and scientific slides), see [current design decisions](docs/architecture.md#current-cross-plugin-authoring-decisions) before proposing an apparent consistency fix.

For plugin-specific growth plans, check the plugin's own `docs/architecture.md` and `docs/roadmap.md` when they exist.
