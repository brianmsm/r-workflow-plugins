# Initial Validation Findings — 2026-10-17

This is evidence for the local **agent plugin draft `0.0.0`**, not a release announcement. Application baseline: installed `qbento 0.1.0`, JSON protocol v1, Linux; product checkout `a1b8025f522a5c4c70d10e613f9a7923dc6f761c`. The application's version and the companion plugin's version are independent.

## Checks and Their Meaning

- **Underlying application:** eight focused source-repository API tests passed (get/patch/sync/render, creation, atomicity, bounded inputs and identity/revision checks). This confirms the product baseline, not agent behavior.
- **Embedded examples:** all three QMD examples in `authoring-components.md` rendered with the installed CLI and passed native-envelope validation. A real geometry patch preserved QMD bytes; a stale request was rejected and a later invalid batch operation left earlier edits unapplied.
- **Native Codex behavior:** fifteen fresh sessions, using GPT-6 Luna and GPT-6 Sol, exercised new projects, visual-only editing, source edits, data-driven rerender, stale revisions, incompatible computed edits, wrong-document binding, source components, an ordinary revealjs negative case and optional Quarto performance composition. No Astra model was used.
- **Actual loading:** the skill body was observed in 13 of the 14 Bento-related sessions. One initial computed-value refusal attempted nonexistent skill paths and then correctly refused based on the source without loading the skill; do not attribute that successful refusal to the skill. An explicit follow-up did load it and preserved the whole project. The ordinary revealjs task did not load Bento or create a sidecar.

## Corrected Finding: Optional Sync Is Still a Source Mutation

One initial data-only request asked to preserve QMD. The agent updated data and retained design correctly, but also applied a valid, optional annotation-only sync plan, adding `.qbento-design` classes to QMD. The initial wording did not adequately distinguish a valid plan from an authorized/necessary source change.

The core skill and synchronization reference now state: data/design-only tasks do **not** authorize source sync; a no-source-edit request preserves the QMD bytes, including IDs, comments and annotations. Sidecar design retention does not require applying optional annotations. Two fresh Luna/Sol tests of changed-data regeneration passed afterwards with identical source hashes, changed computed mean/figure, stable `docId` and retained geometry/background.

An additional post-fix pending-text test inspected the actual sync plan, applied it within already authorized scope, generated a receipt and rerendered successfully. This confirms that the correction does not indiscriminately prohibit legitimate synchronization or impose another confirmation when the user has already approved the change.

## Environment and Composition Observations

The default native Codex workspace sandbox prevented Chromium's debugging endpoint from starting. Ordinary text/figure renders could continue with `TEXT_MEASUREMENT_UNAVAILABLE`; a component render was blocked. Agents disclosed that limitation rather than claiming visual validation. The identical component source rendered successfully outside the actor sandbox. A new agent run permitting network access **only for that isolated invocation** completed the local-browser-dependent render with no diagnostics. No machine/global sandbox settings were changed; arbitrary visual/UI workflows remain unverified.

In a combined installation, the agent read both `quarto-bento-workflow` and `quarto-computation-performance`. It saved a background change without executing QMD or synchronizing another author's pending text, and explained that saving state did not require a cache or render. This supports optional composition for the tested case; it does not establish every cross-plugin handoff. No companion skill source was changed.

## Current Status and Remaining Work

The initial ten trials yielded eight independently passing task artifacts, one material source-scope failure (corrected), and one environment-blocked component render. Five fresh follow-ups passed after the correction or environment adjustment. Do **not** combine these into a misleading all-tests-pass count or a universal reliability claim.

This is initial validation, **not the final release gate**: there has been one post-fix follow-up set, not two qualifying independent clean waves. Studio-only UI actions, capture/reconstruction/interrupted-operation recovery, broader mixed-skill tasks and visual presentation quality need further validation before a first public release claim. The plugin stays local `0.0.0`; no public catalogs, tags, commits, `AGENTS.md` routing rules, bundled scripts or automatic app installation were added.

Full synthetic evidence is retained outside the distributable plugin under the monorepo's ignored `output/field-tests/quarto-bento/2026-10-17-initial/`. The shared instruction body is agent-neutral; native runtime testing here was Codex/Linux, not Claude or other platforms.

## Adversarial R5 Remediation (2026-10-17)

R2-C001, confirmed and dynamically reproduced in the second R5 adjudication, identified a missing execution warning: `reconcile --apply resolution.json` runs Quarto again to verify the reviewed reconciliation plan. The previous instructions emphasized execution during preview but omitted the apply phase. The core skill, operation-effects table, Studio decision-save description and recovery procedure now explicitly require execution authorization for **both phases**. An unchanged QMD hash is not evidence that computation did not occur. An already-authorized decision and its execution do not require redundant reconfirmation. No application code was changed.

The three reported monorepo-only contributor links, plus the same issue in the roadmap, were replaced with immutable external repository-document links. The isolated 13-file plugin payload was reinstalled and its local references and external Git blob targets checked. The plugin remains independently installable with one skill and three references.

A separate implementer-run validation used ten fresh native Codex sessions, five GPT-6 Luna and five GPT-6 Sol, on synthetic workspaces. It does **not** substitute for the independent R4 review or revise the existing R5 verdict. A direct installed-CLI execution-counter probe reproduced `1 -> 1 -> 2 -> 3` after initial render, patch, reconciliation preview and valid apply. Six focused product reconciliation tests passed; these are product evidence, distinct from actor behavior.

The new actors covered a preprepared reconciliation plan under a no-execution instruction, authorized semantic sync without execution, recomputation while retaining exact QMD bytes, read-only pending-state/performance inspection, an authorized reconciliation apply, a stale payload with another author's edits, an uninitialized QMD, impossible literal alteration of computed content, and a Reveal.js-only negative control. The critical no-execution actor did not run reconcile apply; the authorized actor did run it once, incremented the execution counter, saved the selected state and kept QMD bytes intact. The source-only uninitialized-QMD task also succeeded without rendering when the corrected installed skill was explicitly loaded; an unnecessary first-render/refusal defect was not reproduced.

**Loading limitation:** one natural-language source-only task searched a wrong installed path, then read an older local snapshot instead. Its artifact was correct, but it does not validate the corrected candidate. Raw traces show returned old content even though a later command made the compound shell exit nonzero. A fresh explicit follow-up read the correct skill and completed the source-only task safely. Overall, eight Bento-related runs demonstrably returned the corrected body, one returned the old body, and the ordinary Reveal.js control did not load Bento. Nine of ten runs satisfy both task and expected-loading checks; do not label these ten uniform candidate passes.

All runs used the normal per-process Codex workspace sandbox without broadening network policy. One allowed render disclosed unavailable Chromium text measurement; no visual/UI-quality acceptance is claimed. These are new remediation observations, not two newly certified clean independent audit waves. The independent R4/R5 completion and release decision remain pending. Studio, real edited-HTML capture, interrupted recovery, Claude and non-Linux operation remain explicitly outside the validated behavioral scope.

New evidence is stored separately under ignored `output/field-tests/quarto-bento/2026-10-17-r5-remediation/`; the original reviews and test evidence remain unchanged. A font-free, text-only derivative of R2 evidence is included for future archival use, without rewriting R2's original record.
