---
name: quarto-project-configuration
description: Use when designing or reviewing shared Quarto project configuration, including _quarto.yml, _metadata.yml, shared metadata, project profiles, parameters, render targets, project types, engine-aware execution settings, and document-vs-project YAML placement. Do not use for single-document authoring, format-specific output styling, deployment, CI, custom extensions, performance architecture, or deep render troubleshooting.
---

# Quarto Project Configuration

Use this skill for the project layer of a Quarto workflow, especially `_quarto.yml`, `_metadata.yml`, shared YAML defaults, project profiles, project type, render targets, parameters, bibliography or citation defaults, and organization across multiple `.qmd` files.

## Operating Principles

- Treat `_quarto.yml` as the shared project configuration layer, not as a dumping ground for every document preference.
- Keep document YAML in `.qmd` files when the option is truly local to one document.
- Move repeated YAML into `_quarto.yml` or directory-level `_metadata.yml` when it improves maintainability.
- Respect Quarto metadata precedence: document YAML overrides directory metadata, which overrides project metadata.
- Use `_metadata.yml` for directory-specific defaults, such as defaults for reports, posts, slides, or notebooks in one folder.
- Use project profiles only when the project genuinely needs alternate configurations, such as development vs production, local vs CI, or different versions of the same project.
- Treat project-level `execute`, `freeze`, `render`, `output-dir`, `resources`, and `execute-dir` as high-impact settings that require conservative review.
- Do not assume every computational project uses knitr. Check whether the project uses `jupyter`, `engine: julia`, `.ipynb`, `.py`, `.jl`, `.r`, or `.qmd` files before recommending execution, cache, or environment settings.
- Keep format-specific styling and output behavior shallow here; defer detailed HTML, PDF, DOCX, revealjs, PowerPoint, Beamer, Typst, CSS, templates, and extension decisions to `quarto-format-configuration`.
- Prefer minimal, reversible edits and explain why a setting belongs at project, directory, or document level.

## Review Checklist

When reviewing Quarto project configuration, check:

1. The project type is clear, especially for common/core project types such as `default`, `website`, `book`, `manuscript`, or no project.
2. `_quarto.yml` exists when project-level behavior is needed and its `project:` block is appropriate.
3. Repeated document YAML is centralized only when centralization improves maintainability.
4. Directory-specific defaults would be clearer in `_metadata.yml` when they apply to one folder.
5. Document-level YAML overrides project or directory defaults intentionally.
6. Render targets are explicit enough without being brittle.
7. `output-dir`, `resources`, and ignored files are consistent with the repository layout.
8. Shared bibliography, CSL, language, cross-reference, and citation defaults belong at project level.
9. Parameters represent legitimate report variation rather than hidden global state.
10. Profiles are justified, named clearly, and limited to real alternate configurations.
11. Project-level `execute`, `freeze`, and working-directory settings are safe for collaboration.
12. Format-specific customization is not being reviewed in depth here when it belongs to `quarto-format-configuration`.

## References

For compact examples for `_quarto.yml`, `_metadata.yml`, metadata precedence, profiles, parameters, render targets, output directories, and project-level `freeze`, read `references/quarto-project-configuration.md` when editing or reviewing concrete project configuration.

## Anti-Scope

Do not redesign `.qmd` prose or authoring syntax unless needed to explain configuration placement.

Do not deeply tune output formats, templates, themes, CSS, LaTeX, Typst, DOCX reference documents, revealjs, PowerPoint, Beamer, or custom formats.

Do not design deployment, hosting, GitHub Pages, Netlify, Posit Connect, CI, or publishing pipelines.

Do not use this skill as the primary guide for Quarto extensions, Lua filters, brand extensions, project templates, scripts, assets, or validators. Route those requests to the relevant format, authoring, troubleshooting, or future extension/template scope unless they are only being classified as project-configuration boundaries.

Do not solve long-running computation architecture beyond conservative project-level `freeze` guidance.

Do not perform deep render troubleshooting after failures.
