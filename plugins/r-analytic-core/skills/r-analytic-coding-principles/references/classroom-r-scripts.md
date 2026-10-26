# Student-Facing R Code in Scripts and Notebooks

Use this reference **only when writing or revising R code that students will execute during a lesson**, in `.R` scripts or `.Rmd`/`.qmd` notebooks. It specializes [r-analytic-coding-principles](../SKILL.md). The core skill already covers explicit analytical calls, repetition, editability, helper boundaries, and result preservation; do not restate or replace it here.

## Start from the classroom task

Identify the specific **models, comparisons, or decisions learners must execute and interpret**. Distinguish those from teacher-side simulations, validation, advanced diagnostics, and answer keys.

**Teaching priority:** minimize *incidental concepts*, not line count. Keep analytical choices visible and explanations near the corresponding results.

## Shape the script around what learners do

- Use a short sequence: **load data → specify → fit → inspect → interpret**. Name each section after the learning action (e.g., `# Comparación ML y MLR ----`).
- Keep the model or formula and its native fit call (`cfa()`, `lm()`, etc.) in view. Adjacent repeated calls are useful when the lesson is **what changes between models**, even if the code could be looped.
- Prefer a familiar summary or high-level comparison function when it already displays the requested result. Keep immediate inspection beside the fit; if extracting specific results (`fitMeasures()`, `parameterEstimates()`, etc.) is a learning objective, teach it in a later, clearly labeled section instead of repeating equivalent output after each `summary()`. Do not introduce `subset()`, joins, extraction plumbing, or several output objects **unless manipulation itself is the lesson**.
- Use brief comments for the next choice or interpretation; put extensive reasoning, theory, and full solutions in the teaching notes or handout.
- Prefer **one canonical student code path** per teaching unit: an `.R` script with editor sections, a `.qmd` with exercise chunks, or a standalone activity. Do not split a session into files merely because it has several exercises; label longer/exploratory variants as optional.

For example, when the estimator is the learning choice, keep both calls together rather than hiding the difference:

```r
fit_ml  <- lavaan::cfa(modelo, data = datos, estimator = "ML")
fit_mlr <- lavaan::cfa(modelo, data = datos, estimator = "MLR")
```

Do not turn every script into a tutorial about loops, defensive programming, or a particular output package. If those are the **learning objectives**, the corresponding operations belong in the script.

## Keep classroom inputs self-contained

- Make the student script or notebook runnable from the **lesson folder** with documented local `data/` files where practical. A verified small dataset can be simpler than dependencies on undistributed parent folders.
- State required packages in advance. For shared setup use ordinary `library(pkg)` statements **one per line**; use `pkg::fun()` when only one function is needed. Keep per-exercise calculations in their own chunk, not all in a hidden opening mega-chunk.
- Do not add package auto-installation, library-path probes, `renv` bootstrap or `stopifnot()` checks merely to make a lesson "safe". Use ordinary errors and diagnose missing prerequisites when they occur; installation instructions may be a short **manual comment**, never an automatic step. An explicitly reproducible course environment or a lesson about environment management is an exception.
- An optional script that uses objects from the main script must state **run the main script first** and have a name describing its actual content.

## Keep teacher evidence separate

Long Monte Carlo runs, seed sweeps, validation logs, checksums, complex diagnostics, and answer keys may stay in teacher artifacts. **Do not delete substantive research computations** to shorten the student-facing script; separate the audience-facing path while preserving the evidence.

Projected "run this" snippets must refer to **objects and files present in the canonical student path**. Otherwise label the display as a **teacher demonstration**, not an executable student task.

## Verify the student handoff, not only the development folder

When execution is permitted, run the canonical student script or notebook in a **clean, lesson-shaped directory containing only delivered materials**, using documented packages. Check names, relative paths, representative results and consistency with slides/handouts. Run dependent optional extensions after the main activity.

Avoid adding defensive wrappers, file-location detection, or QA checks to the student's code merely because the agent needed them during verification. Preserve genuine warnings that affect interpretation.
