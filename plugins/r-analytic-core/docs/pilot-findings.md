# R Analytic Core — Initial Field Findings

This summary contains only **synthetic, reusable lessons** from isolated Pi and native Codex trials on 2026-10-10. Raw prompts, model outputs, and logs remain under the repository's ignored `output/field-tests/` and are **not bundled with the plugin**.

## Scope and Limits

The pre-release `0.0.0` skill was made available to agents in isolated Pi sessions using two different model/provider configurations. The initial evaluation recorded 22 usable responses (14 with the skill advertised, eight controls), and two blinded reviews of problematic rewrites. All generated `.R` snippets parsed, but parsing alone could not establish semantic correctness. The original agent source was not edited during that evaluation.

### F01: Namespace simplification can change the resolved function

One candidate removed `dplyr::select()` while `MASS` was attached after `dplyr`. Direct R execution confirmed that plain `select()` resolved to `MASS::select`, causing an argument error. Corrective guidance now chooses package attachment versus explicit namespaces based on actual use, and documents `library(MASS, exclude = "select")`, prior `conflictRules()` and optional `{conflicted}` with real resolution checks. **Do not require a new package dependency for one conflict.**

### F02: Removing temporary checks must preserve actual analytical outputs

One candidate deleted the original key-match count from a reporting table and introduced a new total based on a column present only in a derived data frame. In R, that missing `$` column silently returned `NULL`; `sum(NULL, na.rm = TRUE)` yielded an incorrect zero. Guard removal is distinct from changing substantive diagnostics: verify field provenance, reported names, denominators, and values. Use targeted direct R inspection when authorized rather than inventing defensive scaffolding in the research script.

### F03: Skill advertised is not necessarily skill read

Some Pi trials announced the skill but the agent did not read the advertised `SKILL.md` path. This concerns the evaluation harness/agent discovery, not the universal skill content. Track *available*, *read*, and *applied* separately. A native Codex installed-plugin test is documented below; native Claude Code was not tested and is not required for this Codex-specific evaluation. Do not add runtime-specific workarounds to the portable `SKILL.md` merely for a Pi retrieval issue.

### F04: `.qmd` / `.Rmd` source integrity is distinct from R computation locality

A chat-output `.qmd` rewrite successfully moved fits but fenced the document frontmatter as YAML and dropped original result-chunk labels. Code-only organization should leave YAML frontmatter, prose, chunk IDs/options, references and output behavior intact. Validate **actual temporary file edits** separately; a Markdown-formatted assistant answer is not itself a tested Quarto source file.

### F05: Keeping CFA syntax next to its fitting decision

One rewrite moved `cfa()` fits near their summaries but left the per-model `lavaan` syntax strings in a distant combined setup block. When each model is revised independently, the syntax declaration and its fit both belong in that model's local section. Shared deliberately identical definitions remain a valid exception.

## Follow-up Hardening and Retesting (2026-10-10)

The new rules were checked with base R 4.6.1 (`dplyr` 1.2.1, `MASS` 7.3-66). Both `library(MASS, exclude = "select")` and a **prior** `conflictRules("MASS", exclude = "select")` let plain `select()` resolve to `dplyr`; `MASS::select()` remains available. Setting a rule after `MASS` was attached does not retroactively unmask `dplyr`'s function. `{conflicted}` also works when explicitly enabled, but it is not required by the plugin.

A subsequent isolated assessment included two independent model/provider configurations, source rewrites, one-off package-use and Monte Carlo controls, and a real temporary `.qmd` editing test. A GPT-6 Luna trial that actually read the skill correctly applied `library(MASS, exclude = "select")`. Another trial with only the skill **advertised**, not read, dropped namespace qualification while still attaching `MASS` later; R execution reproduced the masking error. Thus **skill-loading reliability remains a separate open limitation**: passing outputs when the skill is loaded do not establish automatic discovery.

For diagnostics, checked follow-up outputs preserved `n_escuelas` and `n_coincidencias`, including the observed synthetic result of three schools and two matching identifiers. No repeat of the prior false `sum(NULL)` result was found among the inspected candidate outputs. Both revised CFA examples whose agents read the skill placed each independent model syntax string near its fit. Two real temporary `.qmd` edit trials preserved YAML, prose, chunk labels and statistical formulas; all three Quarto renders (original and two edited versions) completed, with identical model coefficients and AIC values.

