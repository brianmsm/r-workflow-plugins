---
name: r-simulation-design
description: "Use when planning or reviewing a Monte Carlo method-evaluation, power, or precision study in R: define ADEMP, generating conditions, truth, comparison methods, replication counts, and failure denominators before execution."
---

# R Simulation Design

Turn a research question into an explicit, feasible simulation protocol. Use ADEMP: aims, data-generating mechanisms, estimands, methods, and performance measures. A simulation is the primary task here; a single fitted analysis, ordinary data cleaning, or an MCMC convergence check alone belongs elsewhere.

## Establish the Scientific Experiment

- State what decision the study should inform and under which conditions. Separate a software demonstration from evidence about a method's operating characteristics.
- Specify the sampling unit, dependence, distributions, sample sizes, missingness and other design factors. Cross only meaningful combinations; identify excluded cells and their scientific reason.
- Define truth on the scale actually estimated. State which population parameters and latent quantities remain fixed across replications, which vary by condition, and which are regenerated. Re-sampling population parameters changes the target experiment.
- Specify each method, consequential arguments, tuning and interval/test construction. Pair methods on the same generated dataset. Distinguish method-internal randomness from the DGP and preserve both when necessary.
- Define success, convergence, admissibility, estimate/SE/interval availability, and failure categories before summarizing. A sample that does not identify a method can be a legitimate DGP outcome. Do not redraw it merely to obtain the planned number of successful fits.

Use [ADEMP and precision](references/ademp-and-precision.md) when choosing conditions, allocating replications, formalizing targets, or drafting the protocol. Proceed on reasonable stated assumptions; ask only when an unresolved scientific choice changes the study.

## Plan Evaluation and Precision

Choose metrics that answer the aim: bias and RMSE for recovery; empirical versus model-based uncertainty; interval coverage; rejection/power; failure rates; and runtime when relevant. Specify each metric's eligible replication set and denominator. Keep intended attempts and completed records separate.

Plan replication counts from Monte Carlo precision, using pilot variance estimates or a justified bound. Account for lower usable counts when a metric is conditional on successful estimation. For a method comparison, use paired differences and their Monte Carlo uncertainty. A Monte Carlo SE measures simulation noise, not sampling uncertainty in one fitted dataset.

Before scale-up, plan a tiny serial pilot, one known-truth benchmark, a deliberately unavailable estimate/interval, and a seed replay. Record what those checks can and cannot establish.

## Produce an Editable Handoff

Deliver the ADEMP specification, condition table, fixed quantities, explicit methods, eligibility rules, target MCSE/replications, seed strategy, and a bounded validation plan. Keep native model calls and scientific choices inspectable. Use the optional `r-analytic-coding-principles` capability when available; this skill works without it.

For implementation, use `r-simulation-execution-and-evaluation` when available. Prefer SimDesign for systematic condition-by-replication studies, without imposing it on a small calculation that does not need an execution framework. The execution skill owns tested API details, failure retention, replay and result summaries.

Domain-specific identification and estimator assumptions belong to the relevant applied-analysis or psychometrics expertise. Generic Quarto authoring belongs to publishing. HPC/SLURM, multi-machine execution and external Mplus/Stan orchestration need separately validated requirements; do not design that infrastructure merely because a simulation might later grow.
