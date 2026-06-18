# Novelty and Citation Evidence

## Closest-Competitor Test

A paper is a closest competitor when it overlaps in at least two of these dimensions:

- same power-system object,
- same operational/planning/control problem,
- same mathematical mechanism,
- same uncertainty or data structure,
- same benchmark or evidence object,
- same target venue and claim type.

Search score is only a candidate-ranking signal. It is not a novelty verdict.

Use exactly these novelty threat states:

`HIGH_THREAT`:

- same object,
- same mechanism,
- same claim,
- comparable or stronger evidence.

`MEDIUM_THREAT`:

- same problem and evidence object,
- different mechanism;
- or same mechanism used for a nearby problem.

`LOW_THREAT`:

- shared background only;
- different technical object or different verification target.

`UNKNOWN`:

- retrieval result is too sparse,
- PowerLit is unavailable,
- manuscript idea is too vague to compare.
- target venue coverage is unavailable or incomplete,
- candidate records expose only title/abstract without method or result evidence,
- query recall falls below the configured benchmark floor,
- cache freshness or target-year coverage is incomplete.

For every candidate, compare:

- problem-object overlap,
- engineering-scenario overlap,
- mathematical-model overlap,
- core-mechanism overlap,
- data or uncertainty-object overlap,
- case-study and evidence-object overlap,
- claim overlap.

## Citation Roles

Do not insert citations as decoration. Assign each citation one role:

- background: proves the engineering problem exists;
- method family: represents an established route;
- limitation: shows why that route is insufficient;
- closest competitor: must be contrasted directly;
- evidence precedent: supports benchmark, metric, scenario, or data choice.

For introduction writing, every literature paragraph should close one logic step:

`context -> method family -> unresolved technical reason -> why the manuscript object is needed`.
