# Teaching Explanations and Learning Activities

Use this reference when the task is **helping people understand a concept or practice a decision** in a lesson, training deck, or worked example. It complements [slide-deck-design.md](slide-deck-design.md), which owns slide structure, titles, density, typography, whitespace, and delivery. Do not read both by default.

## Define what the learner needs to understand

- Establish prior knowledge, the **new distinction** to learn, and the misconception most likely to interfere.
- Define the observable outcome: what should the learner be able to **explain, compare, predict, or decide** afterward?
- Distinguish **projected explanation**, **self-study handout**, **speaker notes**, and **teacher-only evidence**. They need different levels of detail.

## Make the mechanism intelligible

A useful sequence is **intuition → example → mechanism → formalization → interpretation**. Choose only the steps this concept needs; it is not a five-slide template.

- **Controlled contrast:** make **what remains fixed, what varies, and what follows** explicit across scenarios. If an additional scenario changes a different dimension, present it as a separate contrast rather than another step in the same gradient.
- **Worked example:** show the decision and evidence, not just the final value. Identify units, model, reference, and assumptions when they affect its meaning.
- **Counterexample:** challenge a tempting overgeneralization, then explain the condition under which the claim does or does not hold.
- **Formalization:** introduce equations and notation after the underlying relationship is understandable, unless formal reasoning itself is the learning goal.
- **Derivations:** when a transformation is the learning objective, show the starting quantity, the justified operation or assumption, the terms retained or removed, and the resulting meaning. Define consequential symbols at first use, including numerators and denominators.
- **Progressive reveal:** use successive states or motion only when seeing what persists and what changes helps learning. Plan readable states first; choose a static sequence or a supported animation *after* the presentation format is known. This guidance does not prescribe Reveal.js or Bento syntax.
- **Interpretation:** match claims to the evidence's origin, level of aggregation, and selection criteria; state what it supports **and what it cannot establish**. For example, distinguish known population parameters, estimates from one sample, and summaries across replications; if a summary includes only admissible solutions, disclose that restriction and its denominator.
- **Reference values:** distinguish descriptive conventions, simulation-dependent heuristics, and validated decision criteria. Explain their applicable conditions rather than turning contextual guidance into universal pass/fail rules.

### Choose the depiction that reveals the concept

| Learning difficulty | Useful depiction |
| --- | --- |
| Relationship or constraint is unclear | Annotated diagram showing the relevant links |
| Process, failure, or next diagnostic step is unclear | Branching flow or **explicitly hypothetical** trajectory |
| One condition changes an outcome | Side-by-side comparison with common scale and controlled inputs |
| Magnitude, uncertainty, or variation matters | Quantitative plot, with denominator and metric identified |
| Formula transformation or output is unclear | Staged, annotated expressions showing what changes and why, or cropped output highlighting the decisive field |

**Example:** to teach why convergence is insufficient, show **optimization → stopping criterion → further checks**. Do not replace that relationship with several prose-filled cards. A graphical example must be labeled **schematic**, **simulated**, or **observed**, as appropriate.

## Turn explanation into learning

Use **anticipate → execute/inspect → interpret** when a prediction and its resolution add value. Ask for a comparison or defensible explanation, not an activity on every slide. Prefer a familiar case over a new dataset unless the new case reveals something the first cannot.

When the task uses R or other software, decide what students actually run; teacher-only calculations may be precomputed illustrations. Do not require incidental programming or table manipulation merely to access evidence for the intended lesson.

Projected runnable code must match the **canonical material learners receive** (paths, objects, and outputs). When it changes, reconcile slides, notes, and handouts. For R script design and clean handoff checks, use `r-analytic-coding-principles` → `classroom-r-scripts.md`.

## Avoid

- A glossary or formula wall before the learner knows **what problem it solves**.
- Replacing a mechanism with dense text boxes or figures whose comparison requires a paragraph to decode.
- Presenting a selected, simulated, or imagined result as independent observed evidence.
- Treating "the algorithm finished", "the model fits", or "the value is above a threshold" as a complete interpretation.
- Enforcing a fixed number of stages, questions, diagrams, examples, or slides.

For titles, visual hierarchy, contrast, whitespace, accessibility, and rendered-slide review, use [slide-deck-design.md](slide-deck-design.md) and the relevant Quarto skills **only when those aspects are being edited**.
