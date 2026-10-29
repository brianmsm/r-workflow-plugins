# Architecture

## Responsibility

This plugin owns applied statistical questions, estimands, common comparisons, ordinary regression and complex-survey inference. It distributes procedural skills and conditional references, not an R package or an estimation wrapper.

The three entry points separate actual user tasks. Descriptives/comparisons owns unadjusted summaries and contrasts; regression owns covariate-adjusted ordinary models; survey owns design-based inference whenever the sampling structure governs variance. Survey is not a reporting adapter layered over weighted ordinary regression.

## Internal organization

Each `SKILL.md` establishes scope, decision points and conditional reading. Each reference keeps native specification, estimation and interpretation together. A small developer test executes documented synthetic code and checks substantive numerical invariants. It is deliberately separate from user-facing analysis recipes.

No runtime script, universal result extractor, model factory, shared environment loader, empty asset directory or generic routing skill is provided. Plugin-level docs record scope, staged work and evidence. Existing Codex/Claude manifests remain thin distribution metadata.

## Composition

| Task or boundary | Responsibility |
| --- | --- |
| Import semantics, labels, joins and observation keys | Data-wrangling capability; preserve its prepared table and substantive missingness |
| Denominators and inferential missing-data choice | This plugin distinguishes observed/model samples; MI implementation is a future bounded slice |
| Researcher-editable analytical code | Optional `r-analytic-coding-principles`; native examples already follow that style |
| Measurement reliability, latent models and technical SEM estimation | Psychometric/CFA-SEM capability; applied reasoning still owns adjustment, estimands and interpretation |
| Random effects/dependence modeling | Planned mixed-model slice; a sampling PSU is not automatically a random effect |
| Repeated simulation and operating characteristics | Simulation capability; this plugin may supply a visible estimator |
| Document rendering and publication layout | Publishing capability; the analysis owns the numbers and uncertainty |

A single-plugin installation must remain understandable without sibling-plugin files, local cache paths or a particular MCP server. References point only inside this plugin or to public sources.

## Extension rule

Add a method only after a real task establishes its boundary and a class-specific numerical/behavioral case verifies estimation, extraction and researcher editability. Separate support for packages does not certify their combination. `parameters`/`performance` defaults do not justify changing a native estimator, sample or uncertainty method.
