# Quarto-Bento Plugin Roadmap

## Current Scope

The independently released agent plugin provides one workflow skill for trusted local Quarto-Bento projects on Linux. Check the installed application version before selecting operations. The skill covers checked native design changes, reviewed source synchronization, rendering, and conservative recovery. App 0.2.0 adds reusable designs, computed-output layouts and scrolling, and selected inline widget and camera operations. App and plugin releases have independent version histories.

The Linux application 0.2.0 is published on npm with [source tag v0.2.0](https://github.com/brianmsm/quarto-bento/tree/v0.2.0). The earlier app candidate tests are evidence for the package tested at the time. See [architecture](architecture.md) for operating boundaries, the [changelog](../CHANGELOG.md) for plugin release changes, and [pilot findings](pilot-findings.md) for historical validation, including the owner-authorized scoped releases and the outcome of the earlier strict H2 evaluation.

## Validation Priorities

- Test changes against the actual released application version. For app 0.2.0, repeat focused render, camera, scrolling and PDF-continuation checks before broadening compatibility claims. Inspect the relevant outputs and saved state.
- Sample Studio-only operations, capture, reconstruction and interrupted-operation recovery. Preserve the backup-only `NO_BASELINE` case in recovery testing and keep recovery claims bounded to the results.
- Include targeted regressions for selected and excluded pending edits, source identity changes, post-Apply state, whole-deck HTML visibility and execution constraints. Use [validation cases](validation-cases.md) as a reviewer rubric.
- Use fresh agent trials where a change affects behavior. Verify actual skill reads and inspect source, state and output artifacts as relevant. Include optional companion-skill composition and an ordinary Quarto negative control when routing changes. Keep structural checks, application behavior and agent behavior distinct.

## Growth and Distribution

Prefer updates to the existing skill and references when the application contract changes. Consider a dedicated visual-design or recovery skill only when repeated tasks establish a distinct workflow that the current references cannot serve. Additional platforms and native host behavior need their own evidence before widening claims.

Follow the [repository release process](https://github.com/brianmsm/r-workflow-plugins/blob/feeaf6c71b70a1f5cac46b5f723d3ba613ac32e0/docs/release-process.md) for plugin version changes and catalog pins. Keep raw QA artifacts outside the standalone package.
