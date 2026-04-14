You must operate strictly in a TDD-first RED → GREEN → REFACTOR cycle for all code changes. No production code may be written unless it is directly driven by a failing test. All dependencies must be treated as externally provided capabilities, declared at the boundary and supplied at runtime.

---

## 1. RED (Failing Test Required)

* Begin every unit of work by writing a failing test that reflects a real user-facing behavior, contract, or interface.
* Tests must validate externally observable outcomes only (inputs, outputs, side effects, API responses, UI states).
* Tests must interact only with public interfaces or system boundaries.
* Dependencies must be treated as abstract capabilities (e.g., HTTP client, database, filesystem, clock) and supplied explicitly to the system under test.
* You are strictly prohibited from:

  * Testing private/internal functions, classes, or modules
  * Asserting on implementation details (method calls, internal state, structure)
  * Writing tests that would pass even if the underlying implementation were replaced
  * Instantiating real external systems directly inside tests

---

## 2. GREEN (Minimal Implementation)

* Write the smallest possible amount of code required to make the failing test pass.
* Do not preemptively generalize or optimize.
* Do not add functionality beyond what is required by the current failing test.
* All dependencies must be consumed via declared interfaces/capabilities, not constructed inline.
* Business logic must remain unaware of concrete implementations.

---

## 3. REFACTOR (Safe Improvement)

* Refactor only after tests are passing.
* You may improve structure, readability, and maintainability only if all tests remain green.
* Refactoring must not change externally observable behavior.
* You may extract and reorganize dependency wiring into composition layers, but must not leak implementation details into business logic.

---

## 4. Dependency & Test Model (Strict)

* All external systems (network, filesystem, database, time, third-party APIs) must be represented as abstract capabilities.
* The system must declare its required capabilities explicitly.
* Concrete implementations must be provided externally at the composition/runtime boundary.
* Tests must provide controlled, deterministic implementations of these capabilities.
* Tests must not depend on real external systems or implicit global state.
* Tests must validate behavior through capability interactions and observable outcomes only.

---

## 5. Test Constraints (Strict)

* All tests must:

  * Represent user intent or system contracts
  * Be written at the boundary of the system (API layer, CLI interface, UI, or public service interfaces)
  * Interact with the system through declared capabilities only
* If a test requires knowledge of internal implementation to exist, it is invalid and must not be written.

---

## 6. Enforcement Rules

* No code without a prior failing test.
* No passing tests that do not reflect real user behavior.
* No skipping RED or combining phases.
* No constructing dependencies inside business logic.
* All dependencies must be supplied from the outside.
* If uncertain whether a test is valid, default to higher-level, user-observable behavior.

---

## 7. Definition of Done

A task is only complete when:

* All tests were written first (RED)
* All tests pass (GREEN)
* Code has been safely improved (REFACTOR)
* Dependencies are declared, not constructed
* Concrete implementations are provided only at the boundary
* Tests verify real-world usage through observable behavior and controlled capability implementations

If you violate any of these constraints, the output is considered incorrect.

---

## 8. Code Structure Constraints (Strict, Non-Negotiable)

### 8.1 Maximum Nesting Depth (≤ 3)

* All production code MUST have a maximum nesting depth of 3.
* Nesting includes: if, else, switch, loops, closures, callbacks, and scoped blocks.
* Each new block increases depth by 1.
* Depth MUST be minimized using:

  * Guard clauses / early returns
  * Function extraction
  * Declarative transformations (map, filter, reduce) instead of nested loops
* Tests:

  * Nesting depth is measured relative to the test declaration boundary (test, it, etc.).
  * Setup, execution, and assertions within that scope must still not exceed depth 3.

### 8.2 Maximum Construct Size (≤ 30 LOC)

* Every construct MUST be ≤ 30 lines of executable code.
* Applies to:

  * Functions / methods
  * Classes
  * Interfaces / types
  * Structs / protocols
  * Modules
* Rules:

  * Blank lines and comments count
  * Inline closures/lambdas count toward the parent construct
* If exceeded, MUST refactor via:

  * Function decomposition
  * Composition
  * Module extraction

### 8.3 Single Responsibility Enforcement

* Each construct MUST have one clearly defined responsibility.
* Mixed concerns within a single construct are prohibited.
* Violations MUST be split into smaller units.

### 8.4 Prohibited Patterns

* Nesting depth > 3 under any circumstance
* Multi-responsibility ("god") constructs
* Hidden complexity via deeply nested inline closures
* Large test blocks obscuring behavior
* Implicit control flow that increases cognitive depth

### 8.5 Required Refactoring Strategies

* Flatten control flow aggressively
* Prefer pure functions
* Replace imperative nesting with declarative pipelines
* Extract intermediate variables for clarity
* Co-locate logic with explicit boundaries

### 8.6 Enforcement

* These are hard constraints, not guidelines
* Any violation MUST be resolved immediately
* No exceptions for "readability" or "performance" without restructuring
* Code that violates these constraints is considered invalid and incomplete
