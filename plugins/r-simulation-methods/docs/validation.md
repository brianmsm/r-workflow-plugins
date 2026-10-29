# Initial Validation Evidence

Date: 2026-10-29. Scope: the first two skills and the original synthetic slope study. This is sanitized developer evidence, not a report from private research.

## Provenance and Authoring

- Work started on branch `epic/research-simulation-20261029` at `8068a4740976d77561fbd2750ebb48b309e0221b`, with a clean worktree.
- Only `plugins/r-simulation-methods/` was changed. Root documents, catalogs, other plugins, main, tags and releases were outside the write scope.
- Repository instructions, architecture, roadmap, naming/release rules, all four Research Methods EPIC documents, and the core research-coding skill were read before implementation.
- Local skill-creator and plugin-creator guidance was consulted before creating skills/manifests. The existing repository adapters and version policy took precedence over cloud/account defaults.
- The existing SimDesign-specific skill and relevant workflow, organization, diagnostics, validation and traceability references were read only. Rules were independently expressed and checked against primary sources/runtime behavior. No original template was copied.
- No private research script was executed. No private data, paths, filenames, variable names, code or study-specific results were included. The optional private research collections were not needed.
- Root was the only writer; delegated work was read-only review and bounded synthetic execution.

## Versions and Evidence Levels

| Component | Observed version / state | Evidence |
| --- | --- | --- |
| R | 4.6.1 (2026-06-24) | Executed clean-session Rscript calls |
| SimDesign | 2.28 installed | Formals/namespace inspection and executed behavior |
| Separate SimDesign source checkout | 2.25.4, commit `fa04a3e1a879604b1293ffffd2f4e6630d0ba64a` | Read-only code/docs review, not execution of that checkout |
| dplyr / tidyr | 1.2.1 / 1.3.2 | Study and tests |
| ggplot2 / scales | 4.0.3 / 1.4.0 | Display generation and image inspection |
| readr | 2.2.0 | CSV output |
| rsimsum | Not installed | Primary documentation only; no installation or runtime claim |
| Codex / Claude plugin adapters | Repository-compatible JSON at 0.0.0 | Syntax/types/paths reviewed; native host installation not tested |

