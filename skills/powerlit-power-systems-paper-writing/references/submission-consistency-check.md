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
10. equation, section, figure, and table numbering; first mention; and every
    cross-reference, including rejection of formula references that point
    forward to equations not yet introduced;
11. citation numbering after paragraph movement when the venue orders
    references by first appearance;
12. terminology-replacement closure across prose, symbols, subscripts,
    captions, legends, Chinese titles, **English titles, English abstract,
    and English figure/table captions**, plus zero unintended residue of
    obsolete aliases in any of these locations. A term replaced in Chinese
    but left in the English abstract, or replaced in body prose but left in
    a figure caption, fails this check; scan each language surface
    independently with the obsolete-alias keyword list and confirm zero
    residue before declaring the replacement closed;
13. malformed formula text, control characters, broken LaTeX commands, and
    suspicious fragments such as `rac{` after conversion or replacement;
14. promise-to-landing closure from abstract and contribution through body
    development, equation/model location, evidence, and conclusion;
15. profile drift in innovation axis, novelty magnitude, narrative arc,
    lifecycle stage, target venue, and evidence boundary;
16. case-study anonymization closure: when the manuscript is destined for
    blind review, real city names, named utilities, and case-data years
    have been replaced in prose, Chinese captions, English captions, and
    English abstract; author affiliations and reference years remain;
    local figure-path fragments inside Markdown are not part of this check
    (they do not survive final typesetting).

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
