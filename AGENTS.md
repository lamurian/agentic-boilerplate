# [Project Name]

## Commands
- Build: `[command]`
- Test: `[command]`
- Lint: `[command]`
- Type-check: `[command]`

## Hallucination Prevention (CRITICAL)
- READ `docs/agents/PROJECT_STRUCTURE.md` before creating or moving files
- READ `docs/agents/STANDARDS.md` before writing code
- CHECK actual source — do NOT invent function names, types, or APIs
- GREP existing patterns before adding dependencies or conventions
- RUN tests after every change — fix failures immediately
- When unsure, READ the codebase — do NOT guess
- If a simpler approach exists, use it — no over-engineering

## Code Standards
For full conventions: READ `docs/agents/STANDARDS.md`

Key rules enforced in this project:
- Write tests alongside code — test behavior, not implementation
- Keep functions under 50 lines unless justified
- Use explicit error handling — no silent catches or `throw Error`
- Type everything explicitly — avoid `any` and inferred `as` casts
- Prefer readability over cleverness — one-liners are not goals

## Project Structure
For full directory map: READ `docs/agents/PROJECT_STRUCTURE.md`

## Architecture
For system design and decisions: READ `docs/agents/ARCHITECTURE.md`

## Known Pitfalls
For common mistakes to avoid: READ `docs/agents/KNOWN_PITFALLS.md`

## Nested AGENTS.md Files
Subdirectories may contain their own AGENTS.md with scope-specific instructions.
- PRECEDENCE: The AGENTS.md closest to the file being edited takes priority
- INHERITANCE: Nested files supplement, not replace, this root file

## Architecture Decision Records (ADRs)
- Before architecture changes: READ `docs/agents/ARCHITECTURE.md` for existing decisions
- New decisions: Create ADR at `docs/ADR/NNN-title.md` (3-digit enum, <5 word title)
- Format: YAML frontmatter (title, description, status) + H1 sections (Context, Decision, Impact)
- After creating ADR: Update ARCHITECTURE.md to reference it with `@docs/ADR/NNN-title.md`

## Before Submitting
1. Run lint — fix all warnings
2. Run tests — all must pass
3. No debug logs, TODOs, or commented-out code
4. No files changed outside task scope
5. Verify file paths match `docs/agents/PROJECT_STRUCTURE.md`
