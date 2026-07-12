# Innovation Narrative Router

Use this after prewriting review and before the pre-drafting confirmation is
locked. Inputs are the four-axis innovation profile, novelty magnitude, minimum
research object, target venue, evidence maturity, and manuscript-use class.

Once the primary route is selected, load `innovation-exemplar-doi-map.md` and
retrieve the corresponding DOI seeds from PowerLit. Extract clean-room argument
functions and evidence order before drafting; do not cite a seed unless it is
technically relevant to the current paper.

## Routing Rule

Select one primary route. Secondary axes may supply one supporting section or
case function; they must not create parallel paper spines.

| Primary route | Introduction burden | Method order | Case-study center | Conclusion center |
| --- | --- | --- | --- | --- |
| New research object | prove the object has been missed or misbounded | define object, scope, properties, then computation | existence, counterexample, geometry/boundary, cross-system replication | what object is now identifiable and under which boundary |
| New variable / scenario | show why the variable or condition changes the engineering problem | define variable/scenario, coupling, and model insertion | trend, threshold, counterfactual, decision consequence | what changes when the variable/scenario is represented |
| New method | establish an unresolved technical limitation in an existing task | formulation, mechanism/property, algorithm | trusted physical reproduction, strongest fair baseline, ablation, scale | which task is better handled and under what budget/condition |
| New discovery | state the phenomenon or failed intuition before proposing machinery | observation, mechanism hypothesis, discriminating model | phenomenon replication, competing explanations, mechanism isolation | discovered relation and its bounded implication |
| New mechanism | expose the missing causal/coupling chain | variables, coupling, derivation, technical embodiment | intermediate quantities, intervention/counterfactual, sensitivity, boundary | mechanism clarified and decision value |
| New framework | prove that missing coordination, interface, or decision closure is the gap | components only after interfaces and information flow | component ablation, end-to-end closure, interface failure cases | closed loop achieved without hiding component limits |

## Magnitude Overlay

### Zero-to-one

- Introduction: argue existence and distinctness, not a performance deficit.
- Method: define the object or mechanism before optimization details.
- Results: include an existence case, counterexample, mechanism-isolation case,
  boundary map, and replication across at least one changed system or scenario.
- Conclusion: state what became representable, observable, explainable, or
  decidable; do not claim broad superiority from an initial benchmark.

### One-to-hundred

- Introduction: identify the exact limitation in an established task.
- Method: show the changed technical object and why it improves that limitation.
- Results: strongest baseline, matched information and compute budget, ablation,
  repeated/scenario stability, scale, and failure condition.
- Conclusion: quantify the bounded improvement and tradeoff; do not rebrand it
  as discovery of a new field object.

## Argument-Function Prototypes

Corpus and author analyses may yield reusable functions such as:

- engineering mechanism chain: condition → intermediate physical quantity →
  threshold/trend → cost, risk, or decision implication;
- model-decision dual validation: model fidelity first, decision consequence
  second;
- object-definition route: definition → property → boundary → computation;
- geometry/boundary route: feasible region, threshold, or counterexample before
  average performance;
- mechanism-intervention route: observed trend → isolated intermediate variable
  → counterfactual or ablation → causal interpretation;
- framework-closure route: information flow → component interface → end-to-end
  consequence → interface failure.

These are clean-room structural abstractions. Never expose an author's name as
a fixed template, preserve a distinctive sentence, or imitate source phrasing.

## Venue Overlay

Apply the venue profile after selecting the route. Venue affects rhythm,
contribution placement, and evidence granularity; it does not change the
innovation profile. If the venue requires evidence that the route cannot
provide, narrow the claim or retarget.

## Required Output

Produce an internal routing record containing:

```yaml
contractVersion: "2026.07.12"
primaryInnovationAxis: ""
secondaryInnovationAxes: []
noveltyMode: ""
technicalObjectType: ""
narrativeArc: ""
introductionRoute: []
methodRoute: []
caseContract: ""
requiredEvidenceRoles: []
conclusionRoute: []
evidenceBoundary: ""
```

When a template profile exists, write the confirmed values back through the
handoff contract. Without a template, keep the record in the conversation or a
user-approved Markdown artifact.
