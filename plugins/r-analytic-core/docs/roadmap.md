# R Analytic Core Roadmap

Read with [architecture.md](architecture.md). This is an evidence-driven plan for `r-analytic-core`, independent of the root repository's global roadmap and other plugins' releases.

## Phase 0: Local Scaffold and Content (Completed)

- Create one portable skill: `r-analytic-coding-principles`.
- Include only justified references for coding style and proportionate validation.
- Provide independent Codex and Claude Code manifests pointing to the **same** shared skill body.
- Add a narrow third reference on package search-path conflicts only after field testing exposed a real incorrect `select()` rewrite.
- During scaffolding, keep manifests at `0.0.0` and changes under `[Unreleased]`; version/tag the plugin only after validation. This development-stage rule has now been applied to the first `0.1.0` release.
- Check metadata, references, R syntax examples, and local plugin manifest validity.

## Phase 1: Behavioral Trials Before `v0.1.0` (Completed)

Use the requests and negative tests in [validation-cases.md](validation-cases.md). Run real agent sessions in fresh contexts when available; ideally compare baseline (without skill) to skill-enabled behavior on equivalent requests. Use synthetic files/data or authorized local data without packaging private examples.

Evaluate:

- Model specifications and estimations remain close to their associated sections, with shared preparation separate.
- Per-figure aesthetics remain directly editable instead of being hidden in wrappers.
- The agent preserves meaningful repeated code and does not impose `map()`/`lapply()` just for DRY.
- Helper functions are used for justified, stable mechanics instead of hiding analytical choices.
- Existing `library()` and `pkg::` choices are preserved or improved contextually: occasional versus recurrent use, precedence under actual package attachment order, `exclude`/`conflictRules`, and deliberate `MASS::select` only when needed.
- Temporary live checks remain outside the working analysis unless the result is substantive or future schema drift presents a concrete risk. **Existing reported key matches and other denominators remain unchanged** when guards are simplified.
- Statistical inputs, model syntax strings, model options, filters, random state, and results are not changed for style alone; separately editable CFA syntax strings are colocated with their fits.
- In `.qmd`/`.Rmd`, report frontmatter, chunk IDs/options, citations, and prose remain intact when only R computation is reorganized.
- Existing pipelines, package code, simulation engines, and non-R Quarto authoring are not rerouted to this style indiscriminately.
- Verification claims match actual execution and environment access.

Release criteria (met within the tested scope): valid skill/manifests; no unfinished placeholders; targeted R syntax and runtime checks; documented native agent trials including negative/out-of-scope cases; no unresolved material in-scope semantic regressions; and aligned plugin metadata, README and changelog. These checks support the first `0.1.0` release and do not guarantee all future R workflows.

### Observed pre-release failures, 2026-10-10

The first isolated Pi trials identified two confirmed material R failures (unsafe namespace removal and silently changed report metrics), a `.qmd` answer-integrity risk, and occasional non-loading of the advertised skill in Pi. The first three prompted bounded changes to the instructions and task references; the last is a harness/discovery testing concern, **not** a reason to add Codex-only logic to the skill. A follow-up round verified R conflict-management alternatives and succeeded on actual `.qmd` file edits with identical numerical outputs; however, Pi skill discovery/loading remains inconsistent. Native Codex CLI testing subsequently verified the local plugin installation and 8/8 explicit skill reads, but only 1/4 implicit reads; the compiled R and Quarto checks passed for the covered fixtures. Consult [pilot-findings.md](pilot-findings.md) and rerun fresh activation/negative cases before declaring `v0.1.0` readiness. No claim of a clean validation wave has yet been established.

### Prompt-level activation follow-up (2026-10-11)

A short **natural-language request explicitly asking for the research R coding style** reliably selected the skill in the tested Codex sessions: 17/18 GPT-6 Luna responses read the skill across original and concise descriptions; another 3/3 GPT-6 Sol sessions read it with the concise version. **No persistent routing rule was added to `AGENTS.md`.** The source frontmatter now uses the tested, shorter description. Selection for requests that merely mention editing R files remains opportunistic; do not confuse these results with guaranteed automatic activation or completed release certification. Details and limitations: [pilot findings](pilot-findings.md).

### Final scoped release-candidate gate (2026-10-11)

A fresh two-wave adversarial evaluation identified **one additional material failure**: when removing redundant data-key guards, an agent also deleted valid researcher-inspectable grouped and joined objects that happened not to feed the printed report. A narrow `SKILL.md`/reference correction now protects these analytical intermediates. Two **new independent post-fix waves** passed (4 + 6 distinct qualifying scenarios), including repeated intermediate-preservation checks, `MASS`/`dplyr`, Monte Carlo, CFA, joined input cardinality, R Markdown/Quarto rendering, package API contracts, and static-only reviews. The machine-readable field-test record passed its saturation validator. This is **bounded functional saturation for the tested scope**, not a guarantee of universal agent behavior.

A separate Quarto-format-only case correctly did not activate `r-analytic-core`, but the Codex host falsely claimed a YAML edit it had not made; this **out-of-scope host completion failure** is documented, not counted as an in-scope skill success. The R package API case also unnecessarily read the core skill but preserved its API contract. Refer to [pilot findings](pilot-findings.md). This gate supported the independent **`v0.1.0` release**, which was subsequently published with tag-pinned Codex and Claude Code marketplace entries.

## Phase 2: `v0.1.x` Correction Cycle

Fix observed activation errors, unnecessary abstraction, package namespace inconsistencies, misplaced diagnostics, and false claims of verification. Prefer corrections to `SKILL.md` and its existing references over new scripts/skills. Summarize reusable, non-sensitive findings in the plugin docs; keep raw case data local.

## Phase 3: Conditional Specialized Skills

After varied real trials, decide whether independent repeated tasks justify extracting any candidates named in [architecture.md](architecture.md). Split only with clear triggers and fewer routing ambiguities. Avoid creating a generic router just because the number of references grows.

## Phase 4: Optional External Quality Tools

Consider standalone read-only consistency checks only if actual cases recur: mismatched repeated specifications, mislabeled model sections, output references to wrong objects, or join cardinality drift. Evaluate false positives, costs and the need for intentional exceptions. Hooks/CI are optional consumer integrations, **not** a dependency of this plugin; never add them to user projects unrequested.

## Version and Distribution

The first validated release is `v0.1.0`, recorded in both plugin manifests and the changelog and pinned by the public Codex and Claude Code catalogs to `r-analytic-core-v0.1.0`. Later development commits on `main` do not change the published plugin; a new independently tagged release and a separate catalog update are required. See the repository [release process](../../../docs/release-process.md).
