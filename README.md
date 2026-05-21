# AI-Assisted Development Boilerplate

A file-based, agent-agnostic template that helps AI coding tools (OpenCode, Claude Code, GitHub Codex, Cursor, Cline, Windsurf, etc.) produce consistent, correct code with fewer hallucinations.

## How It Works

```
AGENTS.md  ──────►  READ: docs/agents/STANDARDS.md         (conventions)
(entry point)        READ: docs/agents/PROJECT_STRUCTURE.md (file map)
                     READ: docs/agents/ARCHITECTURE.md      (system design)
                     READ: docs/agents/KNOWN_PITFALLS.md    (anti-patterns)
```

1. **Every AI agent reads `AGENTS.md`** automatically — it's the universal format supported by 20+ tools.
2. **AGENTS.md tells the agent which docs to read** via explicit `READ: docs/agents/...` directives.
3. **Agent docs are ≤100 lines each** — token-optimized for LLM context windows.
4. **`docs/ADR/` records architectural decisions** — prevents contradictory approaches across sessions.

## Quick Start

1. Copy this structure into your project root.
2. Edit `AGENTS.md` — fill in your project name and commands.
3. Edit `docs/agents/*.md` — fill in your actual conventions, structure, and decisions.
4. Run `make setup` to create symlinks for tool compatibility.
5. Commit everything and start coding with AI assistance.

## File Reference

| File | Audience | Purpose | Size Limit |
|------|----------|---------|-----------|
| `AGENTS.md` | Agent | Entry point, commands, hallucination prevention rules | ~80 lines |
| `docs/agents/STANDARDS.md` | Agent | Naming, file org, error handling, testing conventions | ≤100 lines |
| `docs/agents/PROJECT_STRUCTURE.md` | Agent | Directory tree and purpose of each path | ≤60 lines |
| `docs/agents/ARCHITECTURE.md` | Agent | Tech stack, data flow, pattern index, ADR index | ≤80 lines |
| `docs/agents/KNOWN_PITFALLS.md` | Agent | Anti-pattern catalog with corrections | ≤60 lines |
| `docs/ADR/NNN-title.md` | Both | Individual architecture decision records | Open |
| `docs/wiki/` | Human | Design docs, runbooks, guides | Open |
| `Makefile` | Both | `make setup` creates symlinks for cross-tool compatibility | - |

## Tool Compatibility

| Tool | How It Reads AGENTS.md |
|------|----------------------|
| **OpenCode** | Native — reads `AGENTS.md` automatically |
| **Claude Code** | Via symlink (`make setup` creates `CLAUDE.md → AGENTS.md`) |
| **GitHub Codex** | Native — reads `AGENTS.md` automatically |
| **Cursor** | Native — reads `AGENTS.md`; `make setup` adds `.cursorrules` symlink |
| **Cline** | Native — reads `AGENTS.md` automatically |
| **Windsurf** | Native — reads `AGENTS.md`; `make setup` adds `.windsurfrules` symlink |
| **Aider** | Via config: add `read: AGENTS.md` to `.aider.conf.yml` |
| **Gemini CLI** | Via config: add `"context": {"fileName": "AGENTS.md"}` to `.gemini/settings.json` |
| **Zed** | Native — reads `AGENTS.md` from project root |

## Hallucination Reduction Design

This boilerplate targets the four main sources of LLM coding hallucinations:

| Hallucination Source | Countermeasure |
|---------------------|---------------|
| **Wrong file paths** | `PROJECT_STRUCTURE.md` provides ground-truth directory map |
| **Invented APIs/types** | "CHECK actual source — do NOT guess" in AGENTS.md |
| **Repeated mistakes** | `KNOWN_PITFALLS.md` documents errors with correct alternatives |
| **Contradictory approaches** | ADRs in `docs/ADR/` record every architectural decision |

## ADR Workflow

1. **Before** making architecture changes: check `docs/agents/ARCHITECTURE.md` for existing decisions.
2. **When** proposing something new: create `docs/ADR/001-title.md` (3-digit enum, <5 word title).
3. **After** creating ADR: add a `@docs/ADR/001-title.md` reference to `ARCHITECTURE.md`.
4. **To deprecate** an old ADR: set its status to `deprecated` and reference the superseding ADR.

## Guiding Principles

- **Single source of truth**: `AGENTS.md` is the entry point; all other instruction files are referenced from it.
- **Zero duplication**: No CLAUDE.md, .cursorrules, etc. — only symlinks pointing to `AGENTS.md`.
- **Token economy**: Agent docs are hard-capped at ≤100 lines to respect context windows.
- **Concrete over vague**: Every rule is a verifiable statement, not a suggestion.
- **Both human and AI**: `docs/ADR/` and `docs/wiki/` serve different audiences appropriately.
