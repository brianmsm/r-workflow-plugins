# Path diagrams for CFA and basic SEM

Choose the purpose before deciding what to draw. A conceptual figure names hypothesized relationships. A specification figure maps the modeled terms and constraints. A results figure adds estimates on a named metric and, where relevant, uncertainty on the same metric. State any display omissions that affect how the figure can be read.

## Map the model to the drawing

Use rectangles for observed variables and ellipses for latent factors, or supply a legend for another convention. For reflective CFA, draw arrows from factors to their indicators. Draw regressions from predictor to response and double-headed curves for modeled covariances. Distinguish a covariance between factors from a covariance between indicator residuals. For a measurement or full SEM diagram, group indicators by factor and keep structural paths distinguishable from loadings. Mark fixed values, free labels and equality constraints when readers need to reconstruct the specification. In a fitted diagram, consult the parameter table for constraints and model defaults as well as the written syntax.

For example, with reflective factors measured by separate sets of items, a term such as `item2 ~~ item3` between two endogenous indicators denotes a residual covariance. Connect their residuals, or use a curved connector between indicators with an explicit residual-covariance label. Give a numerical residual correlation only when it has been computed on that metric. With syntax alone, use symbolic labels and describe any omitted scale constraints or variance terms needed to interpret the figure.

## Arrange mediation paths for recognition

Use layouts that make each hypothesized route traceable. Keep the exposure and outcome in stable positions when comparing models.

| Specification | Useful starting layout |
| --- | --- |
| One mediator | Put exposure and outcome on a baseline and the mediator above. Draw the direct path on the baseline if specified. |
| Parallel mediators | For two mediators, put one above and one below the direct axis. For more, separate the branches so each route can be followed. Include any modeled residual covariance with distinct endpoints or explain its omission. |
| Serial mediators | Place mediators in hypothesized order. For a two-mediator chain with additional parallel routes, place both above the exposure–outcome baseline and leave room for the cross-path labels. Draw shortcuts only when specified. |

For example, given the following linear structural equations:

```text
M1 ~ a1*X
M2 ~ a2*X + d*M1
Y  ~ cp*X + b1*M1 + b2*M2
```

Trace six regression arrows. Along them, the specific indirects are X → M1 → Y (a1 × b1), X → M2 → Y (a2 × b2), and X → M1 → M2 → Y (a1 × d × b2). Put derived quantities in a caption or adjacent key. Drawing another arrow for a product would imply another regression. Removing the M1 → M2 path removes the serial route; an estimated residual covariance would not restore it. See [basic-sem.md](basic-sem.md) for estimation, metric and causal interpretation limits.

## Show what kind of moderation is meant

A conceptual label or pointer from W to the X → Y path can communicate that the relationship depends on W. To depict an ordinary observed interaction model such as Y ~ X * W, show the terms X, W and X × W predicting Y, and identify the product as constructed from its inputs. To communicate results, use conditional predictions or contrasts at meaningful moderator values with units and uncertainty; the observed-regression workflow covers that analysis. If a figure displays conditional indirects or differences, label the moderator values, target scale and matching intervals. See [inference for derived effects](indirect-effects-inference.md) for this calculation in a linear observed-interaction model.

## Verify the finished figure

Read each displayed path back as a statement about two named endpoints, its direction or covariance, and its parameter. Then work forward from the target specification and account for each relevant term, including any declared simplifications. Check rendered arrowheads, crossings and label placement at the intended size. In teaching figures, try the learner's task using the displayed information alone. A request to identify all indirect routes, for example, requires every constituent path to be visible.
