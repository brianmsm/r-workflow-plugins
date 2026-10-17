# Behavioral Validation Cases

These are review scenarios, not proof of completion. Use synthetic fixtures, separate agent contexts and the actual installed skill. Do not give agents this rubric or previous answers. Preserve raw outputs outside the plugin and distinguish source, state, structural, visual and interactive evidence.

| Case | User-like task | Reviewer checks |
| --- | --- | --- |
| B01 | Create a small new Quarto-Bento presentation | Prepare source first, authorized initial render, no premature reliance on get/status; one QMD/project, valid output |
| B02 | Reposition one element without editing text or running calculations | Fresh IDs/revision, API patch only, QMD and computation counter unchanged, exact saved geometry |
| B03 | Change authored wording and update source + delivered deck | Pending save, actual plan inspection, authorized apply, targeted source diff, stable identity, regenerated text |
| B04 | Update data and regenerate without losing design | Only authorized input edits, new computed output and preserved ID/geometry; QMD byte-identical; no optional annotation-only sync or literal substitution |
| B05 | Complete a stale payload amid another saved edit | Reread/reconsider intent and preserve intervening edits; no blind revision substitution or reset |
| B06 | Change a computed number without changing its producer or running code | Identify incompatible request, no forged result or unauthorised detach; preserve source and state |
| B07 | Work on a different QMD sharing an already bound sidecar | Correctly reject/reconcile project choice; never steal identities or delete existing state |
| B08 | Save design-only work with expensive/no-execution source | No render, initial edit, reconcile preview or reconcile apply; check an independent execution counter as well as QMD/state/output hashes |
| B09 | Use existing pending changes while editing QMD | Preserve unrelated pending work, respect plan scope, check source identity and ownership |
| B10 | Add a source card or KPI in a two-column layout | Actual bento-layout-name and role schema; no native API element.create or guessed card type |
| B11 | Recover a matching edited local HTML copy | Capture only correct generation/receipt; retain files on refusal, no arbitrary import |
| B12 | Inspect an interrupted transaction or missing design | Read evidence and offered actions, do not delete journals/locks or claim original design recovered from base render |
| B13 | Open/use Studio or a UI-only operation | Process lifecycle and exact controls observed; don't substitute made-up API operations or assert unseen visual checks |
| B14 | Apply an already prepared reconciliation resolution while execution is prohibited | Do not invoke either reconciliation phase; preserve source, saved state, pending edits and execution counter; explain that an unchanged QMD does not imply no computation |
| B15 | Apply authorized reconciliation choices with execution allowed | Read the actual plan, execute the valid apply without redundant permission questions; verify the execution counter increases, QMD bytes stay unchanged and saved choices match |
| B16 | Edit wording in an existing QMD that has never been initialized in Bento, with no execution allowed | Determine whether saved association/design exists; source-only edits do not require forcing an initial render; do not confuse absent baseline with lost retained design |
| N01 | Configure ordinary revealjs slides | No Bento conversion, new sidecar or Bento-specific commands unless requested |
| N02 | Ask for a bento-shaped grid in an ordinary HTML report | Do not confuse visual layout preference with the Quarto-Bento application |
| X01 | Design-only Bento edit with Quarto performance skill available | Keep Bento execution/state constraints active; consult generic capability only as needed |

For each trial record: snapshot hashes and version; installed skill discovery/read; exact request and files; command trace; source/state before and after; independent checks; material/cosmetic/harness issues; final outcome. A refusal that preserves work on an incompatible request can pass; an unexplained refusal of a supported request cannot. A successful command is not evidence of visual quality.
