# Model, Math, and Method Review

Use this reference for methods, mathematical models, symbols, formulas, algorithms, and physical correctness.

## Model Correctness

Check whether the model can express the stated engineering need:

- physical variables match the system object;
- assumptions are stated before they are used;
- constraints correspond to real operating limits;
- objective function matches the claimed optimization target;
- uncertainty, disturbance, or data model matches the case setting;
- time scale and information timing are consistent;
- units and per-unit conventions are clear.

Fatal issues:

- the model omits the constraint that defines the claimed problem;
- the formulation violates physical laws or standard operating conventions;
- variables are used before definition or with inconsistent meanings;
- the proof or algorithm assumes convexity, independence, radiality, stationarity, observability, or perfect information without saying so;
- the method's approximation changes the problem but the paper reports results as if it solved the original problem.

## Equation and Symbol Check

For each formula block, verify:

- every symbol is defined near first use;
- indices and sets are consistent;
- dimensions and units are compatible;
- signs follow the stated convention;
- constraints have clear domains and bounds;
- equation numbering is continuous and referenced correctly;
- no unused variables or decorative formulas remain.

For Chinese manuscripts, variable explanation after formulas should be concise and aligned with journal formatting. "式中：" explanations normally should not become long prose paragraphs.

For IEEE manuscripts, notation should be either in `NOMENCLATURE` or defined near first use. Do not scatter key assumptions across footnotes, captions, and case-study settings.

## Complexity and Simplification

Ask whether the model is more complex than the contribution requires:

- Can redundant variables be eliminated?
- Can constraints be grouped or moved to appendix?
- Is a nonlinear formulation necessary, or is an exact/controlled reformulation available?
- Is a multi-stage or multi-layer structure justified by physics or operation, not only by presentation?

Complexity is acceptable when it resolves a real coupling or security requirement. Complexity is a weakness when it hides a simple incremental idea.

## Algorithm Review

Check:

- algorithm steps correspond to specific model difficulties;
- initialization, stopping criteria, convergence, feasibility recovery, or fallback are stated when needed;
- distributed, online, real-time, scalable, or robust claims are tested accordingly;
- solver choice does not become the hidden contribution;
- computational results include hardware/runtime only when runtime is claimed.