**Not release-certified.** The tests are bounded, and some independent sessions did not load the skill or could not locate files when prompts were missing filenames. The earlier failures remain explicit regression cases. No clean-wave saturation was claimed at that stage. Subsequent native Codex installed-plugin verification is documented below. The next release gate requires reliable skill discovery and further independent negative tests before `0.1.0`.


## Native Codex Plugin Trials (2026-10-10)

After the user reauthenticated the native Codex CLI, the local `r-analytic-core` **`0.0.0` plugin successfully registered, installed and ran** in a separate, temporary `CODEX_HOME` using a local test marketplace. No released marketplace entries or personal plugin installations were changed. Evaluations used Codex CLI 0.162.0 with **GPT-6 Luna and GPT-6 Sol only**; no Astra model was used.

- **16 independent native Codex runs:** 4 control runs without the plugin, 4 with the installed plugin available for automatic selection, and 8 with explicit `$r-analytic-coding-principles` invocation. Across these, `SKILL.md` was actually read in **8/8 explicit** runs but only **1/4 implicit** runs. Registration/discovery in the catalog is not equivalent to activation on a user request.
- **Package conflict regression:** with `library(dplyr)` followed by ordinary `library(MASS)`, both the no-plugin control and skill-installed-but-unread outputs removed `dplyr::select` qualification and failed when executed in R. The explicit skill-loaded version read `SKILL.md` and `package-conflicts.md`, used `library(MASS, exclude = "select")`, and **executed successfully**. A GPT-6 Sol case where `dplyr` was needed only once kept `dplyr::select()` without attaching `dplyr`, also passing R execution.
- **Reported diagnostics:** original `n_escuelas=3` and `n_coincidencias=2` were preserved in evaluated variants (including the explicit skill case), avoiding the earlier `sum(NULL)` corruption. Controls also passed; this is regression evidence, not an exclusive advantage of the skill.
- **Model/figure locality:** GPT-6 Sol colocated separate CFA syntax strings with their fit and summary; GPT-6 Luna produced three native, independently editable `ggplot` blocks. All reviewed R outputs parsed, and the three plot objects were built with synthetic data. The implicit graphics case did read `SKILL.md`, while the other three implicit cases did not.
- **Intentional simulation automation:** GPT-6 Sol preserved Monte Carlo iteration and produced exactly the same synthetic numerical bias/RMSE values as the original under the same seed and design.
- **Actual `.qmd` edits:** one control and one explicit skill-loaded Codex session edited separate temporary files. Both preserved frontmatter, source prose, result chunk labels/options and formulas. Original, control, and skill-edited files all rendered with Quarto and yielded identical coefficients and AIC.

**Current verdict:** Native Codex plugin **installation and explicit skill invocation are verified**. Tested behavioral preservation is favorable, especially for the namespace conflict, but **automatic skill selection is inconsistent (1/4)** and neither cross-model reliability nor full field-test saturation is established. Do not label the plugin release-ready solely from these results. Further work should focus on activation boundaries, not adding a hard Codex dependency or inventing new scripts/hooks within the core skill.

Raw local evidence, agent events, tested fixtures and independent R/Quarto checks are retained only under the ignored `output/field-tests/r-analytic-core/2026-10-10-codex-native/` directory; no private source material was included.

## Prompt-Level Style Invocation (2026-10-11)

Rather than editing `AGENTS.md` or requiring users to type `$r-analytic-coding-principles`, a new **isolated native Codex** comparison tested Spanish natural-language user prompts starting with *"Usa el estilo de codificación para investigación en R"* or *"Usa el estilo de r-analytic-core"*. The rest of each request specified a synthetic R file and task (model locality, `MASS`/`dplyr` namespace resolution, or removing unnecessary guards without changing report outputs).

- GPT-6 Luna: **18 runs**, six each for three tasks across the original long and tested concise descriptions and three prompt phrasings. The long description led to **8/9** actual `SKILL.md` reads, and the concise description led to **9/9**. **The natural research-style prefix without the technical skill name activated in 6/6 runs across both descriptions.** One overly generic long-description prompt failed to locate a file and did not read the skill; this is not proof of a distinct trigger defect.
- GPT-6 Sol: **3 additional tests** of the same natural research-style prefix with the concise description, with **3/3** actual `SKILL.md` reads. Synthetic R code parsed; package and diagnostic examples executed successfully, preserving the checked matching count (`n_escuelas=3`, `n_coincidencias=2`).
- Overall, **20/21** prompt-level runs loaded the skill, with **12/12** for the concise description across the tested Luna/Sol scenarios. This establishes encouraging performance **for explicitly asking for the research coding style**, not for generic editing requests or automatic selection in every situation.

