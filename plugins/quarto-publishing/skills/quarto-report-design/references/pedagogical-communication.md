# Pedagogical Communication for Quarto Materials

Use this reference **when the reader's goal is to learn or teach**, especially for live lessons, training decks, worked examples, and accompanying learning materials. It complements [slide-deck-design.md](slide-deck-design.md); it does not prescribe Quarto syntax, CSS, statistical methods, or a fixed slide template.

## Begin with the learner's task

Identify what participants already know, what new distinction they must understand, what they should be able to **explain or decide**, and the likely misconception. Separate:

- **Projected teaching material:** supports the instructor's explanation and live demonstration.
- **Student handout or self-study material:** may need more context to stand alone.
- **Presenter notes:** hold detailed reasoning, transitions, caveats, answers, and timings.
- **Teacher-only evidence:** preserves complex calculations or simulations without burdening the learner's script.

Do not turn a projected slide into a self-contained manuscript merely because the source material is extensive.

## Build explanations, not collections of definitions

A useful progression is **intuition → concrete example → mechanism → formalization → interpretation**, but it is a menu, **not five mandatory slides**.

1. Begin with a meaningful problem or contrast, not a function name or abstract formula.
2. Reuse a familiar case before introducing another dataset or model. If a second case is needed, explain what the original cannot demonstrate.
3. Ask learners to predict a change or distinguish two competing interpretations **when doing so helps**; do not add a quiz to every concept.
4. Change one salient condition at a time for a controlled comparison; state what stays fixed and what changes.
5. Reveal the mechanism visually, then add notation, computations, or edge cases to the extent required by the learning goal.
6. End with a defensible interpretation and at least one relevant limitation, without narrating every possible caveat on the slide.

Use **worked examples** with declared units, values and assumptions; use **counterexamples** to expose a mistaken generalization. Label illustrative, hypothetical, simulated and observed results distinctly. Do not choose convenient observations after seeing the outcome and imply they were prespecified.

## Choose visuals by the relationship to explain

| Learner needs to see… | First consider… | Check that it shows… |
| --- | --- | --- |
| What relates to what | Structural diagram or annotated schematic | Nodes, links, direction, omitted elements and meaning of colors |
| How a process succeeds or fails | Flowchart, trajectory or decision tree | States, branches, next check and whether steps are actual or illustrative |
| What changes under a condition | Side-by-side panels with consistent axes and labels | Same subjects/units versus changed conditions |
| Magnitude, variability or pattern | Quantitative plot | Scale, units, denominators, uncertainty when meaningful |
| Exact numbers or formulas | Small table or progressive equation | Defined symbols, comparable metrics and a reason to show exact values |
| A software output or warning | Cropped, annotated output | Where to look and what the evidence does or does not prove |

A diagram **explains relationships**; a plot **shows quantitative behavior**; a table **supports exact lookup**; a card **groups brief alternatives**. Avoid replacing every explanation with three prose-filled cards. An empty area need not be filled merely to balance a slide.

When an apparent chart needs a paragraph to explain **what changed**, revise its labels, annotation or underlying comparison before adding another text box. When a figure and a second table repeat the same message, keep the representation that better serves the learning task.

## Titles, hierarchy, space and color

- Prefer **short, nominal, specific titles** such as "Model identification" or "Observed versus reproduced covariance". Use a question when prediction or discussion is the purpose. Avoid sentence-length preannounced conclusions.
- Give each slide or panel **one clear teaching purpose**. Split a mechanism from its formula when that helps comprehension; do not split only to meet a slide count.
- Use **meaningful whitespace** to separate conceptual groups and guide attention; do not crowd the canvas or place everything in the top half while leaving unrelated empty space.
- Size the **actual displayed** chart labels, code, equations, citations, and footnotes for their intended projection or reading width. Simplify or reflow before shrinking fonts.
- Use consistent color, notation, element positions and scales across comparisons. Color must **encode a role or contrast**, not merely decorate a series of boxes.
- Check text and syntax-highlighted code **against their real backgrounds**, including dark headers. Do not assume a theme's defaults provide enough contrast.
- State what a symbol, line, arrow, residual, percentage, reference category or threshold means when it is central to interpretation. Do not imply omitted diagram elements are known zeroes without explanation.

## Align teaching, practice and evidence

For applied or computational teaching, decide **what the student actually executes** before writing "run this" on a slide. Keep the projected code short, with model or decision parameters visible. Refer to a student script that exists and contains the named objects; teacher-only diagnostics can remain illustrations and should be marked accordingly.

Use an **anticipate → execute/inspect → interpret** loop when appropriate. The student should not have to write incidental filters, loops or joins to make sense of results if this is not the lesson's subject. Document the practice duration and pauses in instructor notes, rather than projecting the timetable by default.

Keep evidence labels consistent: sample and population, measured and latent quantities, numerator/denominator, observed and estimated values, conventional and corrected statistics. A statistically admissible model, a visually clear graph, and a valid interpretation are **separate checks**.

## Anti-patterns

- Do not start with a glossary, formula wall or package API when the learner first needs an intuition or comparison.
- Do not substitute dense cards or tables for an explanatory diagram or graph when the relationship is the lesson.
- Do not use charts with unlabeled axes, unclear denominators, misleading color reuse or an unspecified control condition.
- Do not present a simulated or schematic trajectory as if it were recorded algorithm output.
- Do not call a stage "validated", "complete" or "interpretable" without defining the checks and what remains untested.
- Do not duplicate instructor narration on the projected slide or add extra code to showcase every available function.
- Do not turn good practices into quotas: **no mandatory number of slides, cards, questions, words or diagrams**.

## Review at the fidelity of the deliverable

Verify with the real source data and code **before** putting values into teaching materials. Then inspect the actual rendered artifact at its delivery size: progression, contrast, legibility, layout, formulas, links, code and notes. State if the review was targeted rather than exhaustive.

For Quarto presentation mechanics, use `quarto-format-configuration`; for rendering and artifact inspection, use `quarto-render-troubleshooting`. For R teaching-script organization, consult the `classroom-r-scripts` reference when available. This document does not supersede an explicit course or instructor convention.
