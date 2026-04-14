All architectural decisions must follow a structured evaluation process. No solution may be recommended without first documenting the problem, constraints, and at least two alternatives with explicit trade-offs. Jumping to a solution without evaluating options is prohibited.

---

## 1. Problem Before Solution

* Every architectural decision must begin with a clear problem statement.
* The problem statement must describe what is broken, missing, or inadequate — not which technology to use.
* If the problem cannot be stated without referencing a specific solution, the problem is not yet understood.
* Proposing solutions before documenting the problem is prohibited.

---

## 2. Constraints Documentation

* All constraints must be documented before evaluating solutions.
* Constraints include: performance requirements, cost limits, team capabilities, timeline, compliance requirements, existing system dependencies, and operational capacity.
* Assumed constraints must be labeled as assumptions, not stated as facts.
* Evaluating solutions without documented constraints is prohibited.

---

## 3. Alternatives Required

* Every decision must evaluate at least two distinct alternatives.
* "Do nothing" must always be considered as one of the alternatives.
* Alternatives must be genuinely different approaches, not superficial variations of the same idea.
* Recommending a solution without documented alternatives is prohibited.

---

## 4. Trade-Off Analysis

* Every alternative must have its trade-offs stated explicitly.
* Trade-offs must cover: what you gain, what you lose, what becomes harder, and what risks emerge.
* Trade-offs must be evaluated against the documented constraints, not in the abstract.
* Presenting any option as having no downsides is prohibited.

---

## 5. Decision Records

* Every significant decision must produce a written record.
* The record must include: context, problem statement, constraints, alternatives considered, trade-offs, decision made, and rationale.
* The rationale must explain why the chosen option was selected over the alternatives.
* Decisions without written records are considered undocumented and incomplete.

---

## 6. Reversibility Assessment

* Every decision must state its reversibility: easily reversible, reversible with effort, or irreversible.
* Irreversible decisions require stronger evidence and more thorough evaluation.
* The cost of reversal must be estimated in concrete terms (time, data migration, rewrite scope).
* Treating irreversible decisions with the same rigor as reversible ones is prohibited.

---

## 7. Scope and Boundary Definition

* Every architectural component must have clearly defined boundaries and responsibilities.
* Interactions between components must be documented at the interface level.
* Shared responsibilities between components must be explicitly acknowledged and justified.
* Introducing components without defined boundaries is prohibited.

---

## 8. Failure Mode Analysis

* Every architecture must document its expected failure modes.
* For each failure mode, the expected behavior and recovery path must be stated.
* Single points of failure must be identified and acknowledged.
* Presenting an architecture without failure analysis is prohibited.

---

## 9. Incremental Validation

* Architectural decisions must be validated incrementally, not all at once at the end.
* Each decision should identify the cheapest way to validate its core assumption.
* If a decision cannot be validated before full implementation, this risk must be documented.
* Deferring all validation until after complete implementation is prohibited.

---

## 10. Enforcement

* These are hard constraints, not design preferences.
* Any violation must be resolved before the architecture is considered complete.
* No exceptions for urgency, seniority, or organizational pressure.
* Architectural work that violates these constraints is considered incomplete and must not be delivered.
