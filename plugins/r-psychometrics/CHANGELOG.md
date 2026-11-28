# Changelog

## [Unreleased]

## [0.2.0] - 2026-11-28

### Added
- Extended single-level path workflows to multiple indirect routes, contrasts and conditional effects with delta, Monte Carlo and bootstrap inference. Documented estimation, test, interval and reporting choices separately.
- Added diagram guidance for CFA and basic SEM, including mediation layouts and checks against the model specification.

## [0.1.1] - 2026-11-21

### Changed
- Preferred native `lavaan` summaries for inspection and `psymetrics` fit/estimate tables for focused reporting and supported descriptive CFA/SEM comparisons.
- Kept descriptive table comparisons distinct from inferential difference tests and separated agent-side checks from displayed student/report outputs.
- Preserved WLSMV index-family and uncertainty distinctions; recorded prospective behavior cases separately from executed evidence.

### Verification
- Synthetic method suite and independent ordinal suite rerun successfully, including 6/6 targeted ordinal checks. Prospective behavioral cases remain unexecuted.

## [0.1.0] - 2026-10-29

### Added

- Initial item/reliability, exploratory factor analysis and conventional CFA/basic SEM skills.
- Eight on-demand method references with new synthetic examples and primary sources.
- Explicit ordinal WLSMV EFA and the intentional scaled-fit reporting default.
- Native lavaan summaries and class-bounded psymetrics fit/parameter reporting and comparisons.
- Synthetic verification of documented code, native numerical quantities and substantive failure signals, plus an independently designed ordinal check.
- Bounded fresh behavioral review and explicit incomplete-ordinal-data decision boundaries.
- Scope, second-delivery boundaries and an integration handoff.

### Limits

- First release covers only the initial three skills; advanced methods remain out of scope.
- Invariance and basic IRT remain a second delivery; advanced psychometric methods remain deferred.
- psymetrics covariance labeling is documented under existing issue #55; no package source changes.

### Release hardening

- Use native parameter-table fields for unavailable-SE diagnostics; clarify threshold/df behavior and contextual EFA retention evidence; inspect invalid responses and analysis-sample constant items.
- Preserve the intentional scaled WLSMV index default and add the native Antigravity adapter.
