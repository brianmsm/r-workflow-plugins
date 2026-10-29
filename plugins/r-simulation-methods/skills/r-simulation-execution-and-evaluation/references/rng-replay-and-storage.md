# RNG, Replay and Storage

Read when preserving, replaying, extending or parallelizing a study. The initial tested route uses **SimDesign 2.28**, explicit `genSeeds()`, serial execution, in-memory raw results, saved replication RNG states, and RDS round trips. A bounded two-worker PSOCK check was added only after serial validation.

## Preserve Randomness at the Right Unit

Create a seed mapping once for an ordered condition table:

```r
condition_seeds <- genSeeds(Design, iseed = 87105L)
```

Pass it to `runSimulation(seed = condition_seeds)`. Record the integer master seed, the returned seed objects, design order and RNG kind. In the tested route `genSeeds()` produces L'Ecuyer-CMRG streams; do not assume a scalar seed or `set.seed(); genSeeds()` consumes the same sequence. Avoid clock-based seeds, reseeding in `Generate()`/`Analyse()`, or generating seeds independently in workers.

Methods should see the same dataset. If their fitting algorithms also use randomness, preserve their seed policy or precomputed random inputs so adding a method does not accidentally redefine comparisons. Common random numbers across conditions require deliberate covariance-aware evaluation.

## Replay a Retained Replication

Enable `control = list(store_Random.seeds = TRUE)` when exact replay is needed. This also stores seeds for accepted records representing a failed method. Engine error seeds alone cannot recover these status-coded failures.

For the numeric starter route:

```r
stored <- SimExtract(study, "random.seeds")
row_id <- 1L
rep_id <- 2L
seed_state <- as.integer(stored[[row_id]][rep_id, ])

replay <- runSimulation(
  Design[row_id, , drop = FALSE], replications = 1L,
  generate = Generate, analyse = Analyse, summarise = Summarise,
  fixed_objects = fixed_objects, packages = c("dplyr"),
  load_seed = seed_state, parallel = FALSE,
  save = FALSE, store_results = TRUE, max_errors = 1L,
  control = list(allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE)
)
SimResults(replay)
```

Choose row/replication IDs from the saved mapping, not from a filtered table's new row numbers. Compare scientific outputs and missing/status fields; timestamps and elapsed times are not reproducibility targets. Replay a successful record and an expected failed record.

For an engine exception, inspect `SimErrors(result, seeds = TRUE)` or `SimExtract(result, "error_seeds")` and extract the one integer RNG-state column matching the condition/message. Inspect its actual shape. A fatal run can abort before a returned object exists; use a bounded debug reproduction or explicitly planned disk seed capture for that use case. Do not promise fatal recovery from an empty error table.

Warning seeds require a separate `store_warning_seeds` policy. Counting warnings does not require it, and the basic starter stores all retained-replication states instead. Validate mixed warning/error paths before relying on additional seed collectors.

## Save the Experiment, Not Just a Table

For a small in-memory study, `save = FALSE` avoids automatic checkpoint files; it does not prevent a later explicit `saveRDS()` of the complete experiment. Keep:

- Design and its ordering, fixed objects, callbacks or exact source revision/hash.
- Planned/actual counts, raw replication records, statuses and summaries.
- Master/condition/replication seeds and RNG kind.
- Engine errors/warnings, session/package versions, and relevant backend settings.
- Explicit output destinations and the analytical benchmark used for validation.

The example stores these in a local RDS plus human-readable CSVs and a plot. Do not distribute raw private data or logs as plugin resources.

`store_results = TRUE` retains raw analysis outputs in memory. `save_results = TRUE` is a separate disk-storage mode; `save = TRUE` concerns automatic saving/checkpoint behavior. They are not interchangeable. Large or long studies should test their specific saving route and subsequent `SimResults()` extraction with a tiny run.

## Continuing and Scaling

A fresh rerun with the same seeds is a reproduction, not an additional independent batch. New batches need nonoverlapping streams and unique identities. Preserve old outputs; do not clean or overwrite a run to disguise a restart. Resume only with compatible design order, callbacks, fixed objects, versions and stored state. A changed method is a new run unless a documented re-summary of unchanged raw records is sufficient.

Automatic crash resume, extending stored batches and `reSummarise()` across disk-backed results are **conditional, not validated support claims** of this slice. Test the actual interruption/resume case before using it for long work. RDS readback and one-replication replay do not prove automatic restart behavior.

For local parallel execution, first validate serial results and then choose one backend and a small worker count. Preserve package availability, pass ordinary objects through `fixed_objects`, and check worker export of the callback functions. A separate `check.globals = TRUE` call returns potential globals rather than a simulation result; inspect it rather than treating it as a completed run.

The executed local check used `parallel = TRUE, ncores = 2L` with `control = list(use_mirai = FALSE, type = "PSOCK", allow_na = TRUE, allow_nan = TRUE, stop_on_fatal = TRUE, store_Random.seeds = TRUE)`, `max_errors = 1L`, and the starter's callbacks, fixed objects and condition seeds. It repeated exactly within PSOCK and replayed a stored parallel replication exactly. **Serial and PSOCK raw scientific outputs differed under the same condition seeds.** This is an observed boundary, not evidence that either backend reproduces the other's replicate sequence. Preserve a chosen backend when exact realization matters, or explicitly design and test a backend-independent replication stream.

Use a tiny same-backend repeat, compare scientific records, and test a replication replay. Test cross-backend equivalence only if it will be promised; matching seed labels alone do not prove identical consumption. Do not add a nested future layer, more workers, or BLAS thread changes without a need. Scheduler/HPC, multi-machine coordination, Mplus/Stan and external automation remain future conditional extensions.

Primary API sources: [genSeeds](https://philchalmers.github.io/SimDesign/reference/genSeeds.html), [SimExtract](https://philchalmers.github.io/SimDesign/reference/SimExtract.html), [SimResults](https://philchalmers.github.io/SimDesign/reference/SimResults.html), [runSimulation](https://philchalmers.github.io/SimDesign/reference/runSimulation.html). Check the installed version: older prose can use seed extractor names that differ from the working `"random.seeds"` key.
