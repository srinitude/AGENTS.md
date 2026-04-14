All data work must be reproducible, assumptions must be stated, and every transformation must be documented. No analysis may be delivered without exploring edge cases and quantifying uncertainty. Plausible-looking results built on undocumented assumptions are prohibited.

---

## 1. Assumptions Before Transformations

* Every assumption about the data must be stated before any transformation is applied.
* Assumptions include: expected schema, value ranges, uniqueness constraints, null semantics, time zones, encoding, and units.
* If an assumption cannot be verified against the data, it must be flagged as unverified.
* Transforming data without stating assumptions is prohibited.

---

## 2. No Magic Numbers

* Every threshold, constant, filter value, and parameter must be named and justified.
* Hard-coded numeric values without explanation are prohibited.
* If a value is chosen by convention, the convention must be cited.
* If a value is chosen by judgment, the reasoning must be documented.

---

## 3. Transformation Documentation

* Every transformation step must be documented with its purpose and expected effect.
* The input shape and output shape of each step must be stated.
* Transformations must be ordered so each step depends only on the output of preceding steps.
* Undocumented transformations are prohibited.

---

## 4. Edge Case Exploration

* Every analysis must explicitly consider: empty datasets, null values, duplicates, extreme values, and boundary conditions.
* The behavior of each transformation on edge cases must be stated.
* If edge cases are excluded, the exclusion criteria and justification must be documented.
* Ignoring edge cases without explicit acknowledgment is prohibited.

---

## 5. Sample Sizes and Significance

* Every aggregate result must report the sample size it was computed from.
* Comparisons must state whether differences are meaningful given the sample sizes.
* Percentages must always be accompanied by absolute counts.
* Drawing conclusions from insufficient data without disclosure is prohibited.

---

## 6. Reproducibility

* Every analysis must be reproducible from the documented steps alone.
* Random processes must use fixed seeds or document the non-determinism.
* Environment-dependent behavior (time zones, locale, floating-point precision) must be documented.
* If reproducing the analysis requires specific data access, this must be stated.

---

## 7. Source Data Integrity

* The provenance of all input data must be documented: where it came from, when it was captured, and any known quality issues.
* Modifications to source data (cleaning, imputation, filtering) must be tracked separately from analysis.
* The agent must never silently alter source data.
* If source data quality is unknown, this must be stated as a limitation.

---

## 8. Visualization and Presentation

* Every chart, table, or summary must include axis labels, units, and time ranges where applicable.
* Visualizations must not distort the data through misleading scales, truncated axes, or cherry-picked ranges.
* The choice of visualization type must be appropriate for the data type and the question being answered.
* Presenting results without context sufficient for interpretation is prohibited.

---

## 9. Conclusions and Limitations

* Every conclusion must state what the data shows and what it does not show.
* Correlation must never be presented as causation without explicit justification.
* Known limitations of the analysis must be listed alongside conclusions.
* Overstating the strength of findings beyond what the data supports is prohibited.

---

## 10. Enforcement

* These are hard constraints, not best practices.
* Any violation must be resolved before the analysis is considered complete.
* No exceptions for exploratory work, quick analyses, or time constraints.
* Data work that violates these constraints is considered incomplete and must not be delivered.
