# Revision Response Workflow

Use this for reviewer comments, editor decisions, major/minor revision, response
letters, change lists, and manuscript repair.

## Diagnose Before Answering

For each comment, separate:

1. reviewer concern in neutral technical language;
2. real gap: mechanism, assumption, model, comparison, evidence, boundary, or
   wording;
3. affected claim, figure/table, equation, and manuscript location;
4. whether existing evidence resolves it or a new derivation/case is required;
5. the natural manuscript repair location;
6. the strongest response verb licensed by the repaired evidence.

Do not write the response first. Repair the manuscript and evidence chain first.
Do not insert defensive rebuttal paragraphs whose only purpose is to answer the
reviewer.

## Three Deliverables

### 1. Editor note / cover letter

- thank the editor briefly;
- state the revision's technical center;
- summarize the few changes that materially alter mechanism, model, evidence,
  or boundary;
- identify any request not adopted and the technical reason, without rhetoric.

### 2. Point-by-point response

For each `commentId`:

1. quote or faithfully summarize the comment;
2. state the diagnosed real gap;
3. answer directly;
4. describe the manuscript/evidence change;
5. give current page/section/line or figure location;
6. include only the minimum revised text needed to verify the change;
7. state remaining scope when the request cannot be fully satisfied.

### 3. List of changes

Group by manuscript location and record old function, new function, linked
comment, claim/figure/equation, and verification status. This is an audit list,
not a second response letter.

## Evidence Decisions

- Existing evidence sufficient: clarify mechanism, assumption, comparison, or
  boundary at its natural location.
- New analysis required: define claim, case contract, metric, expected decision,
  and failure condition before running it.
- Request outside scope: state the positive scope, show why the requested claim
  requires a different object/evidence surface, and narrow wording if needed.
- Reviewer premise contradicted by evidence: explain the evidence and improve
  the manuscript so the same misunderstanding is less likely.

## Project Handoff

When the project template is present, write status records to
`02_PAPER/revision/comment_log.yaml` and `response_matrix.md`. The skill owns gap
diagnosis and response prose; the template owns comment IDs, locations, linked
artifacts, repair status, and change history. If a comment changes a paper
claim or evidence boundary, require synchronized updates to `claims.md`,
`ProjectName_note.md`, and `ProjectName_changelog.md`.

Allowed statuses are `open`, `manuscript-patched`, `requires-new-case`,
`response-drafted`, `verified`, and `closed`. Close a comment only after the
manuscript location and referenced evidence have been verified.

## Final Gate

Run `submission-consistency-check.md` after all comment-driven changes. A
polished response cannot compensate for stale numbers, figure references,
profile drift, unsupported verbs, or an unpatched manuscript.
