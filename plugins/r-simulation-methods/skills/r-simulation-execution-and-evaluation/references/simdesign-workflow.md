# SimDesign Workflow

Read to implement a specified experiment. Runtime validation used **R 4.6.1 and SimDesign 2.28**. The separately inspected source checkout declared **2.25.4**; source inspection alone is not a compatibility claim for that version. Use the installed help and namespace when sources differ. Primary API: [runSimulation](https://philchalmers.github.io/SimDesign/reference/runSimulation.html).

## Keep the Scientific Code Visible

`createDesign()` defines the condition rows. `Generate(condition, fixed_objects)` creates one dataset; `Analyse(condition, dat, fixed_objects)` evaluates the methods on it; `Summarise(condition, results, fixed_objects)` computes one condition's operating characteristics. Prefer explicit `condition$factor` accesses to attaching columns into the calling environment.

Use `fixed_objects` for constants and population parameters that must not be regenerated. If costly condition-specific preparation is necessary, `prepare()` returns the updated list; preserve generated preparation objects separately because the final object need not retain them. Stochastic preparation needs its own seed/replay plan and is outside the starter's validated route.

Systematic replication justifies functions and iteration. It does not justify hiding formulas, convergence criteria, interval rules or scientific exclusions behind a universal model wrapper. Prefer a named numeric analysis vector with stable fields. Multiple methods can share one callback or use the native named list of analysis functions; choose the clearer representation and validate its field names.

## The Complete Synthetic Example

Read/adapt [bernoulli-slope-study.R](../assets/bernoulli-slope-study.R) for the initial route. It has four conditions, one native OLS model per dataset and two interval rules. Its only scientific non-identification mechanism is no variation in a binary predictor. Each of 500 planned samples per cell leaves a record.

The script contains:

- Explicit ADEMP decisions and fixed population parameters.
- A three-replication, two-condition serial pilot.
- A serial study retaining unavailable estimates with flags.
- Separate estimate, SE and interval counts, bias, empirical SE, mean model SE, RMSE, coverage, all-attempt joint rates and MCSE.
- Paired t-minus-normal coverage differences.
- Analytical failure, RMSE and interval-coverage benchmarks.
- An editable ggplot2 display and local CSV/RDS/PNG outputs, including seeds and session metadata.

Run from the plugin directory:

```sh
Rscript --vanilla skills/r-simulation-execution-and-evaluation/assets/bernoulli-slope-study.R
```

The output directory is explicit in the script. Adapt that destination and the source fingerprint path when copying the example into another project. The script does not change the working directory, install packages or restore an environment. It uses ordinary installed SimDesign, dplyr, tidyr, ggplot2 and occasional readr/scales calls.

## Fixed-Attempt Execution Policy

For this use case, the meaningful controls are:

```r
runSimulation(
  design = Design, replications = 500L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects,
  seed = genSeeds(Design, iseed = 87105L),
  parallel = FALSE, save = FALSE, store_results = TRUE,
  max_errors = 1L,
  control = list(
    allow_na = TRUE, allow_nan = TRUE,
    stop_on_fatal = TRUE, store_Random.seeds = TRUE
  )
)
```

This fragment assumes the callbacks and design were already defined. Use lowercase `design`, even when its object is named `Design`. `store_results` is a top-level argument; `allow_na`, `allow_nan` and `stop_on_fatal` belong in `control`. Check `formals(SimDesign::runSimulation)` when adapting a call rather than guessing names or nesting. The fragment does not replace scientific specification.

The missing-value controls allow unavailable results to reach `Summarise()`; flags and explicit eligibility sets give those values meaning. A thrown unexpected error terminates this strict run at the first failed engine attempt. Expected method failure must instead return its status and unavailable fields. Do not catch all exceptions into the same missing-value category.

Read [failures and performance](failures-and-performance.md) before changing this policy. A different study can deliberately reject invalid DGP draws, but must then report those draws and its conditional target.

## Inspect Before Increasing Work

Inspect `SimResults(study)` for raw records, not only the printed condition summary. In the validated numeric-vector/in-memory route it returns a tibble with design columns repeated for each retained replication. Add a within-condition replication ID before filtering. Do not assume every list/data-frame analysis output or disk-storage route has the same shape.

Inspect `SimErrors(study)` and `SimWarnings(study)`. With the starter, expected rank deficiencies appear in explicit scientific flags while engine error/warning tables are empty. This is a correct distinction, not absence of failures.

Keep the final object's `FATAL_TERMINATION` field if present; it can exist when `SimErrors()` is empty. Never certify completion from the error table alone. Under this starter's strict policy a fatal exception aborts instead of producing an apparently complete summary.

Read [RNG, replay and storage](rng-replay-and-storage.md) before claiming reproducibility across sessions, checkpoints or backends. Preserve the design, callbacks, fixed quantities, package versions and seed mapping together. A successful tiny pilot establishes execution mechanics; the analytical benchmark and precision assessment answer separate questions.

## Boundaries

This first recipe validates one generator, one numeric analysis callback, finite independent conditions and an in-memory result object. Multiple analysis lists, stochastic preparation, disk-backed result extraction, automatic interruption recovery and external engines require their own small case before claiming support. Native package features remain available; their existence does not make every combination tested.
