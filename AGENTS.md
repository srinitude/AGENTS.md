This repository contains a collection of AGENTS.md directive files organized in subdirectories by domain. Each subdirectory may contain its own AGENTS.md with domain-specific constraints. This root-level file governs all work across the entire repository and all nested directories at any depth.

---

## 1. Hierarchy & Inheritance

* This file is the root authority. Its rules apply everywhere, unconditionally.
* Subdirectory AGENTS.md files add domain-specific constraints that layer on top of this file.
* When a subdirectory AGENTS.md exists, follow both this file and that file.
* If a subdirectory AGENTS.md contradicts this file, this file wins.
* Nesting depth is unlimited — a file at `a/b/c/d/AGENTS.md` inherits from every ancestor up to and including this root.
* When multiple ancestor AGENTS.md files exist, apply them all from root downward, with each level able to add constraints but never remove those imposed by a higher level.

---

## 2. Constraints Produce Quality

* Unconstrained work produces mediocre, generic output.
* Every directive in this repository exists because it measurably changes agent behavior.
* Vague guidance is prohibited. Every rule must be concrete, enforceable, and observable.
* If a constraint cannot be verified through the output, it does not belong here.

---

## 3. Process Over Output

* How you work matters more than what you produce.
* Follow the process defined by the applicable AGENTS.md files completely before producing any deliverable.
* Do not skip steps to arrive at a result faster.
* Do not combine phases that are defined as sequential.
* If a process defines an order, that order is mandatory.

---

## 4. Observable Behavior Over Implementation

* Validate what the end user actually sees, reads, or experiences.
* Do not optimize for internal elegance at the expense of external correctness.
* In code: test public interfaces. In writing: evaluate what the reader encounters. In analysis: judge the conclusions and their support.
* Internal structure serves external quality, never the reverse.

---

## 5. Explicit Over Implicit

* All dependencies, assumptions, and sources must be stated, never inferred.
* In code: dependencies are injected, not constructed internally.
* In writing: claims are sourced, not asserted.
* In analysis: assumptions are declared, not buried.
* In planning: risks are named, not ignored.
* Nothing is left for the reader, user, or reviewer to guess.

---

## 6. Small, Focused Units

* Decomposition is non-negotiable across all domains.
* Every unit of work — function, paragraph, section, argument, task — must have one clear responsibility.
* Large, multi-concern constructs are prohibited.
* When something grows beyond its single purpose, split it immediately.

---

## 7. Earned Output

* The agent must earn every output through the defined process.
* No shortcutting to a "good enough" result.
* No producing output that bypasses the constraints of the applicable AGENTS.md files.
* If the process is burdensome, that burden is the point — it forces rigor.

---

## 8. Enforcement

* These are hard constraints, not suggestions.
* Any violation must be resolved immediately upon detection.
* No exceptions for convenience, speed, or subjective preference.
* Work that violates any applicable AGENTS.md — root or nested — is considered incomplete.
* When in doubt, apply the stricter interpretation.
