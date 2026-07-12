# Innovation Narrative Assessment

Use this assessment after locking the minimum research object and before issuing
`GO`. Innovation is a four-axis profile, not one label.

## Four Axes

| Axis | Diagnostic question | Typical strong object |
| --- | --- | --- |
| Research object | Is the paper posing a previously unrecognized or incorrectly bounded power-system object? | new state, relation, risk object, decision object, or validation object |
| Discovery / mechanism | Does it reveal a phenomenon, threshold, failure mode, counterexample, causal chain, or boundary? | mechanism, law, conjecture test, boundary condition |
| Technical object | What is newly constructed? | model/formulation, control strategy, algorithm/solution, theory/guarantee, data/case protocol |
| Engineering decision loop | Which observable, decision, action, and consequence become better connected? | planning, operation, control, protection, market, risk, or diagnosis loop |

For each axis record:

- `present`: yes / partial / no;
- `noveltyMode`: `zero-to-one`, `one-to-hundred`, or `mixed`;
- `manuscriptUse`: `mainline`, `conditional`, `observed-phenomenon`,
  `boundary`, or `future-work`;
- closest novelty threat;
- required evidence and current evidence state;
- exact scope that may appear in the title, abstract, and conclusion.

## Novelty Magnitude

`zero-to-one` means the paper needs to establish existence, distinctness, or a
newly posed object before ranking performance. It requires counterexamples,
mechanism isolation, boundary characterization, and replication across systems
or scenarios where possible.

`one-to-hundred` means the object and task already exist and the contribution
improves their treatment. It requires the strongest fair baselines, matched
budgets and conditions, ablation, statistical or scenario stability, scale, and
failure conditions.

Use `mixed` only when the paper genuinely has both chains. Name one primary
axis and one primary magnitude. Do not present an incremental method gain as a
foundational breakthrough, and do not force a new object into a leaderboard.

## Route Lock

Before `GO`, return a compact route record:

```yaml
contractVersion: "2026.07.12"
minimumResearchObject: ""
primaryInnovationAxis: research-object
secondaryInnovationAxes: []
noveltyMode: zero-to-one
technicalObjectType: model-formulation
narrativeArc: discovery-first
lifecycleStage: zero-to-one-explore
manuscriptUse: mainline
evidenceBoundary: ""
closestNoveltyThreat: ""
requiredEvidenceRoles: []
```

If a project-template `paper-profile.yaml` exists, propose a write-back patch
after user confirmation. The skill explains and generates the values; it does
not silently maintain project state.

## GO Gate

`GO` requires:

1. one primary axis and magnitude are explicit;
2. the narrative arc matches the axis rather than an admired author's wording;
3. the case contract can falsify or narrow the main claim;
4. the current evidence supports the selected manuscript use;
5. author exemplars have been reduced to clean-room argument functions only.

If these conditions are incomplete, use `CONDITIONAL GO` or `NO-GO`.
