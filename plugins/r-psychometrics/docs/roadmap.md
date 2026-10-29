# R Psychometrics Roadmap

## First slice: released as 0.1.0

- Item distributions, declared keying/scoring, raw and standardized alpha, item-rest diagnostics and bounded bootstrap illustration.
- Conventional CFA-based reliability for a continuous composite and an ordered-category composite, with explicit metric and denominator.
- Continuous common-factor exploration with psych and ordinal WLSMV EFA with lavaan, justified rotation, retention evidence and native diagnostics.
- Continuous ML/MLR CFA, ordinal WLSMV CFA and basic observed/latent SEM.
- Native summaries plus supported psymetrics fit/parameter extraction and descriptive comparisons.
- Same-sample nested comparison examples with estimator-appropriate corrections.
- Synthetic numerical checks, invalid-model/missing-data failure cases and bounded independent behavioral review, documented separately in the validation record.

This is a usable development slice. A public version/tag/catalog decision belongs to integration and release coordination.

## Second delivery, not implemented

| Capability | Required methodological content | Minimum new evidence |
| --- | --- | --- |
| Standard measurement invariance | Continuous versus ordinal identification; thresholds/intercepts, loadings and residual constraints; group scale/mean comparability; defensible partial invariance; native/semTools syntax and comparisons | Invariant and deliberately noninvariant group fixtures; valid corrected tests; exact constraint/threshold inspection; no automatic delta-fit cutoff decision |
| Basic unidimensional IRT | Appropriate dichotomous/polytomous mirt models; scale identification; global/item fit, local dependence, information and scoring uncertainty | Small simulated dichotomous and polytomous fits; coefficient/score metric verification; diagnostic feasibility and uncertainty checks |

No directories or placeholder skills for these capabilities are created in this delivery. The installed mirt version may be inventoried, but an inventory is not a validated IRT procedure. psymetrics psych/mirt support is not assumed.

## Deferred

ESEM with structural relations; DIF and anchor/purification decisions; psychometric networks; bifactor/S-1; higher-order and advanced reliability decompositions; linking/equating; multidimensional IRT, CAT and plausible values; mixtures/classes/profiles; multilevel/longitudinal SEM, latent interactions and advanced growth models; survey/MI/latent combinations.

These methods need bounded scientific questions, package evidence and independent validation before being advertised. Deferral does not prevent a user from requesting separate expert work.

## Integration follow-up

The coordinator can reconcile the root plugin map/README, assess cross-plugin task composition and decide any catalog/release changes. Worker commits modify only this plugin. Future tests should address demonstrated remaining risks rather than repeat unrelated historical release gates.
