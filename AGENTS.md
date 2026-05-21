---
title: Agentic Documentation
description: Single source of truth and the root reference for an AI agent
---

## Hallucination Prevention (CRITICAL)

- READ `@docs/agents/PROJECT_STRUCTURE.md` before creating or moving files
- READ `@docs/agents/STANDARDS.md` before writing code
- CHECK actual source: do NOT invent function names, types, or APIs
- GREP existing patterns before adding dependencies or conventions
- RUN tests after every change: fix failures immediately
- When unsure, READ the codebase: do NOT guess
- If a simpler approach exists, use it: no over-engineering

## Operating Procedures

- Write tests alongside code: test behavior, not implementation
- Keep functions under 50 lines unless justified
- Use explicit error handling: no silent catches or `throw Error`
- Type everything explicitly: avoid `any` and inferred `as` casts
- Prefer readability over cleverness: one-liners are not goals
- Document relative path from the project root: `@/path/to/file.txt`
- Any directory named archive/ at any depth MUST be ignored by all agentic tools

## Reference

- Code conventions: READ `@docs/agents/STANDARDS.md`
- Common mistakes to avoid: READ `@docs/agents/KNOWN_PITFALLS.md`
- Full directory map: READ `@docs/agents/PROJECT_STRUCTURE.md`
- System design and decisions: READ `@docs/agents/ARCHITECTURE.md`
- Document templates: READ `@docs/templates/`

## Nested AGENTS.md Files

Subdirectories may contain their own AGENTS.md with scope-specific instructions.
- PRECEDENCE: The AGENTS.md closest to the file being edited takes priority
- INHERITANCE: Nested files supplement, not replace, this root file

## Architecture Decision Records (ADRs)

- Before architecture changes: READ `@docs/agents/ARCHITECTURE.md` for existing decisions
- New decisions: Create ADR at `@docs/ADR/NNN-title.md` (3-digit enum, <5 word title)
- Format: YAML frontmatter (title, description, status, date) + H1 sections (Context, Decision, Impact): use template at `@docs/templates/ADR.md`
- After creating ADR: Update ARCHITECTURE.md to reference it with `@docs/ADR/NNN-title.md`

## Plan Lifecycle

1. Brainstorm: Discuss feature with user.
2. Clarify: Ask questions until scope is clear.
3. Formulate WPs: Break into atomic work packages.
4. Write plan: Create `@docs/plans/NNN-plan-name.md` per WP.

For detailed workflow, read `@.agents/skills/brainstorm/SKILL.md`.

## Task Lifecycle

Trigger: user says "implement @path/to/plan.md".

1. Read plan: Understand the work packages.
2. Create @TODO.md: Derive checklist from plan using `@docs/templates/todo.md`.
3. Execute tasks: Work through TODO.md, update checkboxes after each.
4. Auto-test: Run full test suite; fix failures before proceeding.
5. Guide UAT: Run `@docs/UAT/` procedures.
6. Archive: Move plan to `docs/plans/archive/` and TODO.md alongside.

For detailed workflow, read `@.agents/skills/implement/SKILL.md`.

## Documentation Limits

- Apply to all documentations in `.md`, `.mdx`, `.qmd` format.
- The limit is 100 lines per document. Split to focused sub-documents if needed. Prefer short sentences over long, complex ones.
- Hierarchical reference: only documents in the higher directory may refer the subdirectories
