# Quarto Project Configuration Reference

Use these compact patterns when reviewing or editing Quarto project configuration. Prefer the official project conventions already present in the user's repository.

## Minimal `_quarto.yml`

Use `_quarto.yml` for shared project metadata and project-level behavior:

```yaml
project:
  type: default
  render:
    - "*.qmd"
    - "!drafts/"

title: "Analysis Project"
bibliography: references.bib
format:
  html: default
```

Keep the file small at first. Add project-level defaults only when more than one document benefits from them.

## Project, Directory, and Document Metadata

Quarto merges metadata from project, directory, and document layers. Use this placement rule:

- `_quarto.yml`: shared defaults for the whole project.
- `_metadata.yml`: defaults for one directory and its documents.
- document YAML: options that belong only to one `.qmd`.

Document YAML has the highest priority, followed by directory metadata, then project metadata.

One important boundary: document-level metadata generally overrides directory and project metadata, but `format` is special. If document-level YAML defines `format`, it should define the complete intended list of formats for that document rather than assuming it only patches the project-level format list.

## Directory Defaults With `_metadata.yml`

Use `_metadata.yml` when a folder has common defaults:

```yaml
format:
  html:
    toc: true
execute:
  warning: false
  message: false
bibliography: ../references.bib
```

This is useful for folders such as `reports/`, `posts/`, `slides/`, or `notebooks/` when those documents share defaults that should not apply to the whole project.

## Project Profiles

Use profiles when the same project needs different configuration for real scenarios such as development, production, local work, CI, or alternate versions.

Base `_quarto.yml`:

```yaml
project:
  type: website
  output-dir: _site

execute:
  freeze: auto
```

Profile file `_quarto-production.yml`:

```yaml
execute:
  freeze: false
```

Activate the profile with the Quarto CLI:

```bash
quarto render --profile production
```

or with the environment:

```bash
QUARTO_PROFILE=production quarto render
```

Avoid profiles when a simple document option or one-time render argument is enough.

Profile-specific configuration is merged over the top-level `_quarto.yml`. Avoid using `metadata-files` inside profile configuration, because Quarto does not resolve `metadata-files` in profiles; copy the needed metadata directly into the profile file instead.

## Render Targets and Output Directories

Use `project.render` to make project renders predictable:

```yaml
project:
  type: default
  render:
    - index.qmd
    - reports/*.qmd
    - "!reports/drafts/"
```

Use `project.output-dir` when the output location is a project decision:

```yaml
project:
  type: website
  output-dir: docs
```

Review output directories together with `.gitignore` and publishing expectations, but route hosting and CI details to deployment or automation guidance.

## Resources

Use `project.resources` for files that must be copied to output but are not discovered automatically:

```yaml
project:
  type: website
  resources:
    - data/public/*.csv
    - downloads/*.pdf
```

Do not use resources as a catch-all for generated files or private data.

## Parameters

Use parameters for intentional report variation:

```yaml
params:
  region: "north"
  year: 2026
```

For repeated reports, parameter values may be supplied from a YAML file during render:

```bash
quarto render report.qmd --execute-params params.yml
```

Keep parameter names explicit and stable. Avoid using parameters as hidden global state for unrelated documents.

## Project-Level `freeze`

Use project-level `freeze` conservatively:

```yaml
execute:
  freeze: auto
```

Project-level `freeze` can make repeated renders more practical, but it changes execution behavior for collaborators. For heavy computation strategy, caching design, or pipeline architecture, defer to `quarto-computation-performance`.

## Boundary With Format Configuration

It is normal for `_quarto.yml` or `_metadata.yml` to contain `format:` blocks. In this skill, review whether the format options are centralized in the right place and whether they are too broad or too local.

Defer detailed decisions about these topics to `quarto-format-configuration`:

- HTML themes, CSS, SCSS, Bootstrap, JavaScript, and includes.
- PDF via LaTeX or Typst, including templates, packages, and engine-specific options.
- DOCX `reference-doc` and Word styling.
- revealjs, PowerPoint, Beamer, and presentation-specific behavior.
- Custom formats, extensions, and Lua filters.

## Official Sources

- Quarto project basics: https://quarto.org/docs/projects/quarto-projects.html
- Quarto project options: https://quarto.org/docs/reference/projects/options.html
- Quarto project profiles: https://quarto.org/docs/projects/profiles.html
- Quarto parameters: https://quarto.org/docs/computations/parameters.html
- Quarto managing execution: https://quarto.org/docs/projects/code-execution.html
