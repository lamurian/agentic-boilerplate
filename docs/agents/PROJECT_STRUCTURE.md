# Project Structure

```
.
├── AGENTS.md                 AI instructions — entry point for all agents
├── Makefile                  Symlink setup for tool compatibility
│
├── docs/
│   ├── ADR/                  Architecture Decision Records (shared)
│   ├── agents/               AI agent instructions (≤100 lines each)
│   ├── plans/                Feature/change plans (lifecycle-managed)
│   ├── templates/            Document templates for agentic workflows
│   ├── UAT/                  User acceptance test procedures
│   └── wiki/                 Human-only documentation (guides, runbooks)
│
├── scripts/                  Build and CI helper scripts
├── src/                      Application source code
│   └── (nested AGENTS.md allowed)
├── tests/                    Integration and e2e tests
├── config/                   Environment and app configuration
└── infra/                    Infrastructure as code (Docker, Terraform)
```

## Directory Purpose

| Path | Purpose | Who |
|------|---------|-----|
| `AGENTS.md` | Project-level AI instructions — read first | Agent |
| `docs/ADR/` | Architecture Decision Records | Both |
| `docs/agents/` | Agent-only standards, structure, architecture, pitfalls | Agent |
| `docs/plans/` | Feature/change plans with lifecycle tracking | Agent |
| `docs/templates/` | Reusable document templates (AGENTS.md, ADR, plans, etc.) | Agent |
| `docs/UAT/` | User acceptance test procedures | Agent |
| `docs/wiki/` | Human design docs and runbooks | Human |
| `scripts/` | Dev, build, deploy helper scripts | Both |
| `src/` | Production application code | Both |
| `tests/` | Test suites mirroring src/ structure | Both |
| `config/` | Config files (env, yaml, json) | Both |
| `infra/` | Infrastructure definitions | Both |

## File Patterns
- Source: `src/<domain>/<module>.<ext>`
- Tests: `src/<domain>/<module>.test.<ext>`
- Config: `config/<env>.<ext>`
- Scripts: `scripts/<action>.<ext>`
