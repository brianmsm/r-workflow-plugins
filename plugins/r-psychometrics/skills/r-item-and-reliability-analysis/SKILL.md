---
name: r-item-and-reliability-analysis
description: "Use when inspecting questionnaire or test items, implementing a declared scoring key, or estimating internal consistency and factor-model reliability in R. Use factor-analysis skills for dimensionality or model specification."
---

# Item and Reliability Analysis

Establish what score is being interpreted, for which population and use. Reliability concerns that score under stated assumptions; it is not evidence by itself that a scale is unidimensional or valid.

## Establish the Measurement Task

- Identify the item response scale, valid categories, key direction, intended subscales, sampling unit and missing-item rule. Check labels against actual values before recoding.
- Preserve raw items. Reverse only items identified by the instrument's key, using the declared scale endpoints. Do not reverse from sample correlations or delete items to maximize a coefficient.
- Inspect category counts, missingness, floor/ceiling patterns and corrected item-rest associations within the intended score. Keep available-item and complete-score denominators explicit.
- For scoring and classical internal consistency, read [items-and-consistency.md](references/items-and-consistency.md). Its synthetic example includes a declared reverse key and an explicit complete-score rule; those are example decisions, not defaults for every instrument.

## Choose the Reliability Target

- Use `psych::alpha()` for a justified classical coefficient. Distinguish raw alpha for a sum on the original item metric from standardized alpha for standardized items. Set `check.keys = FALSE` and `delete = FALSE` after deliberate keying, and inspect constant items on the actual analysis rows before estimation. Inspect `r.drop`, item variances, coefficient uncertainty and substantive content; alpha-if-deleted is a diagnostic, not a selection algorithm.
- Explain the assumptions connecting alpha to score reliability, including essential tau equivalence and uncorrelated errors. A large alpha can reflect redundancy or test length. A universal reliability cutoff cannot decide adequacy for an intended use.
- For an admissible congeneric CFA, read [model-based-reliability.md](references/model-based-reliability.md) and use `semTools::compRelSEM()` with the score metric and denominator choice explicit. Ordered-category scores and their underlying continuous responses have different reliability targets.
- Do not treat exploratory `psych::omega()`, CFA-based composite reliability, alpha, temporal stability and rater agreement as interchangeable. Exploratory hierarchical omega requires a justified structure and is outside this initial recipe.
- If the measurement model is unknown, combine with `r-exploratory-factor-analysis`; if specified, use `r-cfa-sem` before interpreting model-based reliability. Do not turn an unreliable or inadmissible model into a polished coefficient table.

## Keep the Analysis Inspectable

Keep keying, score construction and each coefficient beside their diagnostics. Use ordinary dplyr/tidyr operations and editable ggplot2 displays when appropriate; preserve a user's established idiom. The optional `r-analytic-coding-principles` capability can help organize code but is not an installation dependency.

Report the population/sample, item set, score metric, missing-data handling, usable N, coefficient and uncertainty method, model assumptions and relevant limitations. A point estimate alone does not describe score precision for each individual. Do not present a factor score or prorated total as error-free.

## Boundaries

This skill supports item diagnostics, declared scoring, classical alpha and conventional single-group CFA-based reliability. General import/joins belong to data preparation; general imputation, survey variance, test-retest and rater-agreement procedures need their own supported method. Invariance and basic IRT are a later delivery; DIF, bifactor/S-1, linking and advanced score methods are deferred. An out-of-scope request can still be handled with appropriate expertise, but must not be described as validated by this skill.
