---
name: r-simulation-execution-and-evaluation
description: "Use when implementing, running, debugging, replaying, or evaluating an R Monte Carlo study, especially with SimDesign; preserve attempted replications, method failures, reproducible randomness, performance denominators, and Monte Carlo uncertainty."
---

# R Simulation Execution and Evaluation

Execute the specified experiment and retain enough evidence to explain every denominator. If its scientific target is unresolved, first establish ADEMP, using `r-simulation-design` when available. Do not substitute a runnable simulation for a defined study.

## Implement and Pilot

1. Confirm the installed package version and relevant API against its help/source. A local source checkout or website can describe a different version.
2. Use visible `createDesign()`, `Generate()`, `Analyse()`, `Summarise()` and `runSimulation()` calls. Keep fixed population quantities in `fixed_objects`; generate replicate-varying quantities in `Generate()`. Keep native models, interval rules and diagnostics inside an understandable analysis callback.
3. Run one or two conditions with a few replications serially. Inspect raw results, return names/types, diagnostic counts, and one analytical or independently computed target before scaling.
4. Compare methods on the same generated data. Record a stable condition/replication/method identity before filtering, reshaping or pairing results.

Read [SimDesign workflow](references/simdesign-workflow.md) for implementation and the validated starter. The [synthetic slope study](assets/bernoulli-slope-study.R) is an editable complete example, not a universal runner. It requires no private files or sibling plugin.

## Preserve Failures as Results

SimDesign can replace thrown errors and numeric `NA`/`NaN` outputs with newly generated data. That behavior can change a fixed-attempt evaluation into a selected-success experiment.

- Return explicit scientific failure and eligibility flags with stable result fields. Preserve unavailable estimates/intervals without inventing zeros. Use and test `allow_na`/`allow_nan` deliberately.
- Distinguish expected method failure from an invalid DGP condition and an unexpected programming error. Catch only recognized method failures when necessary; let unknown exceptions stop the pilot. For the validated fixed-attempt recipe, `max_errors = 1L` plus `stop_on_fatal = TRUE` prevents silent replacement after a thrown exception.
- Inspect `SimResults()`, `SimErrors()`, `SimWarnings()`, and the result's fatal-termination field when present. Empty engine-error tables do not mean that all fitted methods succeeded.
- Do not blanket-convert warnings to errors or remove missing values before defining eligibility. A fatal/incomplete run is not a completed cell with zero failures.

Read [Failures and performance](references/failures-and-performance.md) before changing error policy or computing bias, RMSE, coverage, power or MCSE. It defines conditional metrics, all-attempt joint rates, edge cases and optional `rsimsum` use.

## Reproduce, Scale and Report

Use recorded seeds and preserve the design-to-seed mapping. Replay a saved replication, including a failed method outcome, before claiming reproducibility. Read [RNG, replay and storage](references/rng-replay-and-storage.md) when saving, continuing or parallelizing a run. Add a parallel backend only after serial correctness; verify the actual backend and worker contract instead of promising universal serial/parallel equivalence.

Report planned attempts, completed records, fit/convergence/admissibility counts where applicable, usable estimates/SEs/intervals, failures, metrics with denominators, MCSE and its assumptions, seed/version provenance, and validation limits. Keep raw records and an editable performance display alongside summaries.

The optional `r-analytic-coding-principles` capability helps preserve researcher editability. Function boundaries and iteration are justified for replication; do not export this architecture to ordinary exploratory analyses. Domain estimators, publishing, HPC/SLURM, multi-machine execution, Mplus/Stan and external orchestration remain separate or conditional capabilities.
