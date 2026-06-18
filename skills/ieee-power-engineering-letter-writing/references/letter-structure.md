# Letter Structure Reference

## Official Page Constraint

The current IEEE PES rule, checked on 2026-06-18, is:

- original submission: no more than 3 formatted pages;
- revision: no more than 3.5 formatted pages;
- final edited Letter should remain within 4 pages.

Use the initial 3-page limit as the default drafting budget. See the review skill's `references/rule-sources.yaml` for the official sources and audit date.

## Corpus Description

A historical PowerLit sample contained 69 TPWRS/TSG Letter-style papers. Its observed medians, including approximately 4 published pages, 5 abstract sentences, 7 introduction paragraphs, 15 tagged equations, and 9 references, are descriptive statistics only. They do not override the submission rule and are not universal style requirements.

## Standard Movements

### Analytical or Formulation Letter

1. `I. INTRODUCTION`
2. `II. MODEL / PROBLEM FORMULATION`
3. `III. DERIVATION / PROPOSED METHOD`
4. `IV. NUMERICAL RESULTS / CASE STUDY`
5. `V. CONCLUSION`

### Counterexample or Correction Letter

1. `I. INTRODUCTION`
2. `II. ASSUMPTION / COUNTEREXAMPLE`
3. `III. ANALYSIS AND IMPLICATION`
4. `IV. CONCLUSION`

### Focused Algorithm or Application Letter

1. `I. INTRODUCTION`
2. `II. PROBLEM SETTING`
3. `III. COMPACT METHOD`
4. `IV. DECISIVE TEST`
5. `V. CONCLUSION`

Section names may be merged when page economy requires it.

## Initial-Submission Budget

Use this approximate 3-page budget, including references:

- abstract and index terms: 0.15-0.20 page;
- introduction: 0.45-0.65 page;
- technical core: 1.15-1.45 pages;
- proof/case/validation: 0.55-0.75 page;
- conclusion and references: 0.35-0.55 page.

The sum must be checked in the actual IEEE template. Character or word counts do not prove page compliance.

If the technical core cannot be established within roughly 1.5 pages after removing nonessential exposition, the claim is normally too broad for the Letter format.

## Section Discipline

- Start the technical object immediately after the introduction.
- Use subsections only when they reduce rather than increase navigation burden.
- Number equations only when later reference is required.
- Define symbols at first use.
- Keep only proof steps required for the claim; do not hide a missing proof behind numerical evidence.
- Each figure or table must establish a specific part of the claim.
- References must cover the nearest work without becoming a broad review.

## Title Discipline

Name the exact technical object or result. Suitable patterns include:

- `On the ...`;
- `An Analytical ... for ...`;
- `A Counterexample to ...`;
- `A Compact ... Formulation for ...`;
- `... Cannot Guarantee ...`;
- `Efficient ... Calculation under ...`.

Avoid titles that bundle several modules through terms such as “comprehensive framework” or “integrated architecture” unless that combined object is itself the single claim.