Primary methodological sources: [Morris, White and Crowther (2019)](https://doi.org/10.1002/sim.8086) and [Chalmers and Adkins (2020)](https://doi.org/10.20982/tqmp.16.4.p248). Package references are linked at the point of use in the skills. Website versions do not replace the installed-version record.

Both skills passed the local official `quick_validate.py`. Both R files parsed. The structural validator checks syntax/naming and scaffold issues; it does not establish methodological correctness or native-host activation.

## Complete Small Study

The DGP is \(X\sim\mathrm{Bernoulli}(p)\), \(Y=0.5+0.7X+\epsilon\), \(\epsilon\sim N(0,1)\), with independent subjects and replications. It crosses n = 20/80 and p = .05/.50. Population parameters stay fixed. Both interval methods use the same native `lm(y ~ x)` estimate and SE; one uses \(t_{n-2}\), the other the normal critical value.

A three-replication pilot ran for two cells before the 500-attempt-per-cell study. The master seed was 87105, mapped with `genSeeds()`; the recorded RNG kind was L'Ecuyer-CMRG / Inversion / Rejection. All **2,000 planned attempts** remain in raw results. OLS rank failure is a scientific non-identification outcome, not iterative nonconvergence.

| n | Predictor prevalence | Attempts | Rank failures | Eligible estimates / intervals | Bias | RMSE | t coverage | Normal coverage | Joint available-and-covering, t |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 20 | .05 | 500 | 172 | 328 | .012457 | .872468 | .948171 | .942073 | .622 |
| 80 | .05 | 500 | 9 | 491 | -.008309 | .567036 | .953157 | .953157 | .936 |
| 20 | .50 | 500 | 0 | 500 | -.002635 | .459324 | .954000 | .940000 | .954 |
| 80 | .50 | 500 | 0 | 500 | -.000423 | .223526 | .948000 | .948000 | .948 |

Bias/RMSE use eligible estimates; conditional coverage uses available intervals. The final column uses all 500 attempts. Counts are not interchangeable.

| n | Prevalence | MCSE(bias) | MCSE(RMSE), delta | MCSE(t coverage) | MCSE(normal coverage) | MCSE(t joint rate) |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 20 | .05 | .048243 | .037627 | .012240 | .012899 | .021685 |
| 80 | .05 | .025613 | .021709 | .009536 | .009536 | .010946 |
| 20 | .50 | .020562 | .015852 | .009368 | .010621 | .009368 |
| 80 | .50 | .010006 | .007862 | .009929 | .009929 | .009929 |

These are small-run results, not an adequately precise comparison for publication. In two cells no simulated interval changed coverage status between the two methods, giving an observed paired difference and plug-in MCSE of zero; this does not establish equal population coverage.

Independent analytical targets were:

| n | Prevalence | Failure probability | Conditional RMSE | t coverage | Normal coverage |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 20 | .05 | .358486 | .909146 | .95 | .934332 |
| 80 | .05 | .016515 | .583055 | .95 | .946428 |
| 20 | .50 | .000001907 | .460414 | .95 | .934332 |
| 80 | .50 | approximately \(1.65\times10^{-24}\) | .225055 | .95 | .946428 |

The conditional MSE was computed by taking the binomial-probability-weighted sum of \(n/[K(n-K)]\) over the nondegenerate binomial counts and dividing by their probability. Bias has target zero. The maximum absolute discrepancy across bias, RMSE, coverage and failure targets was **0.974811 Monte Carlo SE**, using theoretical Bernoulli variance for failure-rate checks. This stochastic agreement is a diagnostic; it is separate from exact arithmetic checks.

## Targeted Numerical and Engine Checks

The maintained [validation script](../tests/validate-simulation.R) checks consequential behavior rather than text matching:

| Case | Observed result |
| --- | --- |
| Raw record accounting | Exactly 500 per cell; expected failure counts retained; engine error/warning tables empty |
| Independent model calculation | Native slope/SE agree with a separate two-group mean-difference and pooled-variance calculation to \(10^{-12}\) |
| Different estimate/interval denominators | Hand fixture B = 4, eligible estimates = 3, eligible intervals = 2; bias = 0, RMSE = \(\sqrt{2/3}\), coverage = .5, joint rate = .25 |
| MCSE arithmetic | Hand fixture bias MCSE \(1/\sqrt3\), RMSE MCSE \(1/\sqrt{24}\), coverage MCSE \(\sqrt{.25/2}\) |
| All-unavailable cell | Zero eligible counts; bias/RMSE/conditional coverage are NA, joint rate zero; no accidental NaN summary |
| One estimate / zero RMSE | Sample-SD MCSE undefined for one value; delta RMSE MCSE undefined at RMSE zero |
| Native numeric-NA redraw | 12 retained records required 19 generated samples and 7 engine errors |
| Intentional NA retention | 12 attempts produced 12 records, including 4 NA results and no engine errors |
| Engine-error seed recovery | A stored error seed reproduced the previously discarded NA-producing draw after explicit retention was enabled |
| NA/NaN controls | Explicit `allow_na=TRUE, allow_nan=TRUE` retained NaN; allowing NA alone rejected it; explicit `allow_na=FALSE, allow_nan=TRUE` rejected it |
| Partial matching in 2.28 | Omitting `allow_na` while setting `allow_nan=TRUE` also enables NA retention through list `$` partial matching |
| Infinity | Numeric Inf is retained by native missing-value controls; scientific finiteness checks remain necessary |
| Unexpected exception | Strict `max_errors=1` / `stop_on_fatal=TRUE` stopped after one generation |
| Fatal row | A non-stopping fatal case had `FATAL_TERMINATION` while `SimErrors()` had zero rows |
| Warnings | Four warnings accompanied four retained records without redraw |
| Stored-result replay | RDS readback plus stored RNG states reproduced a valid record and a rank-failed record exactly |
| Local PSOCK after serial checks | Two workers, eight replications in two cells; repeated scientific outputs equal; stored parallel-record replay exact |
| Serial versus PSOCK | Scientific records **not equal** under the same condition seeds; no cross-backend identity claim |

The first engine-test draft incorrectly inferred from separate NA/NaN checks that `allow_nan=TRUE` alone must reject NaN. Execution disproved that inference. A targeted follow-up identified R list partial matching, and the reference/test were corrected before completion. The starter already specified both flags explicitly; its numerical results did not change.

The image device emitted host font-configuration messages. The PNG was created and visually inspected successfully. These messages are not SimDesign estimator warnings; no environment configuration was altered.

## Independent Review and Sampled Agent Behavior

An independent methodological reviewer checked the proposed DGP, natural identification failure, paired interval interpretation, analytical benchmarks, conditional denominators and MCSE formulas against primary literature. The reviewer endorsed this bounded design and did not recommend additional scope. This was source/formula review, not an independent execution or final-file audit.

A fresh evaluator read the two skills, their relevant references and the synthetic asset, without reading this validation document or other agents' analyses. It completed three realistic requests:

| Request | Observed behavior |
| --- | --- |
| Natural-language interval comparison, about 30% failures, coverage MCSE strictly below .005 | Selected the design skill; distinguished 1,901 eligible intervals at assumed .95 coverage from 2,716 expected attempts at .70 availability; offered fixed 3,000/15,000-attempt planning options with assumptions; preserved pairing and failure denominators. |
| Explicit execution/evaluation request with 40 records, 30 eligible estimates, 20 valid intervals and 18 covering | Used 30 for bias/RMSE, 20 for conditional coverage (.90), and 40 for joint availability-and-coverage (.45); returned NA for zero-RMSE delta MCSE; preserved the separately defined SE count and original replay identities. |
| Labelled CSV join and duplicate IDs, without simulation | Selected neither simulation skill; handed off to data preparation without adding replication machinery. |

The evaluator's arithmetic/implementation response and replay plan were reviewed. Its submitted R probe did not return usable output, so this evidence supports sampled routing, methodological response and code design, **not independently executed replay or serialization**. Its original read encountered the earlier NA/NaN statement; the final correction is supported by the primary execution recorded above. A short bootstrap-interval example clarified why interval eligibility need not require a reported model SE.

A separate delegated API audit also obtained no usable tool results before cancellation. It is recorded as **incomplete**, not as a second successful runtime audit. All executed SimDesign tests in this document are the primary writer's direct local executions. The source/formula review and fresh-agent behavior remain separate evidence levels. These cases do not establish native-host implicit activation, installation or broad multi-agent reproducibility.

## Reproduction and Remaining Limits

From the plugin directory:

```sh
Rscript --vanilla tests/validate-simulation.R
```

The script creates local ignored `output/` artifacts and records its validation summary in `output/validation.rds`. The study asset also preserves source fingerprint, full result object, raw rows, seeds, fixed objects, session metadata, CSVs and the display. Raw execution logs are not part of the public payload.

Tested backend support is narrow: local Linux, two-worker PSOCK with `use_mirai=FALSE`, one generator and one numeric analysis callback. Other worker counts, mirai/future, stochastic preparation, automatic crash resume, disk-backed extraction/re-summary, distributed runs and external engines need their own bounded validation. RDS readback and seed replay do not prove automatic restart.

No statistical package was installed or upgraded. No push, tag, release or catalog mutation was performed. The initial small study and structural checks do not establish native host installation, universal automatic activation or scientific adequacy of a future domain study.
