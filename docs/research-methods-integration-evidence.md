# Research Methods EPIC 01: Integration Evidence

Status: **integrated locally for review, not released** (2026-10-29). This record covers a bounded, synthetic-first integration check, not a native agent-host installation or a general statistical benchmark.

Later host evaluations and release corrections are recorded in [release evidence](research-methods-release-evidence.md). The results below remain the historical integration snapshot.

## Source and Isolation

- Base: `8068a4740976d77561fbd2750ebb48b309e0221b` on the planning worktree.
- Integration branch: `integration/research-methods-epic-01-20261029`.
- Integration worktree: a dedicated sibling Git worktree, separate from `main` and the four worker worktrees.
- Each plugin remained under its assigned `plugins/<name>/` path. The original worker branches and commits were preserved.
- No public catalogs, published tag pins, release tags, pushes, external systems, private research files or project environments were changed by integration.
- Plugin development manifests remain `0.0.0`. Root README/architecture/roadmap changes describe implemented versus published capabilities without advertising an install.

| Plugin | Worker HEAD | Integrated feature commit(s) | Initial skills |
| --- | --- | --- | ---: |
| `r-data-wrangling` | `4495b572` | `8741eca` | 2 |
| `r-applied-analysis` | `74709926` | `c1ae39e` | 3 |
| `r-psychometrics` | `40dbf84c` | `27cf18f`, `08f8fb5` | 3 |
| `r-simulation-methods` | `a58f36d6` | `501415f` | 2 |
| **Total** | | **Five preserved worker changesets, five integration commits** | **10** |

The original commit IDs differ from the integration IDs because `cherry-pick` recreates each commit on the common integration history.

## Coordinator Checks

From the integration repository root:

```sh
Rscript --vanilla plugins/r-data-wrangling/tests/synthetic-cases.R
Rscript --vanilla plugins/r-applied-analysis/tests/numerical-validation.R plugins/r-applied-analysis
Rscript --vanilla plugins/r-psychometrics/tests/synthetic-validation.R plugins/r-psychometrics
Rscript --vanilla plugins/r-psychometrics/tests/independent-ordinal-validation.R
(cd plugins/r-simulation-methods && Rscript --vanilla tests/validate-simulation.R)
Rscript --vanilla tests/research-methods-composition.R
```

All six commands were independently re-executed by the coordinator in the integrated worktree on R 4.6.1 and exited 0.

| Validation | Result | Evidence boundary |
| --- | --- | --- |
| Data semantics, import and joins | 11 synthetic groups passed | Not exhaustive for SAS/Stata, timezones, lazy backends or real data |
| Applied methods | 62 numerical/plot-construction checks passed | Plot layer construction is not graphical visual review; specialized method combinations remain untested |
| Psychometrics | Main and independent ordinal/SEM suites passed | Selected continuous/ordinal lavaan and psymetrics cases, not invariance or IRT |
| Simulation | 2,000 fixed attempts retained; detailed engine, MCSE and seed checks passed | PSOCK reproducibility is backend-specific; resumption/HPC not certified |
| Structural checks | All 10 skill entry points validated, six supplied R scripts parsed; development manifests parsed and agreed at `0.0.0` | Structural compatibility is not native host installation or automatic activation |
| Repository boundaries | 68 plugin files, each scoped to its writer; checked Markdown internal links, absence of empty skill directories, and private-source literal markers | No claim of exhaustive semantic/security audit of every downstream generated analysis |

All four worker worktrees were clean before integration. The source branches were neither rebased nor modified.

### Focused Cross-Plugin Composition

The additional `tests/research-methods-composition.R` is a narrow synthetic smoke test, not a router or a replacement for domain-specific tests.

1. **Data → regression:** character identifiers with leading zeros, long reshape, explicit 12/11 eligible/observed denominators, native `lm()` and `parameters` coefficient equality.
2. **Data → survey:** one-to-one table integration, full design declaration, domain subset and finite design-based mean/SE.
3. **Data → psychometrics:** ordered item columns preserved through a join, WLSMV `lavaan::cfa()`, and the `psymetrics::model_fit()` default CFI matching native **scaled** CFI.
4. **Simulation → regression:** `SimDesign` with the native `lm()` estimator, 32 fixed intended attempts, explicit missing/identification representation and no engine redraw errors.

All four checks passed. The first composition draft had a **test assertion only** mismatch: `lavaan::fitMeasures()` returns a classed `lavaan.vector`, whereas the comparison expected a plain numeric. After explicitly converting the native result to numeric, the scaled CFI comparison passed. No plugin algorithm or reported index was changed.

These checks exercise code and API semantics underlying the cross-plugin workflow. They **do not** prove automatic skill selection, multi-skill context composition or native installation in Codex/Claude/Gemini.

## Methodological Boundaries and Remaining Gate

- Import preserves data meanings; descriptive/regression/survey skills choose inference, while psychometrics owns item scoring and measurement assumptions. No plugin requires installing `r-analytic-core` as a dependency.
- CFA/EFA with ordinal data retain deliberate WLSMV and scaled-fit reporting; `.robust` is not silently substituted. The `psymetrics` off-diagonal covariance-labeling concern remains tracked in [issue #55](https://github.com/brianmsm/psymetrics/issues/55).
- `SimDesign` cannot silently replace failed methods when their failures contribute to operating characteristics. Distinguish usable estimates from all-attempt denominators.
- Four proposed second-slice skills remain **planned only**: applied missing-data and mixed-model methods, psychometric invariance and basic IRT. No placeholder implementation is claimed.
- Before any `0.1.0` release: perform a small, isolated **native host installation/discovery/activation** test, check auto-selection boundaries and optional multi-skill composition, review package manifests in the intended clients, and separately decide whether each plugin merits release. The currently checked `0.0.0` manifests and synthetic tests do not establish those facts.
- Earlier worker validation reported a possible change to global tool selection from an unexpected Claude launcher action; no prior environment snapshot exists. Integration did not invoke that launcher or attempt speculative rollback.

This is a **local development-integration candidate**, not a published result. Follow the repository's independent plugin release/tag/catalog process only after the remaining gate is satisfied and a release is explicitly authorized.
