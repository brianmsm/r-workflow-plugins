# Recoding and Aggregation

Read when applying a known recode or changing the analysis unit. The rule comes from the user, dictionary or domain method; package convenience does not establish scientific validity.

## Visible Recodes

Retain the original column and inspect unfamiliar values before mapping them. `case_when()` uses the first matching branch; missing conditions fall through. Catch missingness before a substantive residual category. An invalid observed value is not automatically another kind of nonresponse.

```r
library(dplyr)

responses <- tibble::tibble(
  record_id = c("0007", "0042", "0100", "0210", "0350"),
  response = c(1, 3, 5, NA_real_, 8)
)
# Supplied rule: valid responses 1:5, reverse as 6 - response.
# Code 8 is retained in the raw column and flagged for review.
recoded <- responses |>
  mutate(
    unexpected = !is.na(response) & !(response %in% 1:5),
    reversed = case_when(
      is.na(response) ~ NA_real_,
      response %in% 1:5 ~ 6 - response,
      .default = NA_real_
    )
  )
recoded |> count(response, reversed, unexpected)
```

Expected reversed values: `5, 3, 1, NA, NA`; exactly one observed response is flagged. The example implements a given key; it does not infer which items should be reversed.

For categorical recoding, declare factor levels and reference category. Use `forcats::fct_relevel()` for a stated reference; do not infer ordinal order from alphabetical labels or convert factors to numbers by internal positions. For bins, declare boundaries and closure so boundary values are unambiguous.

Use `stringr` to normalize text only under an explicit matching rule, and inspect whether normalization merges formerly distinct identifiers. Parse dates with a known ordering using `lubridate` or readr; keep malformed originals for inspection. Convert a set of columns with `across()` only when the domain, units and missing rules are the same. Avoid broad numeric selectors that also capture identifiers or design variables.

## Aggregation Changes the Unit

Declare the input and target keys, eligibility rule, repetition handling, usable denominator and all-missing result. Distinguish row counts, distinct people, observed measurements and weighted totals. For proportions, state whether the denominator is all eligible cases or only observed responses.

```r
# Supplied rule: one row per participant, mean of observed visits;
# no observed visits means missing, with usable counts retained.
visits <- tibble::tibble(
  record_id = rep(c("0007", "0042", "0100"), each = 2),
  occasion = rep(1:2, times = 3),
  reading = c(10, 12, NA, 8, NA, NA)
)
by_participant <- visits |>
  summarise(
    records = n(),
    observed = sum(!is.na(reading)),
    reading_mean = if (all(is.na(reading))) NA_real_ else mean(reading, na.rm = TRUE),
    .by = record_id
  )
by_participant
```

Usable counts are `2, 1, 0`; means are `11, 8, NA`. This is a declared descriptive rule, not a validated instrument score or an imputation method. All-missing `sum(..., na.rm = TRUE)` returns zero and `mean(..., na.rm = TRUE)` returns `NaN`; choose and label the intended result instead of accepting it accidentally.

For a supplied weighted mean, define what the weights represent and which observations enter both numerator and denominator. Inspect missing/nonfinite weights, invalid signs and a zero denominator before calculation. Do not treat a weighted descriptive aggregate as a survey standard error; hand off design-based inference.

Use `.by` for a single operation or `group_by()` plus a deliberate grouping endpoint. Do not rely on inherited grouping or output row order for identity. Review labels and units of derived summaries; `summarise()` creates a new table and does not promise arbitrary attribute preservation. A participant-to-site aggregation supports a site-level description, not an individual-level association.

Checked APIs: dplyr 1.2.1, forcats 1.0.1, stringr 1.6.0 and lubridate 1.9.5. See [validation](../../../docs/validation.md).

Sources: [case_when](https://dplyr.tidyverse.org/reference/case_when.html), [summarise](https://dplyr.tidyverse.org/reference/summarise.html), [across](https://dplyr.tidyverse.org/reference/across.html), [factor releveling](https://forcats.tidyverse.org/reference/fct_relevel.html), [R4DS missingness](https://r4ds.hadley.nz/missing-values.html).
