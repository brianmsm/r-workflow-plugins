# ADEMP and Monte Carlo Precision

Read when designing the experiment or setting replication counts. The framework follows [Morris, White and Crowther (2019)](https://doi.org/10.1002/sim.8086); the specification below and the bundled study are original examples.

## A Protocol That Can Be Implemented

| Component | Decision to record | Example used in this plugin |
| --- | --- | --- |
| Aims | Which methods or assumptions are being evaluated, and what result would inform a decision? | Compare two slope-interval rules while measuring loss of estimability under rare binary predictors. |
| Data-generating mechanisms | Sampling unit, distributions, dependence, missingness, condition grid, and quantities held fixed | Independent subjects; `x ~ Bernoulli(p)`; `y = 0.5 + 0.7*x + Normal(0, 1)`; n = 20/80; p = .05/.50. |
| Estimand | Population quantity, scale, and any condition-specific truth | The population slope 0.7, fixed across replications and conditions. |
| Methods | Visible fitting call, estimator, tuning, admissibility and interval/test construction | `lm(y ~ x)`; Student t interval using residual df; normal-critical-value interval using the same fitted SE. |
| Performance | Measures, denominators, target Monte Carlo precision, and comparisons | Bias/RMSE on identifiable estimates; coverage on available intervals; rank-failure rate and joint available-and-covering rate on all attempts. |

Record the condition table and seed mapping together. Preserve explicit cell identifiers when subsetting or extending a grid. A crossed design is useful when factors can vary independently; a scenario table is clearer for constrained combinations. Do not silently discard inconvenient conditions.

Distinguish three experiments: fixed population parameters with new samples, parameters that vary by condition, and population parameters re-sampled within each replication. If truth changes by replication, preserve its value beside that replication's estimate; a fixed `true` argument in a summary package is then inappropriate.

Reusing one dataset across methods produces paired comparisons. Reusing common random numbers across conditions creates additional dependence and needs a deliberate design. An inner bootstrap or stochastic optimizer is part of the evaluated method, not an independent outer replication.

## Define Outcomes Before Running

Separate valid DGP draws from method failures. In the example, a constant binary predictor is an ordinary random sample. It does not identify the slope. Its probability is

\[
P(K=0 \text{ or } K=n)=(1-p)^n+p^n,\qquad K\sim\mathrm{Binomial}(n,p).
\]

Conditioning the generator on `0 < K < n` would answer a different question. Keep those samples, mark their unavailable estimates, and count them in the attempt denominator. OLS here has no iterative convergence statistic; do not invent one. A nonlinear estimator may additionally need convergence, inadmissibility and warning categories.

For each method distinguish planned attempts, completed records, returned fits, converged fits (if applicable), admissible results, finite estimates, usable SEs, and available intervals. Their sets may differ. Specify whether finite estimates from nonconverged fits are eligible; the usual recovery analysis excludes them. State the criterion rather than relying on finiteness alone.

Bias/RMSE and coverage conditional on availability describe selected subsets when failures occur. Accompany them with failure and availability rates. A joint available-and-covering rate over all attempts is also useful, but is not an ordinary coverage probability without that definition.

## Choose Replications From Precision

For an independent Bernoulli outcome with probability \(p_*\), the plug-in MCSE is \(\sqrt{\widehat p(1-\widehat p)/B}\). For planning,

\[
B \geq \left\lceil p_*(1-p_*)/s^2 \right\rceil
\]

targets an MCSE no larger than \(s\). Use \(p_*=0.5\) as the worst-case bound if no useful prior value exists. For approximately 95% coverage and MCSE .005, the usual planning calculation needs 1,900 **eligible intervals**; the conservative Bernoulli bound is 10,000. A target 95% Monte Carlo interval half-width \(h\) uses \(s=h/1.96\), under the normal approximation.

These formulas describe precision at the assumed rate. If only a fraction \(a\) yields eligible intervals, \(\lceil B/a\rceil\) planned attempts reaches the target eligible count only in expectation. Use pilot uncertainty to budget conservatively; report the realized count. Do not keep drawing until a chosen number of successes unless that stopping rule and its uncertainty calculation are part of the design.

For bias, use \(\mathrm{sd}(e)/\sqrt{B_E}\), where \(e\) is estimation error and \(B_E\) is the prespecified eligible-estimate count. Pilot estimates of \(\mathrm{sd}(e)\) support planning. RMSE requires variability of squared errors; see the execution skill's performance reference. For paired method differences, plan using variability of the within-replication differences, not two independent MCSEs.

An observed event rate of zero has plug-in MCSE zero but does not establish a zero population probability. Use an exact or Wilson binomial interval when boundary uncertainty matters; with zero events in B independent attempts, the one-sided 95% exact upper bound is \(1-0.05^{1/B}\). Prefer a fixed sample size for this first workflow. Adaptive stopping needs a separately justified precision/interval rule.

## Pilot and Benchmark Plan

Use a tiny serial run to check schema, denominators, warnings, and seed recovery. Force at least one expected unavailable result, one unexpected exception and one all-unavailable cell in validation. Then run a small complete experiment and compare against a known case.

For the example, on identifiable samples:

- The expected slope is 0.7.
- Given K exposed observations, slope variance is \(n/[K(n-K)]\).
- Conditional MSE averages that expression over \(K=1,\ldots,n-1\), normalized by \(P(0<K<n)\).
- The t interval has 95% conditional coverage under the specified normal homoskedastic DGP.
- The normal interval's coverage is \(2F_{t_{n-2}}(z_{.975})-1\).

The starter uses 500 attempts per cell to demonstrate the full workflow quickly. It does not establish a precision budget for a substantive study or resolve small performance differences.

## Source and Support Boundary

ADEMP is a methodological framework, not a package API. See also [Chalmers and Adkins (2020)](https://doi.org/10.20982/tqmp.16.4.p248) for simulation implementation and [SimDesign documentation](https://philchalmers.github.io/SimDesign/). The complete example uses independent outer replications and a fixed truth; clustered, nested, adaptive and parameter-mixture simulations require their own estimand and MCSE calculation.
