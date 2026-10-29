# Repository Roadmap

This is the **global plugin map and development horizon**, not a release schedule and not the implementation plan for any individual plugin. The [root architecture](architecture.md) defines shared design rules. Each implemented plugin may maintain its own `docs/architecture.md` and `docs/roadmap.md` for domain-specific scope and staged work.

## Current State

As of 2026-10-29, `quarto-publishing`, `quarto-bento` and `r-analytic-core` have **independent tagged versions and marketplace entries** in this repository. The new Quarto Publishing `0.2.3` guidance maintains six implemented skills, including pedagogical communication and progressive slide design; its [architecture](../plugins/quarto-publishing/docs/architecture.md) proposes ten target skills, while the [roadmap](../plugins/quarto-publishing/docs/roadmap.md) distinguishes implemented and planned work. Tag/pin changes reach remote consumers only after publication.

`r-analytic-core` has a new **v0.1.1** guidance patch and one research-first R coding skill; its published `v0.1.0` tag remains immutable. The `quarto-bento` agent plugin has a separate **v0.2.0** compatibility-guidance release (the installed application remains `qbento 0.1.1` until independently updated), with one skill and three operational references. Its [roadmap](../plugins/quarto-bento/docs/roadmap.md) documents native app/agent evidence and residual limits. Four additional research-methods plugins now have **implemented development slices**, without public tags, catalog entries or native-host installation claims. Their manifests remain `0.0.0`. Other plugin names remain candidates without scaffolds or releases.

## Plugin Candidates and Scope

| Plugin | Intended role | Examples, not a committed skill list | State |
| --- | --- | --- | --- |
| `r-analytic-core` | Research-first, locally editable analytical R code | One core skill; optional future specialized workflows | **Tagged v0.1.1** |
| `r-data-wrangling` | Preserve and transform research data meanings | Import/types/labels; recoding, joins, reshaping and aggregation | **Implemented first slice (2 skills); unreleased `0.0.0`** |
| `r-applied-analysis` | Statistical analysis applied to research questions | Descriptives, ordinary regression and complex-survey inference; next: missing-data and mixed-model skills | **Implemented first slice (3 skills); unreleased `0.0.0`** |
| `r-psychometrics` | Measurement modeling and interpretation | Item/reliability, EFA including ordinal WLSMV, conventional CFA and basic SEM; next: invariance and IRT | **Implemented first slice (3 skills); unreleased `0.0.0`** |
| `r-simulation-methods` | Simulation designs and Monte Carlo evaluation | ADEMP, SimDesign, failure-aware bias/RMSE/coverage/MCSE and explicit RNG; advanced infrastructure deferred | **Implemented first slice (2 skills); unreleased `0.0.0`** |
| `r-package-development` | Build and maintain R packages | API design; roxygen2; testthat; pkgdown; CI | Planned |
| `quarto-publishing` | Quarto-first, engine-aware document and publication workflows | Six skills: QMD; formats; reports; slides; computation; rendering | **Tagged v0.2.3** |
| `quarto-bento` | Independent companion for the Quarto-Bento application | One workflow skill; sync/recovery, animation migration and conditional app 0.2 composition/widget guidance | **Tagged v0.2.0** |
| `rmarkdown-workflows` | Classic R Markdown support and interoperability | `.Rmd` reports; parameters; output maintenance | Planned |

### Cross-Plugin Boundaries

- `r-analytic-core` is **optional transversal guidance**, not a required dependency of every plugin and not a substitute for specialized statistical judgment.
- `r-data-wrangling` owns preservation and transformation of data meanings, keys and observation units. It does not choose imputations, score validity, design-based variances or statistical estimators.
- `r-applied-analysis` handles general analyses; `r-psychometrics` handles measurement-specific methods. Statistical overlap is resolved by the **primary user task**, not by duplicating whole skills.
- `r-simulation-methods` owns replication designs and evaluation machinery even when a simulation studies psychometric estimators; the psychometrics plugin can supply domain assumptions or model interpretation.
- `r-package-development` concerns building software packages; analysis or publishing plugins may help with examples and documentation but should not own package engineering.
- `quarto-bento` owns the Bento application state/identity/operation contracts, not generic Quarto authoring, narrative or performance. Its skill may consult available companions by capability; it does not depend on their installation paths or require all of them.
- `quarto-publishing` is Quarto-first even for Python/Julia/prose projects. `rmarkdown-workflows` is for classic R Markdown; full migrations into Quarto should use the Quarto migration capability when implemented.

## Next Development Decisions

1. **Keep documentation and releases aligned:** distinguish planned, implemented, tested, and published behavior. Maintain a canonical map here rather than repeating a detailed roadmap in each conversation.
2. **Continue evidence-based Quarto refinement:** use its internal roadmap and real project testing to decide whether to split deferred skills such as multiformat compatibility, R Markdown migration, deployment, and accessibility.
3. **Complete the research-methods integration gate:** inspect the [integration evidence](research-methods-integration-evidence.md), reproduce small method and composition checks, and independently verify native host discovery/activation before releasing the four new plugins. Second-slice skills remain planned, not scaffolded. No next-plugin order is committed.
4. **Test portability where useful:** retain common `SKILL.md` content and add only proven adapters for agent runtimes. Separate standalone skill compatibility from full native plugin installation.
5. **Keep releases independent:** the next plugin may start at `0.1.0` without changing `quarto-publishing` or the rest of the monorepo.

## Implementation Gate for a New Plugin

Before creating a plugin folder or a list of skills, establish: its primary user tasks; clear in/out scope and handoffs; overlap with the existing catalog; an initial small set of reusable skills with unambiguous triggers; and a minimal test plan. Keep speculative skills as a map, not placeholder directories. Prioritize improvements observed in real tasks over feature-count targets.

The first implementation contains ten skills, not the full proposed 14-skill EPIC. See [the EPIC scope](research-methods-epic-01.md) and [integration evidence](research-methods-integration-evidence.md) for stage boundaries. The global roadmap should change when the ecosystem scope or priorities change. For local task details, consult the current Git working tree, manifests, changelogs, and each plugin's own roadmap; this document is not a substitute for those sources.
