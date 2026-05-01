# Naming Conventions

The naming conventions are intentionally brief and may evolve as more plugins are added.

- Plugin names use lowercase hyphen-case, for example `quarto-publishing`.
- Skill names use lowercase hyphen-case and should describe a reusable workflow, for example `quarto-publishing-workflow`.
- Plugin folders live at `plugins/<plugin-name>/`.
- Skill folders live at `plugins/<plugin-name>/skills/<skill-name>/`.
- Public release tags follow `<plugin-name>-v<semver>`, for example `quarto-publishing-v0.1.0`.

Each plugin has independent versioning. Other planned plugins should be named and designed in separate threads when their real scope is known.
