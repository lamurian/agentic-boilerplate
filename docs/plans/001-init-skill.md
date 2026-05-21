---
title: Init Skill — Project Architecture Brainstorm
description: One-time skill to interview user, brainstorm architecture, finalize all docs/agents/*.md, create ADR, and optimize AGENTS.md
date: 2026-05-22
---

# Overview

When a user starts a new project from this boilerplate, `docs/agents/ARCHITECTURE.md`
contains `[...]` placeholders and other agent docs are generic. The init skill runs
a collaborative architecture brainstorming session (two-way agent ↔ user) to finalize
all agentic documentation, creating a spec-driven development foundation.

Output: finalized `ARCHITECTURE.md`, `STANDARDS.md`, `KNOWN_PITFALLS.md`,
`PROJECT_STRUCTURE.md`, `docs/ADR/001-project-architecture.md`, and optimized root
`AGENTS.md`.

# Goals

- Eliminate all `[...]` placeholders from `docs/agents/` after a single session
- Produce project-specific agent docs that guide every subsequent feature plan and implementation
- Support two-way brainstorming: agent asks structured questions, user asks questions back
- Cover 7+ project archetypes including data analysis with conditional sub-questions
- Self-cleanup: archive the init skill after first use

# Implementation Steps

## WP-0: Root AGENTS.md update

- [ ] Add "Step 0: Project Initialization" before the Plan Lifecycle section
- [ ] Reference `@.agents/skills/init/SKILL.md` when `docs/agents/ARCHITECTURE.md` has `[...]`
- [ ] List init skill in available skills

## WP-1: Create `.agents/skills/init/SKILL.md`

### Phase 1 — Auto-detect

- [ ] Scan for `package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`, `tsconfig.json`, `Dockerfile`, `Makefile`, `.github/workflows/`, `conda-lock`, `pixi.lock`, `poetry.lock`, `uv.lock`
- [ ] Parse dependency manifests for framework, test tool, DB driver hints
- [ ] Present detected values as defaults; user confirms or overrides

### Phase 2 — Structured Interview + Brainstorming (two-way)

Core questions (always asked):

| # | Question | Notes |
|---|----------|-------|
| 1 | Project name | Used as title throughout |
| 2 | One-line description | YAML frontmatter description |
| 3 | **Project type**: Web API / CLI tool / Library / Fullstack app / Mobile backend / **Data analysis** / Other | Primary archetype selector |
| 4 | Runtime: Node.js / Deno / Bun / Python / Go / Rust / Other | |
| 5 | Language: TypeScript / JavaScript / Python / Go / Rust / Other | |

Conditional trigger questions:

| Trigger | Question(s) | Agent behavior |
|---------|-------------|----------------|
| Type = Data analysis | Notebook env (Jupyter Lab / Quarto / Marimo)? Output format (reports / dashboards / API)? Viz lib (matplotlib / plotly / altair)? Data libs (pandas / polars / numpy)? | Suggest tradeoffs: "Quarto gives publication-grade docs, Marimo is reactive" |
| Language = Python | Env manager (conda / pixi / venv / poetry / rye / uv)? Testing (pytest / unittest)? Linter (ruff / pylama)? | "pixi is fast and conda-compatible; uv is fastest pip alternative" |
| Type = Web API | API style (REST / GraphQL / tRPC / gRPC)? Auth (JWT / sessions / OAuth)? OpenAPI? | "tRPC gives end-to-end typesafe if using TypeScript" |
| Type = Fullstack | Monorepo tool (turborepo / nx / pnpm workspaces)? Shared validation? | |
| Type = CLI tool | Args parser (commander / click / cobra)? Config files? Output format? | |
| Database chosen | ORM (Prisma / Drizzle / SQLAlchemy / raw SQL)? Migrations? Pooling? | "Drizzle is lighter, Prisma has better DX" |
| CI/CD chosen | Platform (Vercel / Railway / Docker / k8s / AWS / GCP)? | |
| Framework = Next.js | App Router / Pages Router? Server Components by default? Rendering? | |

For each decision point, the agent presents 2-3 options with tradeoffs, then asks
the user to choose. User can ask follow-up questions or propose alternatives.

### Phase 3 — Open Q&A (user-driven)

- [ ] After structured interview, agent asks: "Do you have any questions about the architecture we've outlined?"
- [ ] Agent answers using the established project profile
- [ ] If answers lead to new architecture decisions, they are noted for ADR inclusion

### Phase 4 — Generate finalized documentation

- [ ] Write `docs/agents/ARCHITECTURE.md` — full tech stack, data flow, design principles, key patterns
- [ ] Write `docs/agents/STANDARDS.md` — generic + framework-specific conventions
- [ ] Write `docs/agents/KNOWN_PITFALLS.md` — generic + stack-specific pitfalls
- [ ] Write `docs/agents/PROJECT_STRUCTURE.md` — project-specific directory tree
- [ ] Create `docs/ADR/001-project-architecture.md` — ADR documenting key decisions
- [ ] Update root `AGENTS.md` — add project-specific rules

### Phase 5 — Self-cleanup

- [ ] Move `init/SKILL.md` to `docs/plans/archive/init-skill.md`
- [ ] Remove or comment out the Step 0 reference in root `AGENTS.md`

## WP-2: Create `docs/UAT/001-init-skill.md`

- [ ] Write UAT test procedure with two scenarios
- [ ] Scenario A: Data analysis with Python + pixi + Quarto
- [ ] Scenario B: Node.js Express REST API with PostgreSQL + Prisma
- [ ] Each scenario verifies all 5 output files are correct and skill is archived

# Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| User has questions the skill doesn't anticipate | Medium | Low | Phase 3 open Q&A; agent uses general knowledge |
| Two-way conversation causes scope creep | Medium | Medium | Skill defines clear phases; agent gently steers back |
| 100-line limit on agent docs may be exceeded | Low | Low | Skill enforces concise content; splits into sub-docs if needed |
| Auto-detect gives wrong inference | Low | Medium | Always ask user to confirm before proceeding |

# UAT

1. From a fresh boilerplate copy, run the init skill
2. Simulate "Data Analysis with Python, pixi, Quarto, pandas" answers
3. Verify:
   - `ARCHITECTURE.md` — tech stack has Python/Quarto/pandas, data flow shows notebook-to-report pipeline, key patterns include data validation patterns
   - `STANDARDS.md` — has Python-specific conventions (PEP 8, type hints, docstrings)
   - `KNOWN_PITFALLS.md` — includes Python/data pitfalls (out-of-order execution, mutating while iterating)
   - `PROJECT_STRUCTURE.md` — shows data analysis project layout (notebooks/, data/, reports/)
   - `ADR/001-project-architecture.md` — exists, covers key decisions
   - Skill file moved to `docs/plans/archive/`
4. Repeat with "Node.js Express REST API, PostgreSQL, Prisma, Vitest"
5. Verify completely different output appropriate to that archetype
