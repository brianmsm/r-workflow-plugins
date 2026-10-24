# Classroom R Scripts: Research-Code Principles in a Teaching Setting

Read this reference when the **primary deliverable is R code students will execute during a class**. It specializes [r-analytic-coding-principles](../SKILL.md): the core skill prioritizes researcher editability; here the additional priority is **learner comprehension at the point of execution**. This is not a mandate to simplify research pipelines or production code.

## Decide what belongs in the student's path

Before editing, determine:

- What should learners **estimate, compare and interpret**, versus what the instructor has already simulated or checked?
- Which R concepts are prerequisites and which are themselves the learning objective?
- What can be prepared as data, teacher notes, backup script or a verified figure rather than computed live?
- What are the student's actual files, working directory, packages, R experience and available time?

A script should match the lesson, **not demonstrate every capability of the package**.

## Keep the primary script local and sequential

A typical classroom analytical unit is:

1. Load a named dataset from a clear relative path.
2. Write the model, formula or analytical choice visibly.
3. Fit or compute it explicitly.
4. Show its immediately relevant results with a familiar function.
5. Pause to interpret before starting the next unit.

Use short named sections (RStudio/Positron sections such as `# Estimación ML ----`), readable objects and minimal comments. Explain **why this step** in one or two short comments, not in a page of prose inside the R file.

Keep the canonical student script runnable from **its own lesson folder** with local `data/` files when practical. A small verified copy of a previous lesson's dataset can be preferable to a fragile `../other-lesson/...` dependency; preserve and document the source. This is a portability preference, not an instruction to duplicate all large datasets.

## Repeat analytical decisions deliberately

Repeat visible native calls when they help comparison:

```r
fit_ml <- lavaan::cfa(modelo, data = datos, estimator = "ML")
fit_mlr <- lavaan::cfa(modelo, data = datos, estimator = "MLR")

summary(fit_ml, standardized = TRUE)
summary(fit_mlr, standardized = TRUE)
```

This makes the estimator change inspectable. Do **not** automatically wrap independent cases in `lapply()`, generate formulas dynamically or hide key choices behind a helper simply to remove a handful of repeated lines.

Use a loop/helper when students are learning that abstraction, or when repetition genuinely prevents understanding or introduces errors. Do not impose a minimum or maximum line count: **brevity means few incidental concepts**, not compressed syntax or code golf.

## Show results without teaching incidental data manipulation

- Prefer `summary()` or an existing high-level model comparison/estimate function when it already shows what the lesson requires. Do not calculate the same table twice just because a different API exists.
- Use `psymetrics`, tidyverse, base R or another justified interface when it simplifies **that** class; do not make one package mandatory for every course.
- Avoid `subset()`, `merge()`, manually aligned outputs, post-hoc joins, conditional formatting and large extraction pipelines when the course objective is to **interpret a model**, not manipulate tables.
- Display enough information to defend the interpretation, including the **metric**, uncertainty, denominator and model identity when consequential.
- Keep model formulas and visible `cfa()`/`lm()`/other native estimation calls at the student's point of use. Hiding these decisions behind wrappers defeats the teaching objective.

## Separate teacher evidence from student work

A course may need long Monte Carlo simulations, numerical diagnostics, seeds, checksums, plotting generators, advanced estimation cases or answer keys. Keep them in **teacher/auxiliary scripts** or prepared artifacts, not the primary lesson file merely because they were necessary to build the slides.

A teacher-only slide may show a verified computation even if the student cannot execute it; label it as a demonstration. Do not tell learners to run objects or helpers that do not exist in their script or distributed files.

When a small optional extension reuses objects from the main script, state that it must run **after** the main script. Name the extension by **its actual content**, not by an adjacent topic.

## Classroom package and execution rules

- Prefer one documented working directory, local data and explicit package requirements; do not install packages or fetch data during a timed lesson unless installation is the exercise.
- Avoid defensive `tryCatch()`, `file.exists()` branches, elaborate configuration, environmental probing or hashes in the student script when the instructor can verify the inputs beforehand.
- Expose genuine statistical warnings that affect interpretation; do not suppress problems merely to keep output clean.
- Keep substantive analytical assumptions explicit (e.g., estimator, ordinal declaration, orthogonality), but spare students a second full lesson on software internals unless requested.
- Match every object and function shown on slides, in handouts and in the student script. **A correct render with nonexistent code objects is not a valid classroom handoff.**

## Minimal handoff verification

Before distribution, copy **only the student-facing script and required data** to a clean temporary lesson-shaped directory and run from that directory with the documented packages already installed. This catches hidden dependencies on parent folders, unpublished outputs and teacher-only helpers.

Run the optional extension separately **after** the main script if that dependency is intended. Compare key student outputs with prepared evidence and report the extent of verification (execution, numerical consistency, not automatic scientific validity).

## Anti-patterns

- Do not refactor repeated `cfa()` calls into a generic fitting factory when the visible difference between models is the point.
- Do not force learners to build manual tables or extract every available diagnostic.
- Do not mix a simulation engine, instructor QA and student exercises into one oversized file.
- Do not distribute only a script while its required CSV lives in another undistributed session folder.
- Do not impose an "advanced" software architecture on an introductory or intermediate classroom workflow simply because it looks reusable.

If the user explicitly wants a package/tutorial, course on loops, data-wrangling lesson or engineering workflow, **those topics themselves become learning targets** and the appropriate abstractions belong in the student script.
