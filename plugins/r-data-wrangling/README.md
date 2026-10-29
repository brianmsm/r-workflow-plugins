# R Data Wrangling

Prepare research tables while keeping identifiers, variable meanings, missingness and units of observation explicit. This plugin provides editable R procedures, not an R package or pipeline framework.

**State:** functional development draft for an initial `0.1.0` release. The manifests remain `0.0.0` and changes are recorded under `Unreleased` until the coordinator performs the repository's release step. No public tag, catalog entry or host installation is claimed.

## Implemented Skills

| Skill | Primary task |
| --- | --- |
| [r-data-import-and-types](skills/r-data-import-and-types/SKILL.md) | Import delimited/Excel/statistical-format tables; preserve identifiers, labels and missing meanings; choose deliberate analysis types and export metadata. |
| [r-data-transform-and-integrate](skills/r-data-transform-and-integrate/SKILL.md) | Apply declared recodes, equality joins, schema-aware stacking, long/wide transformations and deterministic grouped aggregation. |

Use the skill by name or describe the data task. Natural-language selection remains host-dependent. Each skill routes to details only when the operation requires them.

## Initial Scope

The initial slice targets in-memory data frames/tibbles and uses `readr`, `readxl`, `haven`, `labelled`, `dplyr` and `tidyr`, with `stringr`, `forcats` and `lubridate` as needed. A package is selected for the task, not installed or attached as a mandatory bundle.

The procedures retain imported inputs, explicit code mappings, inspection tables and researcher-editable native calls. They distinguish incomplete labels, SPSS user missings, tagged missing values, meaningful duplicate records, unmatched keys, recorded versus absent occasions, and all-missing aggregation.

The optional `r-analytic-coding-principles` capability supplies general research coding conventions. No sibling plugin, private source, fixed installation path or particular MCP server is required.

## Boundaries

- This plugin implements a supplied scoring/aggregation rule; psychometrics owns the rule's measurement validity.
- It preserves and describes missingness; applied analysis owns imputation, likelihood-based treatment and inferential assumptions.
- It can prepare known design variables and descriptive weighted inputs; applied analysis owns survey design, variances and uncertainty.
- It changes table structure; it does not select regression, longitudinal or latent models. Publishing belongs to the relevant authoring workflow.
- Database/lazy backends, large-data optimization, fuzzy/rolling/interval joins, production orchestration and automatic project scaffolding are deferred.

Delimited import, synthetic Excel/SPSS round-trips, labelled/tagged vectors, recoding, equality joins, stacking, pivots and aggregation have targeted numerical evidence. SAS/Stata file round-trips, every spreadsheet date system, timezone-sensitive exports and arbitrary custom classes are not certified. See [validation and handoff](docs/validation.md) for tested versions, actual results and behavioral limits.

## Reproduce the Numerical Checks

From the repository root, with the listed test packages already available:

```bash
Rscript --vanilla plugins/r-data-wrangling/tests/synthetic-cases.R
```

The script creates only synthetic in-memory inputs and temporary round-trip files. Its assertions and expected-error handling are test infrastructure, not boilerplate to inject into research scripts. It installs nothing and does not execute existing user analyses. `writexl` is used only to construct a small Excel test fixture; it is not a plugin runtime dependency.

The two manifests follow this monorepo's Codex and Claude compatibility layout. JSON/skill validation is separate from a host installation test; native host loading and cross-plugin integration remain coordinator work before release.
