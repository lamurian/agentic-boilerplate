---
title: Agentic Documentation
description: Single source of truth and the root reference for an AI agent
---

## Hallucination Prevention (CRITICAL)

- READ `@docs/agents/PROJECT_STRUCTURE.md` before creating or moving files
- READ `@docs/agents/STANDARDS.md` before writing code
- CHECK actual source — do NOT invent function names, types, or APIs
- GREP existing patterns before adding dependencies or conventions
- RUN tests after every change — fix failures immediately
- When unsure, READ the codebase — do NOT guess
- If a simpler approach exists, use it — no over-engineering

## Operating Procedures

- Write tests alongside code — test behavior, not implementation
- Keep functions under 50 lines unless justified
- Use explicit error handling — no silent catches or `throw Error`
- Type everything explicitly — avoid `any` and inferred `as` casts
- Prefer readability over cleverness — one-liners are not goals
- Document relative path from the project root: `@/path/to/file.txt`
- archive/: Any directory named archive/ at any depth MUST be ignored by all agentic tools. Do not read, load, summarize, or reference archived content. This covers docs/plans/archive/, docs/adr/archive/, and similar.

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
- Format: YAML frontmatter (title, description, status, date) + H1 sections (Context, Decision, Impact) — use template at `@docs/templates/ADR.md`
- After creating ADR: Update ARCHITECTURE.md to reference it with `@docs/ADR/NNN-title.md`

## Plan Lifecycle

- User requests a feature → brainstorm → draft plan in docs/plans/ with atomic
  build phases → write plan doc → create @TODO.md from plan checklist
- Update @TODO.md checkboxes as each task completes
- When all tasks are done and UAT passes: move plan file to docs/plans/archive/plan-name.md and archive TODO.md alongside it as docs/plans/archive/task-date-plan-name.md

## Work Package Tracking

- @TODO.md: Active task tracker. Read before any work. Update checkboxes as tasks complete. Append new sub-tasks under the relevant WP section.
- @docs/plans/: Active plans for the current work. Read the relevant plan before starting implementation of a given WP.
- @docs/UAT/: User acceptance test procedures. Run the corresponding UAT after completing a WP implementation step.

## Documentation Limits

- All agentic documentation (AGENTS.md, plans, UAT, TODO.md, STANDARDS.md, ANTIPATTERN.md) must not exceed 100 lines per file. Split into focused sub-documents if needed. Prefer short sentences over long, complex ones.
