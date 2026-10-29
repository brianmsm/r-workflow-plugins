# Failures, Denominators and Performance

Read before changing error handling, filtering results or reporting operating characteristics. Methodological starting point: [Morris, White and Crowther (2019)](https://doi.org/10.1002/sim.8086). Engine behavior: [SimDesign error handling](https://philchalmers.github.io/SimDesign/articles/Catch_errors.html) and [runSimulation controls](https://philchalmers.github.io/SimDesign/reference/runSimulation.html). API claims below were tested with SimDesign 2.28.

## Preserve the Experiment

| Event | Appropriate treatment |
| --- | --- |
| Expected nonconvergence or scientifically inadmissible fit | Retain the attempt, native diagnostic category and unavailable outputs; define metric eligibility. |
| Valid draw that cannot identify the method | Retain as a method outcome unless the study explicitly conditions the DGP otherwise. |
| Invalid condition/DGP implementation | Correct the design/code; do not hide it as estimator performance. |
| Unexpected exception, missing field or inconsistent return schema | Stop the pilot and investigate. Do not convert every error to `NA`. |
| Warning with a usable fit | Inspect its meaning; retain warning counts/categories separately from usability. |
| Fatal or interrupted condition | Report incomplete execution and planned versus observed counts; do not summarize it as fully evaluated. |

If an estimator signals an expected failure by throwing an exception, catch only a recognized class or a specifically verified diagnostic at that method's call. Record its category and preserve the dataset for the other methods. Re-throw unrecognized exceptions. A broad `tryCatch(error = function(e) NA)` can hide a programming defect and select a misleading result set.

In SimDesign 2.28, thrown errors trigger new data generation until a retained result or the consecutive-error limit. Numeric `NA` and `NaN` can also trigger redraws. `max_errors` is a top-level argument, not a `control` field. Its default limit concerns consecutive errors for an attempted retained replication, not total study failures.

- `allow_na = TRUE` retains numeric `NA`.
- Set **both** `allow_nan = TRUE` and `allow_na = TRUE` explicitly to retain `NaN`: `is.na(NaN)` is also true. With explicit `allow_na = FALSE`, `allow_nan = TRUE` still rejects `NaN`.
- In 2.28, supplying only `allow_nan = TRUE` also retains ordinary `NA`: the internal `control$allow_na` partially matches that list element. Do not rely on this omission behavior; state both controls. Supplying only `allow_na = TRUE` still rejects `NaN`.
- `Inf` is not automatically rejected by these missing-value controls. Inspect finiteness explicitly.
- Do not switch to list output merely to evade the numeric checks.
- `max_errors = 1L` with `stop_on_fatal = TRUE` aborts on an unexpected thrown error. Expected scientific failures must already be handled as records.
- Warnings do not normally redraw. Converting warnings to errors can redraw the whole dataset and change the estimand.

`SimErrors()` records engine errors, not all scientific method failures. `SimWarnings()` counts emitted warnings, potentially several per replication; dividing that count by attempts is not automatically the proportion of affected replications. Record a per-method warning flag if that proportion matters. Check the final object's fatal field as well as engine diagnostics.

## Define the Eligible Sets

For a completed condition and method, let B be the number of generated attempts. Preserve planned B separately and verify completion. Let E be the prespecified eligible-estimate set, S the usable-SE set, and I the valid-interval set. Keep their counts \(B_E,B_S,B_I\). Retain convergence/admissibility categories even when their counts coincide in a simple study.

Finiteness alone is insufficient: an estimate can be finite after nonconvergence or an improper solution. Conversely an estimate may be usable when its SE is unavailable, so do not discard it from bias just because an interval is absent. Interval eligibility depends on the method; finite ordered endpoints are appropriate for the starter, while an intentionally unbounded valid interval may need different rules. A percentile-bootstrap interval may be usable without a separately reported model SE; do not require I to be a subset of S for such a method.

Report both numerators and denominators for rates. Use status categories for missing/nonfinite results; never replace an unavailable estimate, test or interval with zero. Explicitly select the relevant set before taking a mean. Generic `na.rm = TRUE` over an unexplained mixture is not a policy.

## Metrics and Monte Carlo SE

Let \(e_r=\widehat\theta_r-\theta_r\), using replication-specific truth when needed. The formulas below assume independent outer replications within a condition, a fixed inclusion rule, finite required moments, and sufficient eligible observations. Conditional metrics concern the distribution selected by that rule; they do not identify performance on failed attempts.

| Quantity | Estimate | MCSE or qualification |
| --- | --- | --- |
| Bias on E | \(\overline e\) | \(\mathrm{sd}(e)/\sqrt{B_E}\) |
| RMSE on E | \(\sqrt{\mathrm{mean}(e^2)}\) | Delta approximation: \(\mathrm{sd}(e^2)/(2\,\mathrm{RMSE}\sqrt{B_E})\) |
| Empirical SE | SD of the eligible estimates | The familiar SE/\(\sqrt{2(B_E-1)}\) is a normal-sampling approximation, not universal. |
| Mean model SE on S | Mean of the method's eligible reported SEs | MCSE of this mean is SD(SE)/\(\sqrt{B_S}\). Label arithmetic mean versus root mean squared SE explicitly. |
| Coverage on I | \(B_I^{-1}\sum_{r\in I}1(L_r\leq\theta_r\leq U_r)\) | \(\sqrt{\widehat c(1-\widehat c)/B_I}\) |
| Failure rate | Failed attempts / B | \(\sqrt{\widehat f(1-\widehat f)/B}\) for a binary failure indicator |
| Joint available-and-covering rate | Valid covering intervals / B | \(\sqrt{\widehat j(1-\widehat j)/B}\) |
| Rejection rate on available tests | Rejecting tests / eligible tests | Same Bernoulli MCSE with the test denominator; call power only under the specified alternative and size/type I error under the specified null. |

The RMSE formula follows the delta method applied to the sample mean of squared errors. It needs a finite fourth moment; very heavy tails can invalidate a reassuring-looking MCSE. MCSE here is uncertainty from finitely many simulated datasets, not an estimator's within-dataset SE.

If the eligible count is zero, return `NA` for bias, RMSE and conditional coverage, with the zero count explicit. If it is one, sample-SD MCSE is undefined. At RMSE zero the delta expression is undefined; return `NA`, not infinity or an invented zero. Boundary event rates can yield plug-in MCSE zero despite uncertainty; use binomial intervals where material. The starter reports plug-in MCSE and does not claim zero observed failures establishes perfect reliability.

For paired methods, compute differences on the same replication IDs and the prespecified common eligible set. For example, coverage difference has MCSE \(\mathrm{sd}(C_{A,r}-C_{B,r})/\sqrt{B_{\mathrm{pair}}}\). Do not combine marginal MCSEs as if paired results were independent. Show each method's own eligible count and the pair count; restricting to common successes can change both recovery targets. For a comparison over all attempts, define a paired binary utility such as available-and-covering before computing differences.

The starter compares interval rules sharing the same slope estimate, so their bias/RMSE coincide; it does not pretend to compare different point estimators.

## Optional rsimsum

[rsimsum::simsum()](https://ellessenne.github.io/rsimsum/reference/simsum.html) can complement a well-defined results table. It was **documentation-reviewed, not runtime-tested**, because it was not installed in the validation environment. It is not a dependency of this slice.

Its documented `control$na.rm = TRUE` excludes missing estimates or SEs. Keep the attempt/status table independently, specify the eligible population deliberately, and verify returned counts. An SE exclusion must not silently redefine an estimate-only metric. Supply actual interval endpoints with `ci.limits`, or the correct degrees of freedom through `df`, when normal Wald intervals are not the intended procedure. Confirm estimate, SE, true-value, method and condition columns, compare a small summary to transparent formulas, and retain all failures in the accompanying report before using its output.
