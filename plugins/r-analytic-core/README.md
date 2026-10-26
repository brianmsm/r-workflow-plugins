# R Analytic Core

`r-analytic-core` provides **research-first coding conventions** for AI agents that create, review, or revise analytical R code. The default is code that a researcher can inspect and change **model by model, section by section, and figure by figure**—not a prematurely automated production pipeline.

**Agent plugin version:** `v0.1.1`, independently tagged as `r-analytic-core-v0.1.1`. Distribution depends on the marketplace's pinned tag, not the manifest field alone. This patch strengthens tidyverse-style consistency, minimal setup and student notebook guidance without adding a second skill or runtime dependency.

## Implemented Skill

- [`r-analytic-coding-principles`](skills/r-analytic-coding-principles/SKILL.md): research-first R code organization, native calls and deliberate repetition, stable versus premature helpers, editable graphics, coherent package usage, preservation of statistical choices, and proportional tool-based validation.
  - [`research-first-coding-style.md`](skills/r-analytic-coding-principles/references/research-first-coding-style.md): detailed R examples and style decisions.
  - [`verification-and-guardrails.md`](skills/r-analytic-coding-principles/references/verification-and-guardrails.md): live inspections, preserved diagnostic outputs, durable checks, reproducibility, and optional external guardrails.
  - [`package-conflicts.md`](skills/r-analytic-coding-principles/references/package-conflicts.md): selecting between `library()` and `::` according to actual usage; base R conflict resolution and optional `{conflicted}`.
  - [`classroom-r-scripts.md`](skills/r-analytic-coding-principles/references/classroom-r-scripts.md): on-demand guidance for R code students execute in scripts or Quarto notebooks.

Applies to the **R code** in `.R`, `.Rmd`, and `.qmd` files. It does not replace statistical-method expertise, Quarto/R Markdown authoring skills, or R package development guidance.

## Style Defaults

- Place each model's specification, estimation, and immediate inspection in the same analysis section; keep shared data preparation earlier and final cross-model comparisons later.
- Prefer explicit duplicated native modelling and plotting calls over bespoke wrappers when the researcher may edit cases independently.
- Allow small, stable helper functions when they clarify truly invariant transformations or extractions.
- Keep `ggplot2` calls and their per-figure scales, labels, and themes directly editable.
- Use plain calls after `library()` for frequently used, unambiguous functions; keep one-off calls qualified. For important overlapping packages, use a deliberate conflict policy (such as `library(MASS, exclude = "select")`) rather than assuming `library()` order resolves collisions.
- Inspect live data with authorized tools before adding defensive code. Preserve existing reported diagnostics and their denominators even when removing transient guards; persist checks that protect against concrete future failures.
- Respect the project's R idiom; when tidyverse is explicitly preferred, use it consistently for imports (`readr`), column transforms (`across`) and ordinary iteration (`purrr`) where semantics fit. Honor explicit base R or `for` preferences; do not restyle unrelated code.
- Keep `.R` and `.qmd`/`.Rmd` setup minimal: separate literal `library()` calls for frequently used packages, `pkg::fun()` for one-offs, and analysis near its section rather than a mega-setup.
- Use native R errors and inspect live inputs through agent tools; do not introduce package installers, `.libPaths`/`renv` detection or generic `stopifnot()`/fallback wrappers by default. Preserve real execution contracts and substantive diagnostics.
- Respect the chosen style and reproducibility requirements of the project, including intentionally automated pipelines when they are the actual task.

## Natural-Language Use

After installing this plugin in a supported agent, a short request can encourage the agent to load its instructions without naming the technical skill ID. For example:

> Use the research-first R coding style to revise `analysis.R` model by model. Keep each specification next to its fit and results without changing analytical decisions.

A Spanish-language prompt tested in native Codex was: *"Usa el estilo de codificación para investigación en R"*, followed by the concrete task and file. Natural-language selection remains **opportunistic**, not guaranteed. For deterministic intent when the host supports explicit skills, use `$r-analytic-coding-principles`. The plugin must be installed and visible to the agent in either case. No `AGENTS.md` routing rule is required or added by this plugin.

## Install the Released Plugin

### Codex

```bash
codex plugin marketplace add brianmsm/r-workflow-plugins
codex plugin add r-analytic-core@r-workflow-plugins
```

For editing R analysis in the research-first style, invoke `$r-analytic-coding-principles` or describe that intent naturally in the task. Natural-language activation is opportunistic rather than guaranteed.

### Claude Code

```bash
claude plugin marketplace add brianmsm/r-workflow-plugins
claude plugin install r-analytic-core@r-workflow-plugins
```

The corresponding namespaced skill is `/r-analytic-core:r-analytic-coding-principles`. The plugin manifest and marketplace have been validated; native Claude Code model behavior has not been field-tested.

## Local Development and Testing

The skill directory follows the portable Agent Skills convention; `agents/openai.yaml` is optional Codex-facing UI metadata, not part of the substantive guidance. Codex and Claude Code plugin manifests provide distribution metadata only.

For direct local Claude Code testing from the monorepo root:

```bash
claude --plugin-dir ./plugins/r-analytic-core
```

For **unreleased Codex development**, use a separate local marketplace entry pointing to `./plugins/r-analytic-core`, rather than overriding the tag-pinned public marketplace source. The public catalog installs its currently pinned release; verify that its `source.ref` matches `r-analytic-core-v0.1.1` after publication. See the repository [agent setup](../../docs/agent-setup.md).

The first `0.1.0` release passed its [scoped behavioral gate](docs/pilot-findings.md), including two independent post-fix test waves. The `0.1.1` instruction changes passed structural and synthetic R/Quarto checks but have **not** undergone a new independent agent-behavior wave. See the [validation cases](docs/validation-cases.md); public distribution requires the tag and matching marketplace pin to be available remotely.

## Design Documents

- [Architecture](docs/architecture.md): responsibilities, modes, target skills, and boundaries.
- [Roadmap](docs/roadmap.md): staged validation, release gates, and future candidates.
- [Changelog](CHANGELOG.md): unreleased work.
