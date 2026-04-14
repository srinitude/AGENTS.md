# AGENTS.md Collection

A curated collection of `AGENTS.md` files — instruction sets I drop into the root of different projects to shape how AI coding agents behave when working alongside me.

## What is an AGENTS.md?

An `AGENTS.md` is a project-level directive file that tells AI agents *how* to work, not just *what* to build. Think of it as a constitution for your AI collaborator: it encodes your standards, constraints, workflows, and non-negotiables so the agent operates within your mental model from the first interaction.

## Why a collection?

Different projects demand different disciplines. The way I want an agent to approach a greenfield API is not the way I want it to write a data pipeline, draft a design doc, or restructure a monorepo. Each `AGENTS.md` here is tailored to a specific type of work:

| File | Domain | Philosophy |
|------|--------|------------|
| `architecture/AGENTS.md` | **Architecture & design** | Problem → Constraints → Alternatives → Trade-offs → Decision record. At least two options evaluated, reversibility assessed, failure modes documented |
| `code/AGENTS.md` | **TDD-strict software engineering** | Red → Green → Refactor with hard structural constraints (nesting ≤ 3, constructs ≤ 30 LOC, dependency injection at the boundary) |
| `data/AGENTS.md` | **Data & analytics** | Assumptions stated, transformations documented, edge cases explored, sample sizes reported. No magic numbers, no undocumented transforms, no conclusions without limitations |
| `planning/AGENTS.md` | **Project planning** | Scope → Dependencies → Risks → Unknowns → Estimates. Critical path identified, capacity constraints respected, no point estimates without assumptions |
| `research/AGENTS.md` | **Research & analysis** | Question → Evidence → Counter-arguments → Confidence assessment. Sources attributed, uncertainty disclosed, reasoning chain visible |
| `writing/AGENTS.md` | **Writing & editing** | Purpose → Audience → Outline → Draft → Revise. One idea per paragraph, all claims grounded, no first-draft delivery |

## Beyond Code

`AGENTS.md` files aren't limited to software. The same principle — encoding process discipline into a directive the agent follows — applies to any structured creative or analytical work:

- **Writing & Editing** — Enforce tone, voice, citation standards, audience awareness, and revision workflows. Prevent the agent from producing generic filler or hallucinating sources.
- **Research & Analysis** — Require structured reasoning: hypothesis first, evidence gathering, counter-argument consideration, explicit uncertainty disclosure. Ban unsupported claims.
- **Design & Architecture** — Mandate decision records, constraint documentation, trade-off analysis before any recommendation. Prevent premature solutioning.
- **Data & Analytics** — Enforce reproducibility: no magic numbers, all transformations documented, assumptions stated, edge cases explored before conclusions are drawn.
- **Project Planning** — Require scope decomposition, dependency mapping, and risk identification before any timeline or estimate is produced.
- **Content & Marketing** — Lock in brand voice, factual accuracy requirements, audience segmentation, and A/B-testable structure.
- **Legal & Compliance** — Require jurisdiction-awareness, precedent citation, and explicit flagging of areas needing human review.

The pattern is universal: **define the process, constrain the shortcuts, and make the agent earn every output.**

## How to Use

Run `install.sh` to compose and install an `AGENTS.md` into any project:

```bash
# See available domains and usage
./install.sh

# Install root directives only (universal principles, any project type)
./install.sh ~/my-project

# Install root + a specific domain
./install.sh ~/my-project code

# Compose multiple domains into a single file
./install.sh ~/my-project code writing
```

### Scatter mode

For projects that span multiple domains, use `--scatter` to place each domain's rules in the subdirectory where they apply:

```bash
# Code rules in src/, writing rules in docs/, root principles at project root
./install.sh --scatter ~/my-project src:code docs:writing

# Works with nested paths too
./install.sh --scatter ~/my-project src/lib:code content/blog:writing
```

This produces:

```
~/my-project/
├── AGENTS.md              ← root principles (always included)
├── src/
│   └── AGENTS.md          ← code domain rules
└── docs/
    └── AGENTS.md          ← writing domain rules
```

Agents that support `AGENTS.md` hierarchy will inherit the root principles everywhere and apply domain rules only within their subdirectory. Creates missing subdirectories automatically.

No dependencies. Just bash.

### Manual alternative

If you prefer, copy the files directly:

1. Copy the root `AGENTS.md` into your project.
2. Append the contents of any domain-specific file (e.g., `code/AGENTS.md`) below it.
3. Adapt the constraints to your team's standards and the project's needs.

## Design Principles

Every `AGENTS.md` in this collection follows a few core beliefs:

- **Constraints produce quality.** Unconstrained agents produce mediocre, generic output. Hard limits force thoughtful work.
- **Process over output.** Specifying *how* to work matters more than specifying *what* to produce. Good process reliably yields good results.
- **Observable behavior over implementation.** Whether it's testing software or reviewing a draft, validate what the user actually sees and experiences.
- **Dependencies are explicit.** In code, this means injection. In writing, this means cited sources. In analysis, this means stated assumptions. Nothing is implicit.
- **Small, focused units.** 30-line functions. Single-responsibility paragraphs. One-claim-per-section arguments. Decomposition is non-negotiable.

## Testing

The repo includes a comprehensive test suite — pure bash, zero dependencies:

```bash
./test.sh
```

Two test suites validate everything:

| Suite | What it verifies |
|-------|------------------|
| `test_install` | Installer behavior: error handling, root-only install, single domain, multi-domain composition, ordering guarantees, idempotency, deeply nested domains |
| `test_structure` | Structural contracts: required files exist, root AGENTS.md encodes all core principles, every AGENTS.md has substance/sections/imperative language, README covers all domains, LICENSE is Apache 2.0 |

The structural tests act as a **linting gate** — any new AGENTS.md added to the repo is automatically validated for minimum quality (≥10 lines, ≥2 sections, ≥3 bullet constraints, imperative enforcement language). This prevents vague or aspirational files from entering the collection.

## Contributing

If you have `AGENTS.md` files that encode a strong, opinionated workflow for a specific domain — send them over. The bar is high: no vague guidelines, no aspirational wish lists. Only hard constraints that measurably change agent behavior.

## License

Licensed under the [Apache License, Version 2.0](LICENSE). See the LICENSE file for details.
