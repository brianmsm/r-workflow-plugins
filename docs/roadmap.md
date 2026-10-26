# Repository Roadmap

This is the **global plugin map and development horizon**, not a release schedule and not the implementation plan for any individual plugin. The [root architecture](architecture.md) defines shared design rules. Each implemented plugin may maintain its own `docs/architecture.md` and `docs/roadmap.md` for domain-specific scope and staged work.

## Current State

As of 2026-10-26, `quarto-publishing`, `quarto-bento` and `r-analytic-core` have **independent tagged versions and marketplace entries** in this repository. The new Quarto Publishing `0.2.3` guidance maintains six implemented skills, including pedagogical communication and progressive slide design; its [architecture](../plugins/quarto-publishing/docs/architecture.md) proposes ten target skills, while the [roadmap](../plugins/quarto-publishing/docs/roadmap.md) distinguishes implemented and planned work. Tag/pin changes reach remote consumers only after publication.

`r-analytic-core` retains its released **v0.1.0** tag and one research-first R coding skill. The `quarto-bento` agent plugin now has a **v0.1.1** guidance patch (distinct from the installed `qbento 0.1.1` application), with one skill and three operational references. Its [roadmap](../plugins/quarto-bento/docs/roadmap.md) documents native app/agent evidence and residual limits. All other plugin names remain **working candidates** without scaffolds or releases; no next-plugin order is committed.

## Plugin Candidates and Scope

| Plugin | Intended role | Examples, not a committed skill list | State |
| --- | --- | --- | --- |
| `r-analytic-core` | Research-first, locally editable analytical R code | One validated core skill; optional future specialized workflows | **Published v0.1.0** |
| `r-applied-analysis` | Statistical analysis applied to research questions | Descriptives; regression/GLM; missing data; reporting estimates | Planned |
| `r-psychometrics` | Measurement modeling and interpretation | EFA/CFA; IRT; invariance/DIF; bifactor/ESEM; reliability and validity evidence | Planned |
| `r-simulation-methods` | Simulation designs and Monte Carlo evaluation | DGPs; condition grids; replication; bias/RMSE/coverage/MCSE; `SimDesign` | Planned |
| `r-package-development` | Build and maintain R packages | API design; roxygen2; testthat; pkgdown; CI | Planned |
| `quarto-publishing` | Quarto-first, engine-aware document and publication workflows | Six skills: QMD; formats; reports; slides; computation; rendering | **Tagged v0.2.3** |
| `quarto-bento` | Independent companion for the Quarto-Bento application | One workflow skill; JSON API, reviewed sync/recovery, scoped animation migration | **Tagged v0.1.1** |
| `rmarkdown-workflows` | Classic R Markdown support and interoperability | `.Rmd` reports; parameters; output maintenance | Planned |

### Cross-Plugin Boundaries

- `r-analytic-core` is **optional transversal guidance**, not a required dependency of every plugin and not a substitute for specialized statistical judgment.
- `r-applied-analysis` handles general analyses; `r-psychometrics` handles measurement-specific methods. Statistical overlap is resolved by the **primary user task**, not by duplicating whole skills.
- `r-simulation-methods` owns replication designs and evaluation machinery even when a simulation studies psychometric estimators; the psychometrics plugin can supply domain assumptions or model interpretation.
- `r-package-development` concerns building software packages; analysis or publishing plugins may help with examples and documentation but should not own package engineering.
- `quarto-bento` owns the Bento application state/identity/operation contracts, not generic Quarto authoring, narrative or performance. Its skill may consult available companions by capability; it does not depend on their installation paths or require all of them.
- `quarto-publishing` is Quarto-first even for Python/Julia/prose projects. `rmarkdown-workflows` is for classic R Markdown; full migrations into Quarto should use the Quarto migration capability when implemented.

## Next Development Decisions

1. **Keep documentation and releases aligned:** distinguish planned, implemented, tested, and published behavior. Maintain a canonical map here rather than repeating a detailed roadmap in each conversation.
2. **Continue evidence-based Quarto refinement:** use its internal roadmap and real project testing to decide whether to split deferred skills such as multiformat compatibility, R Markdown migration, deployment, and accessibility.
3. **Select the next plugin by actual demand:** review the candidate scope, its boundary with existing plugins, and the smallest useful first release before scaffolding. No next-plugin order is committed.
4. **Test portability where useful:** retain common `SKILL.md` content and add only proven adapters for agent runtimes. Separate standalone skill compatibility from full native plugin installation.
5. **Keep releases independent:** the next plugin may start at `0.1.0` without changing `quarto-publishing` or the rest of the monorepo.

## Implementation Gate for a New Plugin

Before creating a plugin folder or a list of skills, establish: its primary user tasks; clear in/out scope and handoffs; overlap with the existing catalog; an initial small set of reusable skills with unambiguous triggers; and a minimal test plan. Keep speculative skills as a map, not placeholder directories. Prioritize improvements observed in real tasks over feature-count targets.

The global roadmap should change when the ecosystem scope or priorities change. For local task details, consult the current Git working tree, manifests, changelogs, and each plugin's own roadmap; this document is not a substitute for those sources.
