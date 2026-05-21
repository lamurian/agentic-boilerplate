---
title: UAT — Init Skill
description: Verify the init skill correctly interviews user and generates project-specific documentation
---

# Init Skill UAT

## Scenario A: Data Analysis with Python + pixi + Quarto

**Setup:** Fresh boilerplate copy with empty `docs/agents/`.

**Run:** Agent reads `@.agents/skills/init/SKILL.md` and follows the init skill.

**Answers:**
- Project name: `data-playground`
- Description: `Statistical analysis and reporting pipeline`
- Type: Data analysis
- Runtime: Python
- Language: Python
- Env manager: pixi
- Testing: pytest
- Notebook env: Quarto
- Viz: plotly
- Data libs: pandas + numpy

**Phase 4a (ADR TODO) checks:**
- Agent proposes 3 ADRs: 001 (Project Architecture), 004 (Environment & Tooling), 007 (Data Processing Pipeline)
- User requests adding ADR-008 for visualization library choice
- Agent adds it, re-presents for confirmation
- User approves final list of 4 ADRs

**Verification:**

| File | Check |
|------|-------|
| Phase 4a | ADR TODO presented with 3 relevant ADRs; user iterated once (added ADR-008) before approval |
| `ADR/001-project-architecture.md` | YAML frontmatter with correct title/description; Context/Decision/Impact sections filled |
| `ADR/002-*` | At minimum ADR-004 and ADR-007 exist (Environment, Data Pipeline) |
| `ARCHITECTURE.md` | Tech stack has Python/Quarto/pandas/plotly; data flow shows notebook-to-report pipeline; key patterns include data validation; Architecture Decisions section lists all created ADRs |
| `STANDARDS.md` | Has Python-specific conventions (PEP 8, type hints, NumPy-style docstrings) |
| `KNOWN_PITFALLS.md` | Includes data pitfalls (out-of-order execution, mutating while iterating) |
| `PROJECT_STRUCTURE.md` | Shows `notebooks/`, `data/` (raw, processed), `reports/`, `src/`; no `infra/` or `config/` |
| Skill file | `init/` moved to `docs/plans/archive/init-skill/`; Step 0 section removed from AGENTS.md |

## Scenario B: Node.js Express REST API with PostgreSQL + Prisma

**Setup:** Fresh boilerplate copy with empty `docs/agents/`.

**Run:** Agent reads `@.agents/skills/init/SKILL.md` and follows the init skill.

**Answers:**
- Project name: `api-service`
- Description: `RESTful API for resource management`
- Type: Web API
- Runtime: Node.js
- Language: TypeScript
- API style: REST
- Auth: JWT
- OpenAPI: Yes
- Database: PostgreSQL
- ORM: Prisma
- Testing: Vitest
- CI/CD: GitHub Actions

**Phase 4a (ADR TODO) checks:**
- Agent proposes 5 ADRs: 001 (Project Architecture), 002 (Database & ORM), 003 (API Design), 005 (Auth), 006 (CI/CD)
- User confirms without changes

**Verification:**

| File | Check |
|------|-------|
| Phase 4a | ADR TODO presented with 5 relevant ADRs; user confirmed in one round |
| `ADR/001-project-architecture.md` | Exists with correct fields; decision section has all choices with rationale |
| `ADR/002-*` | At minimum ADR-002, ADR-003, ADR-005 exist (Database, API Design, Auth) |
| `ARCHITECTURE.md` | Tech stack has Node.js/TypeScript/Express/PostgreSQL/Prisma/REST; data flow shows Client → Router → Middleware → Controller → Service → DB; Architecture Decisions section lists all created ADRs |
| `STANDARDS.md` | Includes route naming (plural RESTful), status code conventions, error response format |
| `KNOWN_PITFALLS.md` | Includes N+1 queries, missing CORS, no input validation |
| `PROJECT_STRUCTURE.md` | Shows `src/routes/`, `src/controllers/`, `src/middleware/`, `src/services/`, `src/validators/` |
| Skill file | Archived; Step 0 section removed from AGENTS.md |

## Acceptance Criteria

- [ ] All 4 docs/agents/*.md files created
- [ ] Multiple ADRs created matching the archetype (not just ADR-001)
- [ ] ADR TODO was presented to user before drafting any ADR
- [ ] User was able to iterate on the ADR list (add/remove/rename)
- [ ] Each file is under 100 lines
- [ ] Project structure matches the chosen archetype
- [ ] Standards include framework-specific rules
- [ ] Pitfalls include stack-specific anti-patterns
- [ ] ARCHITECTURE.md references all created ADRs
- [ ] Init skill archived after completion
- [ ] Step 0 section removed from AGENTS.md
- [ ] Both scenarios produce completely different output
