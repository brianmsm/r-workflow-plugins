# Changelog

## [Unreleased]

## [0.1.0] - 2026-10-29

### Added

- Two independently usable skills for ADEMP simulation design and SimDesign execution/evaluation.
- Conditional references for precision planning, failure-aware metrics, installed API behavior, RNG recovery and storage.
- An original serial OLS slope study with natural non-identification, paired interval methods, analytical benchmarks, explicit denominators and Monte Carlo SE.
- Targeted validation of raw-result retention, engine NA/NaN/error behavior, fatal and warning diagnostics, exact seed replay, and local two-worker PSOCK reproducibility.
- Independently versioned Codex, Claude and Antigravity adapters at `0.1.0`.

### Boundaries

- rsimsum was documentation-reviewed and remains optional.
- Automatic interruption/resume, disk-backed result extraction, alternative parallel backends, distributed execution and external simulation engines are not established support claims.

### Release hardening

- Make lowercase `design` and top-level `store_results` explicit; retain failure denominators, computed benchmark values and all claimed Monte Carlo SEs.
- Add the native Antigravity adapter without changing simulation scope.