The source skill's **frontmatter description only** was shortened to the tested concise version. The instructions in the body, references, and agent-independent architecture were not modified. No `AGENTS.md` rule, scripts, hooks, public plugin registration, or release metadata were added. The experiment records and exact synthetic prompts remain in ignored `output/field-tests/r-analytic-core/2026-10-11-prompt-invocation/`.

**Outstanding release gate:** These bounded, correlated tests do not establish statistically quantified recall, saturation, or broad reliability for every task. Complete the agreed functional/negative tests and a final release review before publishing `0.1.0`.

## Final-Gate Finding: Intermediate Object Preservation (2026-10-11)

A fresh native Codex wave found an important boundary not covered by prior successful tests: an agent simplified a data-key diagnostic script and preserved all values in the **printed** coverage table, but also deleted a grouped aggregation and the output of a join because they were not currently referenced by the printed table. These are legitimate inspectable analytical objects in an iterative research workflow. Their absence is a material regression despite unchanged printed numbers.

The skill and verification reference now explicitly state that removing redundant guards does **not** permit deleting named intermediate aggregations, joins, derived datasets or diagnostics merely because a final table does not use them yet. `docs/validation-cases.md` adds a corresponding adversarial scenario. Two independent post-fix waves are required before release certification; do not conflate the original failing wave with qualifying clean waves. The raw synthetic fixture and execution evidence are held only under ignored `output/field-tests/r-analytic-core/2026-10-11-final-gate/`.

## Scoped Final Validation and Saturation (2026-10-11)

The closure assessment used isolated native Codex CLI sessions running GPT-6 Luna and GPT-6 Sol, with a complete plugin snapshot installed locally. Two initial waves exposed a **new material regression**: when simplifying a fixed-data key diagnostic, the agent deleted both a grouped table and a joined dataset because neither appeared in the current printed table. A researcher might still need those named intermediate objects for later investigation. The tested instruction fix explicitly prohibits deleting analytical aggregations, joins and derived objects merely because they lack a current downstream reference.

**After that correction**, two fresh independent waves with 4 and 6 distinct **qualifying R coding** cases passed their own R/source/Quarto validators. Both new intermediate-preservation contexts kept the grouped and joined working objects. Other verified boundaries included heavy versus occasional `MASS`/`dplyr` use, a duplicate-reference cardinality trap, preservation of Monte Carlo loops and exact numerical bias/RMSE, CFA syntax locality and fit measures, Quarto YAML/chunk/source preservation and render equivalence, R package API errors, and static review with unavailable data. Both post-fix waves met the field-test methodology's 3+ cases per wave and no recurring material plugin failure; the machine-readable record reached **scoped saturation**.

Two nonblocking limitations remain explicitly recorded:

- In a **Quarto-format-only task outside this skill**, native Codex correctly did not load the R coding skill but falsely claimed to have changed a theme/TOC in an unmodified `.qmd`. This was excluded from the in-scope functional saturation count; it is not a passing Quarto formatting test and should not be attributed to this plugin.
- In an **R package API editing task**, Codex loaded the general R coding skill even though package engineering is outside its primary trigger boundary. The checked API behavior and error messages were preserved, but unnecessary activation is worth monitoring as more specialized plugins appear.

The local candidate is **functionally ready for a human-reviewed `0.1.0` release decision within its tested scope**, not yet published or certified across other agent runtimes. No `AGENTS.md` routing was added, and no extra hooks/scripts/assets were introduced. Keep the plugin version at `0.0.0` until the independent release process begins. Full raw synthetic evidence is retained in Git-ignored `output/field-tests/r-analytic-core/2026-10-11-final-gate/FIELD_TEST_REPORT.md`; repository documentation intentionally contains only this sanitized summary.

## First Release Record — `v0.1.0` (2026-10-11)

After the two qualifying post-fix native Codex rounds and successful plugin, skill, R/Quarto and evidence validators, the project prepared the initial independent `r-analytic-core-v0.1.0` release. The shared skill body remains agent-neutral; Codex plugin activation and local installation were tested, while native Claude Code behavior was not. Historical pre-release findings above retain their original dates and statuses.

The Git release tag identifies the immutable plugin source state. Making the tag available on GitHub and adding the tag-pinned public marketplace entries are separate publication steps; local versioning and commits alone do not imply remote distribution.
