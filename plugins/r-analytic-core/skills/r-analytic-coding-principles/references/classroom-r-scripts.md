# Student-Facing R Code in Scripts and Notebooks

Use this reference **only when writing or revising R code that students will execute during a lesson**, in `.R` scripts or `.Rmd`/`.qmd` notebooks. It specializes [r-analytic-coding-principles](../SKILL.md). The core skill already covers explicit analytical calls, repetition, editability, helper boundaries, and result preservation; do not restate or replace it here.

## Start from the classroom task

Identify the specific **models, comparisons, or decisions learners must execute and interpret**. Distinguish those from teacher-side simulations, validation, advanced diagnostics, and answer keys.

**Teaching priority:** minimize *incidental concepts* and unnecessary code. When 10 clear lines provide the same information and statistical meaning as 30, prefer the 10, especially in learner-facing code. Keep analytical choices visible and explanations near the corresponding results; do not shorten by hiding essential assumptions, uncertainty, or editable model specifications.

When earlier course scripts exist, **inspect representative predecessors before writing a new one**:

- Carry over the recognizable header and section marker formats, updating session-specific details. Match indentation, naming, comment density, imports, and package setup conventions.
- Reuse the established order of inspecting data, fitting models, and reporting results.
- Depart from those conventions only for a clear teaching or analytical reason.

## Shape the script around what learners do

- Use a short sequence: **load data → specify → fit → inspect → interpret**. Name each section after the learning action (e.g., `# Comparación ML y MLR ----`).
- Keep the model or formula and its native fit call (`cfa()`, `lm()`, etc.) in view. Adjacent repeated calls are useful when the lesson is **what changes between models**, even if the code could be looped.
- **Choose output for communication, not familiarity alone.** Prefer the model's native summary when its arguments already show the relevant estimates, fit and uncertainty clearly (e.g., `summary(fit, fit.measures = TRUE, standardized = TRUE)` for a `lavaan` fit).
- **Use a formatter when native output is insufficient or hard to read.** Prefer established class-compatible tools such as `parameters::model_parameters()` for regression estimates or `performance::model_performance()` for fit metrics, when they add value. Do not write a custom formatter for an equivalent built-in result. Follow existing course conventions and verify that the package supports the fitted model and requested statistics.
- Keep each inspection beside the step it supports. Give each printout a distinct role in a learner's decision, comparison, or interpretation. Repeat a result only when learners need it again, for example in a later comparison. Teach manual extraction when it is itself the learning objective. Verify that a formatter preserves the reported estimator, scale, and uncertainty.
- Use brief comments to orient learners, explain a choice, or guide interpretation. On the final read-through, remove repeated explanations, revision history and commentary that merely translates the next line of code. Keep headings, prompts and comments accurate and restore context where a standalone activity needs it. Put extensive reasoning, theory, and full solutions in the teaching notes or handout.
- Keep taught and reproduction-critical nondefault settings visible. Limit a reproduction-specific setting to the example that calls for it. Omit redundant arguments only after verifying the effective defaults. At first use, explain consequential settings in the script or accompanying learner material by naming the quantity, scale, or uncertainty they affect and why they suit that analysis. Verify both that projected calls match the canonical script and that its consequential settings receive this explanation. Incidental options need only enough explanation to run the example.
- **Main lesson script:** keep the guided progression and brief in-class exercises together in one `.R` or `.qmd`, including small respecification or replication tasks. Create a separate practice script for a dedicated independent work period, substantial reinforcement activity or genuinely separate execution path; group related exercises rather than creating a file per question.
- **Instructor-led walkthrough:** keep calls executable and comments brief. Put extended questions, caveats, and explanations in the slides or instructor notes.
- **Learner-led practice:** state the question in the handout or near a purposeful blank. A walkthrough may also contain a labeled blank when learners complete it live. Keep other sections executable.
- **Standalone/asynchronous script:** include enough context to work without a lecturer. Use descriptive object names unless mathematical notation is being taught.

For example, when the estimator is the learning choice, keep both calls together rather than hiding the difference:

```r
fit_ml  <- lavaan::cfa(modelo, data = datos, estimator = "ML")
fit_mlr <- lavaan::cfa(modelo, data = datos, estimator = "MLR")
```

Do not turn every script into a tutorial about loops, defensive programming, or a particular output package. If those are the **learning objectives**, the corresponding operations belong in the script.

## Preserve the current learner script

When revising a supplied classroom script, **inspect the latest file and preserve the instructor's intervening edits**, model specifications, comments that carry meaning, and working outputs. Make targeted changes rather than regenerating the whole file from an older draft. Verify the affected section after editing.

## Keep classroom inputs self-contained

- Make the student script or notebook runnable from the **lesson folder** with documented local `data/` files where practical. A verified small dataset can be simpler than dependencies on undistributed parent folders.
- Follow the course’s data-inspection order. Preview the raw file when helpful and verify any column-range selectors against the actual data.
- Select fields in the call that needs them. When tidying an existing script, trace any column-only copy through its consumers: if summaries, transformations and formula-based models can use the original table with identical results, remove the redundant copy. Preserve selections that define a score, sample, analysis matrix or intentional teaching object. Keep meaningful derived variables and eligible samples visible where students first need them.
- Make the entry point and any standalone practice file obvious; distribute only learner-facing files that serve a distinct purpose.
- State required packages in advance. For shared setup use ordinary `library(pkg)` statements **one per line**; use `pkg::fun()` when only one function is needed. Keep per-exercise calculations in their own chunk, not all in a hidden opening mega-chunk.
- **Avoid automatic setup:** no package auto-installation, path probes, `renv` bootstrap, or generic `stopifnot()` guards just for reassurance. Let native errors surface.
- **Keep installation guidance manual:** a short commented command is enough unless environment management is itself part of the course.
- **Report in matching units:** reuse established reporting tools when suitable; ensure each estimate and interval refer to the same metric (e.g., b versus β).
- An optional script that uses objects from the main script must state **run the main script first** and have a name describing its actual content.

## Keep teacher evidence separate

Long Monte Carlo runs, seed sweeps, validation logs, checksums, complex diagnostics, and answer keys may stay in teacher artifacts. **Do not delete substantive research computations** to shorten the student-facing script; separate the audience-facing path while preserving the evidence.

Projected "run this" snippets must refer to **objects and files present in the canonical student path**. Otherwise label the display as a **teacher demonstration**, not an executable student task. Omit agent-only `lavInspect(..., "post.check")` or similar boolean checks from student scripts unless diagnostics are explicitly taught or needed for an ongoing analytical decision; explain consequential model problems rather than printing an isolated TRUE/FALSE.

## Verify the student handoff, not only the development folder

When execution is permitted, run the canonical student script or notebook in a **clean, lesson-shaped directory containing only delivered materials**, using documented packages. Check names, relative paths, representative results and consistency with slides/handouts. Run dependent optional extensions after the main activity.

Avoid adding defensive wrappers, file-location detection, or QA checks to the student's code merely because the agent needed them during verification. Preserve genuine warnings that affect interpretation.
