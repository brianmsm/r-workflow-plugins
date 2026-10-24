# Teaching Explanations and Learning Activities

Use this reference when the task is **helping people understand a concept or practice a decision** in a lesson, training deck, or worked example. It complements [slide-deck-design.md](slide-deck-design.md), which owns slide structure, titles, density, typography, whitespace, and delivery. Do not read both by default.

## Define what the learner needs to understand

- Establish prior knowledge, the **new distinction** to learn, and the misconception most likely to interfere.
- Define the observable outcome: what should the learner be able to **explain, compare, predict, or decide** afterward?
- Distinguish **projected explanation**, **self-study handout**, **speaker notes**, and **teacher-only evidence**. They need different levels of detail.

## Make the mechanism intelligible

A useful sequence is **intuition → example → mechanism → formalization → interpretation**. Choose only the steps this concept needs; it is not a five-slide template.

- **Controlled contrast:** hold relevant conditions fixed, change one salient thing, and make **what remained fixed, what changed, and what followed** explicit.
- **Worked example:** show the decision and evidence, not just the final value. Identify units, model, reference, and assumptions when they affect its meaning.
- **Counterexample:** challenge a tempting overgeneralization, then explain the condition under which the claim does or does not hold.
- **Formalization:** introduce equations and notation after the underlying relationship is understandable, unless formal reasoning itself is the learning goal.
- **Interpretation:** ask what the evidence supports **and what it cannot establish**; do not list every caveat on the projected material.

### Choose the depiction that reveals the concept

| Learning difficulty | Useful depiction |
| --- | --- |
| Relationship or constraint is unclear | Annotated diagram showing the relevant links |
| Process, failure, or next diagnostic step is unclear | Branching flow or **explicitly hypothetical** trajectory |
| One condition changes an outcome | Side-by-side comparison with common scale and controlled inputs |
| Magnitude, uncertainty, or variation matters | Quantitative plot, with denominator and metric identified |
| Formula or output is necessary | Short, annotated equation/output emphasizing the decisive element |

**Example:** to teach why convergence is insufficient, show **optimization → stopping criterion → further checks**. Do not replace that relationship with several prose-filled cards. A graphical example must be labeled **schematic**, **simulated**, or **observed**, as appropriate.

## Turn explanation into learning

Use **anticipate → execute/inspect → interpret** when a prediction and its resolution add value. Ask for a comparison or defensible explanation, not an activity on every slide. Prefer a familiar case over a new dataset unless the new case reveals something the first cannot.

When the task uses R or other software, decide what students actually run; teacher-only calculations may be precomputed illustrations. Do not require incidental programming or table manipulation merely to access evidence for the intended lesson.

## Avoid

- A glossary or formula wall before the learner knows **what problem it solves**.
- Replacing a mechanism with dense text boxes or figures whose comparison requires a paragraph to decode.
- Presenting a selected, simulated, or imagined result as independent observed evidence.
- Treating "the algorithm finished", "the model fits", or "the value is above a threshold" as a complete interpretation.
- Enforcing a fixed number of stages, questions, diagrams, examples, or slides.

For titles, visual hierarchy, contrast, whitespace, accessibility, and rendered-slide review, use [slide-deck-design.md](slide-deck-design.md) and the relevant Quarto skills **only when those aspects are being edited**.
