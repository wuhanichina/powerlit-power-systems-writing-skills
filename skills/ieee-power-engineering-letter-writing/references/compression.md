# Full-Paper to Letter Compression

Use this reference when a draft reads like a full paper but the target is an IEEE Letter.

## Keep

- The exact claim.
- The closest prior assumption or limitation.
- The minimum model needed to state the claim.
- The key derivation, counterexample, or algorithm.
- One decisive validation.
- A short conclusion.

## Cut

- Broad motivation paragraphs.
- Standalone related-work section.
- Long nomenclature.
- Secondary modules.
- Exhaustive ablations.
- Multiple benchmark families unless one is the point.
- Generic future work.
- References not directly tied to the assumption, method, or validation.

## Compression Procedure

1. Write the claim in one sentence.
2. Identify the single deliverable: formula, model, counterexample, algorithm, index, or result.
3. Delete any section that does not contain or validate the deliverable.
4. Merge notation into the technical core.
5. Reduce experiments to the smallest test that proves the claim.
6. Reduce references to the nearest method family and benchmark.

## Claim Test

A Letter claim passes if it can be expressed as:

- "Contrary to assumption X, Y occurs under condition Z."
- "Quantity X can be computed by expression Y instead of procedure Z."
- "Model X misses mechanism Y; adding term/constraint Z fixes the issue."
- "Algorithmic step X reduces computation Y while preserving Z."

If the claim needs several independent advances, split it or target a full paper.

## Evidence Test

The evidence should be minimal but decisive:

- analytical derivation plus one numerical illustration;
- counterexample plus implication;
- small benchmark plus one runtime/accuracy table;
- standard test system plus one focused comparison.

Do not try to make Letter evidence look comprehensive.
