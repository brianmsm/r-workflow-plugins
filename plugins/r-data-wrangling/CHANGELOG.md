# Changelog

## [Unreleased]

## [0.1.0] - 2026-10-29

### Added

- Two focused skills for research-data import/types and transformation/integration.
- Conditional references for delimited/Excel import and export metadata, labelled and missing-value semantics, declared recodes and aggregation, equality joins and stacking, and repeated-observation reshaping.
- Small synthetic numerical cases covering leading-zero identifiers, partial value labels and SPSS user missings, cardinality and unmatched joins, recorded versus absent occasions, and usable aggregation denominators.
- Compatible Codex, Claude and Antigravity skills-only manifests without new runtime dependencies.

### Scope

- First independently tagged release, with all supported host manifests at `0.1.0`.
- In-memory research tables and supplied deterministic rules. Imputation, score validity, sampling variances, inferential models, database backends and production orchestration remain outside the initial support claim.
- Structural, numerical and bounded agent evidence are reported separately in `docs/validation.md`.

### Release hardening

- Add the native Antigravity adapter and tag-pinned developer-evidence links that remain valid when individual skills are extracted.
