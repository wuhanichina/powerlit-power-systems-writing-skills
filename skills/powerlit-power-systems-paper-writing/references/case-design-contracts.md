# Case-Design Contracts by Innovation Type

Use this reference after the narrative route is selected and before formal
figures or result prose. A case contract states what evidence could confirm,
differentiate, weaken, or falsify the main claim.

After selecting one of the six contracts, load
`innovation-exemplar-doi-map.md`. Use its DOI entries as direct PowerLit
retrieval seeds for paper structure and evidence-order learning, then replace
or supplement them with papers closer to the current minimum research object.
The DOI map is not an automatic citation list.

## Shared Minimum

Every contract names the claim, system/scenario, trusted reference, fair
baseline where applicable, metric with unit and direction, required evidence
roles, lifecycle stage, boundary test, and result that would narrow the claim.
No SOTA advantage may be written before physical reproduction is established.

Map the required evidence roles onto the case-section figure storyboard acts in
`figures-tables-results.md` before plotting: engineering scene, physical
contradiction, mechanism, technical object at work, and boundary. Each contract
makes one act load-bearing — the counterexample act for a new research object,
the intermediate-quantity act for a new mechanism, the matched-comparison act
for a new method — and that act must be visible in a figure rather than only in
prose.

## Six Contracts

### New research object

- Required: operational definition, existence case, nearest old-object
  counterexample, property or geometry visualization, boundary, and changed
  system/scenario replication.
- Decisive question: does the object remain distinct when representation,
  system size, or operating condition changes?
- Avoid: leading with average accuracy or runtime rankings.

### New variable or scenario

- Required: controlled baseline without the variable/scenario, trend across its
  range, key threshold or reversal, mechanism-linked intermediate quantity,
  decision consequence, and boundary test.
- Decisive question: does the variable/scenario change a conclusion that the
  previous model would make?
- Avoid: adding a variable without isolating its effect.

### New method

- Required: trusted physical reproduction, strongest matched baselines, equal
  information/compute budget, component ablation, repeated or scenario
  stability, scale/runtime when claimed, and failure condition.
- Decisive question: which technical limitation is improved, and what tradeoff
  pays for the improvement?
- Avoid: weak baselines or a custom metric that favors the method.

### New discovery

- Required: replicated observation, competing explanation, discriminating test,
  mechanism hypothesis, intervention/counterfactual where feasible, and scope.
- Decisive question: can the phenomenon survive a changed dataset, system, or
  plausible alternative explanation?
- Avoid: converting correlation into mechanism.

### New mechanism

- Required: observable outcome, intermediate physical/model quantity, derivation
  or causal chain, parameter intervention, ablation/counterfactual, and
  threshold/boundary.
- Decisive question: does changing the proposed mechanism variable change the
  outcome in the predicted direction?
- Avoid: reporting only endpoint performance.

### New framework

- Required: interface and information-flow diagram, end-to-end task, component
  baselines, component ablation, coordination/closure benefit, overhead, and
  interface failure cases.
- Decisive question: does the framework close a decision loop that separate
  components cannot close under matched information?
- Avoid: "A+B+C" packaging without a new interface or coordination mechanism.

## Magnitude Requirements

| Requirement | zero-to-one | one-to-hundred |
| --- | --- | --- |
| Primary proof | existence/distinctness | fair improvement |
| Negative evidence | counterexample to old object | failure case/tradeoff |
| Mechanism | isolation is central | ablation explains gain |
| Breadth | cross-system/scenario replication | statistical/scenario stability |
| Comparison | old representation or closest concept | strongest current baselines |
| Boundary | definition and applicability boundary | condition where gain disappears |

## Lifecycle Policy

- `zero-to-one-explore`: diagnostic plots and provisional observations allowed;
  no superiority claim.
- `zero-to-one-first-run`: existence, counterexample, mechanism isolation, and
  first boundary evidence required before a mainline claim.
- `one-to-hundred-evidence`: physical reproduction and fair baseline required;
  ablation and stability may still be pending.
- `one-to-hundred-submission`: physical reproduction, strongest baseline,
  sensitivity/ablation, scale where claimed, and failure boundary required.

Return the selected contract name, required evidence roles, missing evidence,
and the claim-narrowing trigger. Project templates persist these values; this
skill owns their rationale.
