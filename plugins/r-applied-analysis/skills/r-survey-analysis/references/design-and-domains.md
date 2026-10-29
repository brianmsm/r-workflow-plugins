# Survey designs, domains and replicate variance

Read before analyzing a probability sample or changing an existing design. The examples use new synthetic records and a with-replacement first-stage variance approximation; their weights do not document any real survey.

## Design information changes inference

| Component | Establish before analysis |
| --- | --- |
| Weight | Final sampling/nonresponse/calibration meaning, unit and population scale. Frequency and precision weights are different. |
| PSU/cluster | Actual first and subsequent sampling stages. Reused IDs across strata need correct nesting; unique person IDs cannot replace PSUs. |
| Stratum | Sampling strata, not every substantive subgroup. A domain is a population subset, not necessarily a design stratum. |
| FPC | Known population size or sampling fraction for the relevant stage. A sample group size is not an FPC. Omission implies a with-replacement approximation at the top stage for the ordinary design. |
| Replicates | Provider's BRR/Fay/jackknife/bootstrap type, combined weights, scale, rscales, Fay coefficient and centering (mse). Column names alone do not identify these. |
| Missing design variables | Resolve from documentation/source provenance. Do not invent weights, clusters or strata, or silently drop records with missing design information. |

Inspect PSUs per stratum and the design's actual df, not just the record count. A singleton PSU may be a documented certainty unit or a variance-estimation problem. Preserve the project/provider policy: `survey.lonely.psu`, domain adjustments and replicate construction have different implications. Do not choose "adjust", "average" or "certainty" merely to remove an error; document any justified policy and its sensitivity.

## A synthetic Taylor design

Here PSU IDs repeat across strata; `nest = TRUE` relabels them. It does not correct genuinely wrong IDs. The data have four sampled PSUs per stratum and four records per PSU. There is no asserted FPC.

```r
library(dplyr)

survey_data <- tidyr::expand_grid(
  stratum = factor(c("S1", "S2")), psu = 1:4, person = 1:4
) |>
  mutate(
    weight = if_else(stratum == "S1", 2, 3),
    x = person + psu / 4,
    score = 10 + 2 * x + 3 * (stratum == "S2") +
      c(-4, -1, 2, 5)[psu] + c(-1, 1, -0.5, 0.5)[person],
    event = as.integer((person + psu + as.integer(stratum)) %% 3 == 0),
    domain = psu <= 3 & person <= 2,
    score_observed = if_else(psu == 3 & person == 2, NA_real_, score),
    observed_score = as.integer(!is.na(score_observed)),
    eligible = 1
  )
psu_counts <- survey_data |>
  distinct(stratum, psu) |>
  count(stratum, name = "n_psu")
psu_counts

survey_design <- survey::svydesign(
  ids = ~psu, strata = ~stratum, weights = ~weight,
  data = survey_data, nest = TRUE
)
summary(survey_design)
survey::degf(survey_design)
getOption("survey.lonely.psu")
```

For actual multistage designs, use the documented stage-specific IDs/FPCs and PPS rules; a working single-stage call does not validate a complicated design. This slice does not construct/calibrate weights.

## Domains preserve the parent design

Build the design on the full sampled records covered by the sampling documentation, with valid design metadata, then subset the design. Express analytic eligibility as a domain when appropriate. PSUs with no domain members still contribute zeros to the parent design's domain variance calculation. Rebuilding from filtered rows can discard that information.

```r
domain_design <- subset(survey_design, domain)
domain_counts <- survey_data |>
  filter(domain) |>
  summarise(
    n_eligible = n(),
    n_observed = sum(observed_score),
    n_missing = sum(is.na(score_observed)),
    weight_sum = sum(weight),
    observed_weight_sum = sum(weight * observed_score)
  )
domain_counts

domain_mean <- survey::svymean(~score, domain_design)
domain_mean
domain_mean_ci <- confint(
  domain_mean, level = 0.95, df = survey::degf(domain_design)
)
domain_mean_ci

domain_proportion <- survey::svyciprop(
  ~event, domain_design, method = "logit",
  level = 0.95, df = survey::degf(domain_design)
)
domain_proportion
confint(domain_proportion)

domain_totals <- survey::svytotal(~eligible + event + observed_score, domain_design)
domain_totals
domain_observed_mean <- survey::svymean(
  ~score_observed, domain_design, na.rm = TRUE
)
domain_observed_mean

stratum_means <- survey::svyby(
  ~score, ~stratum, survey_design, survey::svymean,
  na.rm = TRUE, vartype = "se"
)
stratum_means
```

The complete score is available only for fixture validation. The `score_observed` analysis estimates a weighted mean among observed outcomes; `na.rm = TRUE` does not repair outcome nonresponse. The constant-one total estimates the domain population only when the weights have that population interpretation. If weights are normalized, do not label their sum a population count.

A `svymean()` indicator estimates a proportion; a bounded interval from `svyciprop()` may be preferable to a normal interval. State its method and df. Boundary estimates of zero or one need special attention: logit intervals can fail, and switching methods requires checking the documented assumptions/support. Ordinary binomial intervals do not inherit the survey variance.

The mean interval above deliberately uses a t reference with domain design df. The default `confint(svystat)` normal approximation is a different choice. `svyby()` standard errors do not by themselves specify an interval/df procedure. For design effects, state the reference design and estimand; neither weight sum nor a generic weight-only formula is a universal effective N.

## A bounded replicate example

For a known ordinary stratified Taylor design, JKn conversion is an inspectable example. Construct replicates from the full design before subsetting. Provider-supplied replicate weights should instead be declared with `svrepdesign()` using their documented metadata; do not replace them with this synthetic conversion.

```r
survey_replicates <- survey::as.svrepdesign(
  survey_design, type = "JKn", mse = TRUE
)
domain_replicates <- subset(survey_replicates, domain)
domain_replicate_mean <- survey::svymean(~score, domain_replicates)
domain_replicate_mean
confint(
  domain_replicate_mean, level = 0.95, df = survey::degf(domain_replicates)
)
```

Replicate df depend on the replicate design/rank. A ratio mean's finite-replicate variance need not exactly equal Taylor linearization. Retain the variance method in reporting. Here `mse = TRUE` centers replicate deviations on the full-sample estimate.

## Sources and checks

Primary [survey manual](https://cran.r-project.org/web/packages/survey/refman/survey.html): sections `svydesign`, `subset.survey.design`, `surveyoptions`, `svyciprop`, `svyby`, `as.svrepdesign` and `svrepdesign`. Lumley's [Complex Surveys companion](https://r-survey.r-forge.r-project.org/survey/) provides the book/software context; use the CRAN manual or installed help if that site is unavailable.

Checked with survey 4.5 and R 4.6.1. [Validation](../../../docs/validation.md) checks a weighted mean against an explicit ratio, its Taylor variance against stratum/PSU influence totals including zero-domain PSUs, and replicate variance against the actual replicate-weight formula. BRR/Fay/bootstrap/PPS and real provider metadata are not certified by the JKn example.
