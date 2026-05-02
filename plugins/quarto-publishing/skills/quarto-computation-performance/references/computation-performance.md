# Quarto Computation Performance Reference

Use these compact patterns when reviewing or editing Quarto workflows with expensive computation. Optimize the Quarto workflow, not the statistical method or general algorithm unless the user explicitly asks.

## Decision Matrix

- Compute directly in `.qmd`: cheap, transparent transformations, small summaries, and examples that should stay close to the narrative.
- Use cell or chunk cache: repeated expensive executable cells where source-code changes are the main invalidation trigger.
- Use project freeze: many computational documents or collaborators need stable project renders without rerunning every document.
- Use precomputed artifacts: model objects, simulation results, large tables, or expensive data prep can be reused across renders when regeneration during render is slow, fragile, or unnecessary.
- Use external scripts: the analysis has clear steps that should be run, tested, or reviewed independently from publication.
- Use a pipeline tool: dependencies are multi-step, outputs are reused by several documents, or invalidation needs to be explicit.

## Cache Basics

Enable cache at document or project level only after checking the execution engine:

```yaml
execute:
  cache: true
```

Or enable cache for one cell:

````markdown
```{r}
#| label: fit-model
#| cache: true

model <- lm(mpg ~ wt + cyl, data = mtcars)
```
````

Use command-line cache controls for targeted validation:

```bash
quarto render report.qmd --cache
quarto render report.qmd --no-cache
quarto render report.qmd --cache-refresh
```

Cache invalidation is not the same as data dependency tracking. If input data, time, environment variables, package versions, random seeds, or external files change without changing the chunk source, a cache refresh or a stronger workflow may be needed.

For knitr workflows, options such as `cache.extra` or other cache attributes can help when a chunk depends on external files, but do not turn this reference into a full knitr caching tutorial.

## Engine-Aware Execution

Treat execution behavior as engine-specific.

- R documents usually use knitr; cache behavior is cell-level and uses knitr cache.
- Python documents usually use Jupyter; check `jupyter`, kernels, virtual environments, and Jupyter Cache behavior before assuming invalidation.
- Julia documents may use the `julia` engine or the Jupyter/IJulia engine; check document or project YAML before assuming execution behavior.
- Quarto can render specially formatted `.py`, `.jl`, and `.r` script files, but the engine and script syntax differ.
- `freeze` is a project-level strategy for reusing previous computational output during global project renders and should not be treated as the same thing as cache.

## Freeze Basics

Use `freeze` when global project renders should reuse previous computational results:

```yaml
execute:
  freeze: auto
```

`freeze: true` never reruns frozen computations during a global project render. `freeze: auto` reruns when the source file changes.

Freeze results live in `_freeze`. For collaborative project workflows, `_freeze` may need to be committed so collaborators can render the project without reproducing every computational environment.

Important boundary: incremental renders of a single document or project subdirectory execute code by default, even when the project uses `freeze`.

Use `--use-freezer` only as an advanced targeted render flag when the workflow explicitly needs frozen results for an incremental file render.

## Precomputed Artifacts

Use precomputed artifacts when rerunning computation during render would be slow, fragile, expensive, or unnecessary.

Common R pattern:

```r
# prepare-data.R
clean_data <- transform(raw_data, ratio = numerator / denominator)
saveRDS(clean_data, "data/derived/clean-data.rds")
```

```r
# report.qmd code cell
clean_data <- readRDS("data/derived/clean-data.rds")
```

Choose artifact formats based on the object:

- `.rds`: one R object, simple local reuse.
- `.qs`: fast R object serialization when the project already uses the package.
- Parquet/Arrow: columnar tabular data and interoperability.
- DuckDB: larger local analytical datasets and SQL-style access.

For Python or Julia workflows, prefer artifact formats already used by the project. For tabular outputs, Parquet, Arrow, CSV, or DuckDB-backed data are often more portable across languages than language-specific serialized objects.

Do not hide manual artifacts. Keep the code that generates each artifact and document how to regenerate it.

## Externalized Computation

Move computation outside `.qmd` when the document is acting like a pipeline script:

- Large data import and cleaning.
- Expensive model fitting.
- Long simulations.
- Many repeated parameter combinations.
- Shared results used by multiple reports.
- Fragile access to databases, APIs, or credentials.

The `.qmd` can then focus on reading prepared artifacts, presenting results, and making the publication reproducible.

## Pipeline Escalation

Mention `targets`, `drake`, Make, or similar tools only when simple scripts and artifacts are no longer enough.

Escalate when:

- Dependency invalidation matters.
- Several reports consume shared intermediate results.
- Expensive steps should be skipped when inputs are unchanged.
- The workflow needs repeatable orchestration outside Quarto.

Keep pipeline guidance shallow. Do not turn this skill into a `targets` tutorial.

## Random Seeds

For stochastic work, require explicit seed handling:

```r
set.seed(20260502)
simulation <- replicate(1000, mean(rnorm(100)))
```

Record seeds near the computation that uses them. For parallel simulations, use a seed strategy appropriate to the parallel framework instead of assuming one top-level `set.seed()` is enough.

If stochastic outputs are stored as artifacts, keep the artifact generation code and seed together.

## Proportional Validation

Prefer the smallest validation that proves the current change:

- Inspect the relevant `.qmd`, R script, YAML, and artifact paths first.
- Render one affected document before rendering an entire project.
- Render one format before rendering all formats when output format is not the issue.
- Use `--no-execute` only when validating non-computational rendering behavior and be explicit that code was not rerun.
- Use `--cache-refresh` only when cache invalidation is part of the question.
- Reserve full clean renders for release, publication, or when targeted validation cannot answer the risk.

Never claim a full render, clean cache refresh, or artifact regeneration unless it actually happened.

## Boundaries

- Project placement for `execute`, `freeze`, profiles, and render targets belongs primarily to `quarto-project-configuration`.
- Ordinary chunk option cleanup belongs to `quarto-authoring-core`.
- Output-format behavior belongs to `quarto-format-configuration`.
- Deployment, CI, hosting, and release automation are deferred.
- Failed render logs and deep debugging belong to `quarto-render-troubleshooting` unless the root issue is unsafe recomputation.

## Official Sources

- Quarto managing execution: https://quarto.org/docs/projects/code-execution.html
- Quarto using R: https://quarto.org/docs/computations/r.html
- Quarto using Python: https://quarto.org/docs/computations/python.html
- Quarto using Julia: https://quarto.org/docs/computations/julia.html
- Quarto caching: https://quarto.org/docs/computations/caching.html
- Quarto rendering script files: https://quarto.org/docs/computations/render-scripts.html
- Quarto execution options: https://quarto.org/docs/computations/execution-options.html
- Quarto render command: https://quarto.org/docs/cli/render.html
- Quarto parameters: https://quarto.org/docs/computations/parameters.html
- R `saveRDS` / `readRDS`: https://stat.ethz.ch/R-manual/R-devel/library/base/html/readRDS.html
- targets manual: https://ropensci.r-universe.dev/targets/doc/manual.html
- tarchetypes `tar_quarto`: https://docs.ropensci.org/tarchetypes/reference/tar_quarto.html
- Apache Arrow R package: https://arrow.apache.org/docs/r/
- DuckDB R client: https://duckdb.org/docs/stable/clients/r
