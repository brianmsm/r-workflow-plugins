# R Analytic Core Architecture

## Purpose and Scope

`r-analytic-core` defines **how an agent writes and edits analytical R code in research workflows**. It is about a researcher's ability to inspect, modify, and rerun specific choices, not about choosing statistical methods or optimizing an industrial pipeline. Treat a conventional analyst using R as a working research environment, not necessarily as a software-package developer.

The guiding principle is **analysis-first coding**: optimize for the next analytical decision and point-of-use edit. This includes the **locality of analysis**, deliberate rather than reflexively eliminated repetition, restrained helper functions, and tool-based verification that does not clutter the research code.

The style is a **context-sensitive default**, not a rule overriding explicit user requests or existing project conventions.

## Three Independent Dimensions

1. **Working mode:** interactive/exploratory analysis; reproducible analytical handoff; deliberately automated or production-oriented execution. These are not mandatory stages.
2. **R idiom:** tidyverse, base R, `data.table`, or an intentional combination. No idiom implies a particular working mode.
3. **Editing/execution surface:** `.R` scripts, R chunks in `.Rmd`, and R cells in `.qmd`; preserve current section/chunk conventions and the actual host's execution semantics.

Precedence: **explicit user choices → project instructions → existing file conventions → research-first defaults**. Ask only when a genuine ambiguity changes scientific meaning or significant architecture; otherwise preserve conventions already observed.

## Behavior Boundaries

### In Scope

- Keep independently editable specifications, estimations, immediate diagnostics, and tailored figures near their section's analysis.
- Prefer native visible calls and intentional repetition where models/plots may diverge.
- Separate genuinely invariant extraction or recoding helpers from evolving modelling/visualization decisions.
- Use already attached packages coherently; choose attachment/qualification from actual use. When a frequently used package masks a frequently used function, prefer a clear, minimal conflict resolution at setup over repeated qualification, provided the effective binding is verified.
- Maintain inspectable dependency order and proportionate reproducibility without forcing a packaged workflow.
- Inspect data/session state directly where authorized, distinguish that from persistent source contracts, and preserve all original reported metrics when streamlining runtime guards.
- Preserve statistical and data-handling meaning when making code-only edits.

### Out of Scope

- **Applied analysis / psychometrics:** selecting models, estimators, diagnostic thresholds, and scientific interpretations. `r-analytic-core` preserves the user's decisions but does not replace domain expertise.
- **Simulation methods:** replication design, Monte Carlo operating characteristics, and automated condition grids. Iteration and functions may be essential there.
- **R package development:** public APIs, software engineering architecture, testing conventions and CRAN release practices, where abstraction is often beneficial.
- **Quarto/R Markdown publishing:** YAML, rendering, report design, citations, and output formatting. This plugin governs only the R code inside those documents.
- **Production data pipelines:** when the user's primary task is unattended automation, the host's pipeline requirements override research-first style defaults.

Plugins are independently usable; do not introduce hard dependency chains or clone content from other plugin skills.

## Current Skill and Resources

### Implemented in `v0.1.0`

`r-analytic-coding-principles` is one general skill with meaningful conditional guidance:

- `SKILL.md` states the defaults, workflow, boundaries and when to load supporting references.
- `references/research-first-coding-style.md` holds practical contrasting examples and coding-mode rules.
- `references/verification-and-guardrails.md` holds targeted inspection, diagnostic output preservation, and verification practices.
- `references/package-conflicts.md` gives context-driven attachment/qualification decisions and tested base R options (`exclude`, `conflictRules`), with `{conflicted}` strictly optional.
- `agents/openai.yaml` supplies optional Codex UI metadata. It is not the portability contract.

No plugin router, scripts, test hooks, or assets are necessary at this stage. Agent-specific manifests are small distribution adapters. Source-based skill content must remain usable without an R-specific MCP server or Codex-only APIs.

### Conditional Future Skills (not implemented)

- `r-interactive-analysis-style`: only if live-session/editor interaction develops a distinct recurring workflow beyond the general coding principles.
- `r-proportional-defensive-coding`: only if repeated input-integrity and check-placement requests justify separate activation.
- `r-analysis-refactoring-boundaries`: only if real edits repeatedly change analytical semantics despite the core skill's guidance.
- `r-analytical-reproducibility`: only if a sustained workflow around clean-session reproduction, file artifacts, and environments warrants its own scope.

These are **candidate capabilities**, not a promised skill count. When splitting a topic, transfer its detailed content rather than duplicating it and revise descriptions/handoffs.

## Design Trade-offs

- Intentional code duplication may cause drift. Validate named shared assumptions and user-intended differences **without imposing a loop**.
- Live checks do not guarantee future data compatibility. Use persistent guards when the actual failure risk is ongoing, and report when only current data were inspected.
- Functions are acceptable for stable, obvious mechanics; avoid wrappers that obscure the original estimator or graphic choices. Keep each independently revised CFA formula/string beside its `cfa()` fit and relevant outputs.
- A reproducible full run can coexist with local editing. Do not promise clean-session reproducibility based only on objects that happen to exist interactively.
- Code-only changes in `.qmd`/`.Rmd` preserve frontmatter, chunk labels/options, output behavior, and prose. The document-owning plugin handles any deliberate publication changes.
- No universal formatting standard, auto-formatter, `renv`, CI, or hook is required by this plugin.

## Growth and Verification

Follow [the plugin roadmap](roadmap.md) and [validation scenarios](validation-cases.md). Test future skill changes through fresh realistic tasks, compare outcomes rather than phrasing, track actual R semantics, and record observed failures before modifying scope. The first release passed the scoped behavioral gate; later releases require their own proportionate validation and a separate marketplace publication step.
