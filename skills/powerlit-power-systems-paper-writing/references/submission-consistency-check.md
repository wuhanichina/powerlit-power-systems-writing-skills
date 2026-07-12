# Submission Consistency Check

Use this before calling a manuscript submission-ready and after any revision
that changes a claim, number, figure, term, or evidence boundary.

## Inputs

Prefer the versioned project handoff surface when present:

- `paper-profile.yaml`, story, claims, derivation, symbols, and evidence map;
- current manuscript;
- current run manifests, figure manifests, plot-data files, and check reports;
- revision matrix and comment log;
- target-venue profile and current writing-skill version.

Without a template, build an equivalent temporary Markdown inventory.

## Deterministic Pass

Check and report exact locations for:

1. spine drift across title, abstract, introduction, results, and conclusion;
2. number drift, including units, signs, percentages, denominators, precision,
   and whether values come from one coherent run;
3. figure/table numbering, first mention, caption, panel labels, and missing or
   stale file references;
4. abbreviation definition and alias drift;
5. canonical-term drift between manuscript, equations, symbols, and profile;
6. unresolved placeholders (`TODO`, `TBD`, `【待补充】`, citation markers, empty
   captions, temporary names);
7. claim-to-evidence closure through `claimId` and `evidenceId`;
8. figure-explanation closure: actual plot data, trend, key point, quantitative
   difference, mechanism, problem, advantage, implication, and boundary;
9. evidence-verb calibration against `prose-quality-gates.md`;
10. profile drift in innovation axis, novelty magnitude, narrative arc,
    lifecycle stage, target venue, and evidence boundary.

## Verdict

- `PASS`: no unresolved contradiction or submission blocker.
- `CONDITIONAL PASS`: only explicitly listed low-risk editorial items remain.
- `BLOCK`: any unsupported strong claim, conflicting key number, missing main
  figure evidence, unresolved placeholder, profile drift, or evidence-verb
  mismatch remains.

Return a compact issue list with `issueId`, severity, manuscript location,
profile/claim/figure link, observed value, expected value, repair action, and
status. If the project template exists, write the report state to
`02_PAPER/submission_consistency.md`; the judgment logic remains in this skill.

Never fix a contradiction by choosing the more favorable number. Resolve the
source run or narrow the claim.
