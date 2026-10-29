# Labels and Missing Values

Read before converting labelled research inputs. Distinguish the stored value, variable label, value-label map, measurement level and missing reason. Metadata preservation and analysis-type selection are separate decisions.

## Preserve Before Converting

For SPSS, use `haven::read_sav(..., user_na = TRUE)` when missing codes/ranges must survive import; the default `FALSE` converts them to ordinary `NA`. Use `labelled::look_for()`, `var_label()` and `val_labels()` to inspect a dictionary, together with `attr(x, "na_values")` and `attr(x, "na_range")`. Keep the imported object.

SPSS user missings retain numeric codes but `is.na()` on `haven_labelled_spss` includes those codes and ranges. Count missing reasons from the preserved representation before numeric conversion. Conversely, `as.double()` alone can expose missing codes as ordinary numbers. Use `zap_missing()` deliberately when collapsing them for analysis.

```r
library(dplyr)

original <- tibble::tibble(
  record_id = c("0007", "0042", "0100", "0210", "0350", "0480"),
  response = haven::labelled_spss(
    c(1, 2, 7, 97, 99, NA_real_),
    labels = c(low = 1, high = 7, not_applicable = 97, not_recorded = 99),
    na_values = c(97, 99),
    label = "Recorded category"
  )
)
dictionary <- labelled::look_for(original)

prepared <- original |>
  mutate(
    response_code = as.double(response),
    missing_reason = case_when(
      response_code == 97 ~ "not_applicable",
      response_code == 99 ~ "not_recorded",
      is.na(response_code) ~ "system_missing",
      .default = NA_character_
    ),
    response_numeric = as.double(haven::zap_missing(response))
  )
prepared |> count(missing_reason, name = "records")
```

The six codes remain inspectable; the derived numeric values are `1, 2, 7, NA, NA, NA`. Each missing reason occurs once. The unlabelled code `2` is observed, not a missing value.

## Choose the Analysis Representation

- A labelled measurement can remain numeric after declared missing conversion. A nominal category needs an explicit factor/reference level; an ordinal category needs a justified order. Factor order also affects model contrasts, which the model-owning workflow must confirm.
- `haven::as_factor(x, levels = "default")` uses labels where available and retains unlabelled values. `levels = "labels"` turns unlabelled values into `NA`; check coverage before choosing it.
- `as_factor()` alone can preserve SPSS user-missing codes as factor categories. Normalize missingness first when that is the intended analysis policy.
- After conversion, inspect both observed values and factor levels. Unused labels for missing codes can remain among the levels. Remove or reorder levels only under the declared category scheme.
- Preserve missing reasons separately when meaningful. For tagged missings, use `haven::is_tagged_na()` and `na_tag()` before `zap_missing()`; ordinary comparisons to a tagged `NA` do not identify its tag.
- Do not assume all label-removal functions have identical missingness semantics: haven's SPSS `zap_labels()` also converts user missings by default. Keep the original dictionary and use an explicit conversion sequence.

A transformed variable needs a reviewed label/unit and possibly a new value map. Do not carry an old label map onto different codes. Check metadata conflicts when stacking waves; sharing numeric codes does not establish equivalent categories.

Checked APIs and installed S3 method bodies: haven 2.5.5; dictionary accessors: labelled 2.16.1. [Validation](https://github.com/brianmsm/r-workflow-plugins/blob/r-data-wrangling-v0.1.0/plugins/r-data-wrangling/docs/validation.md) separates SPSS round-trip tests, in-memory tagged-missing tests and formats not executed.

Sources: [haven semantics](https://haven.tidyverse.org/articles/semantics.html), [SPSS import](https://haven.tidyverse.org/reference/read_spss.html), [factor conversion](https://haven.tidyverse.org/reference/as_factor.html), [missing conversion](https://haven.tidyverse.org/reference/zap_missing.html), [labelled introduction](https://larmarange.github.io/labelled/articles/labelled.html).
