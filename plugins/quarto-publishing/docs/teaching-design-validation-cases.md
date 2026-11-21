# Teaching-Design Behavioral Validation Cases

These are **test scenarios**, not proof that a new teaching deck will be good. Give a fresh evaluator the prompt and a small synthetic, source-backed fixture without the expected observations. Compare baseline and revised skill behavior when practical, then inspect the actual artifacts and the learning path. Use the pedagogical and slide-design references together for new teaching sequences; keep Quarto-specific output mechanics outside this test.

## Positive Cases

| ID | Fresh request / fixture | Required observations |
| --- | --- | --- |
| T01 | An instructor supplies excerpts from three earlier sessions, their code conventions, a syllabus and a new four-hour integrative lesson request. The old classroom example is already exhausted. | Read prior materials, distinguish prerequisite from new learning, choose a coherent new case when useful, protect time for interpretation/reporting, and coordinate slides with runnable learner material. No forced reuse of the old case. |
| T02 | A source article provides data, a model diagram and reported coefficients. A reconstruction matches global fit but differs slightly on item loadings. | Show the publication's results as **published** and the computed values as **reproduced**; state the discrepancy, the modeling scope and any separate teaching extension. Never retitle an adapted table as a literal screenshot or claim exact replication. |
| T03 | A slide draft has readable cards and no off-canvas elements, but one arrow points opposite to the model and a slope plot represents a positive coefficient with a flat line. | Reject the render as semantically incorrect; check directions, axes, units and signs against the source model/output. Choose corrected diagram/plot forms without imposing an illustration on every slide. |
| T04 | A course teaches scientific reporting and has a usable published table with a nonstandardized coefficient, reference category and confidence interval. | Show readable publication evidence and a clearly distinguished learner/reporting example, including applicable discipline format and citation. Teach meaning per original unit and the matched interval rather than substituting standardized coefficients. |
| T05 | A 210-minute course already has a full applied case, but two extra reparameterizations and a hypothesis restriction are proposed merely because they are available. | Keep the learning path and writing output achievable; include an extra contrast only with a distinct learning purpose and enough time, otherwise defer it as an optional extension. |
| T06 | A lesson introduces item loadings and fit criteria for an assessment used to evaluate trainees, but never explains what the results enable. | Connect findings to reviewing whether scores support their intended interpretation; state that acceptable fit alone cannot justify ranking or selection decisions. Do not invent person-level outcomes. |
| T07 | A short methodological conference talk and a longer applied research talk are requested from the same research, without a specific skill tag. | For the methodological talk, center methodological contribution, assumptions and decisive comparative evidence; for the applied talk, center the substantive question, estimates and implications. Select depth to fit speaking time; use nominal descriptive slide titles, not sentence headlines or fixed slides-per-minute quotas. |
| T08 | A live class explains how sample size affects precision; an agent proposes a dense single slide with tiny graphs and a small “Key message” rectangle on every step. | Arrange the explanation as a continuous multi-slide block with readable figures, axes and labels; retain a stable visual reference, use notes for spoken transitions and reserve a synthesis for a genuine ending when it adds value. Do not require a separate takeaway on each slide. |
| T09 | A rendered scientific slide contains two legitimate results near the top and most of the lower half is empty; the labels are also too small. | Enlarge the existing evidence first and rebalance vertical alignment and spacing. Do not invent extra findings, append a summary card, or force a minimum fill percentage. Merge adjacent slides only if the combined view remains easy to scan. |
| T10 | A course specifies dot decimals and no thousands grouping; the same deck has `0,835`, `0.835`, `7,138` and `7138` in charts and annotations. | Render consistently as `0.835` and `7138` across audience-facing surfaces without changing numeric values or rounding rules; check the rendered figures, not only prose. A different explicit locale convention should be respected. |

## Negative / Boundary Cases

| ID | Request / fixture | Required observations |
| --- | --- | --- |
| B01 | A 15-minute conceptual explanation with no empirical data or companion script. | Do not impose the full case-to-report path, a mandatory teaching-brief display, or a diagram quota. |
| B02 | A published figure is unreadable at projection size or reuse rights are uncertain. | Do not paste a tiny screenshot as a mandatory visual; use a cited, clearly labeled permissible extract or a faithful redraw when authorized, or explain the limitation. |
| B03 | The request is a formatting-only edit to an existing Quarto slide, with no change to learning content. | Do not force a new pedagogy redesign or modify unrelated code; route format/render mechanics to the specialized references. |
| B04 | A short mathematical demonstration has no direct applied decision or person-level evaluation. | Explain the conceptual implication without inventing a high-stakes application or a mandatory practical call to action. |
| B05 | A projected slide contains a definition, equations, technical assumptions and three explanatory paragraphs in 8–10 pt because the author wants everything visible at once. | Keep the key definition or mathematical object large and readable, split remaining steps across slides, move oral explanation to notes and retain only essential inspectable evidence on screen. Do not solve crowding by shrinking the font. |

## Review Protocol

1. Isolate the prompt and fixture from the answer key and from earlier revisions.
2. Record which skill instructions were actually read, the communication brief and the produced materials.
3. Inspect the **learning progression**, provenance labels, semantic diagram correctness, original units, and learner-vs-instructor material boundary; a syntax or render pass alone is insufficient.
4. Classify each case **pass / partial / fail / not observable**; preserve screenshots/diffs only in local QA, not inside the plugin skill.
5. For coupled R materials, run the canonical learner code from a lesson-shaped directory when authorized, and reconcile the objects and results shown in slides.
