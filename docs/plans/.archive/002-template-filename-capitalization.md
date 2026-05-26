---
title: Template Filename Capitalization
description: Rename project_structure.md and todo.md to uppercase; fix all references
date: 2026-05-26
---

# Overview

`docs/templates/project_structure.md` and `docs/templates/todo.md` use
lowercase names while all other template files (`ADR.md`, `AGENTS.md`,
`ARCHITECTURE.md`) use uppercase. This inconsistency causes 404 errors
in the installers because GitHub raw URLs are case-sensitive.

# Goals

- Rename `project_structure.md` → `PROJECT_STRUCTURE.md`
- Rename `todo.md` → `TODO.md`
- Fix all references in `install.sh`, `install.ps1`, `docs/templates/AGENTS.md`,
  and `.agents/skills/implement/SKILL.md`
- Include `architecture.md` reference fix missed in prior commit

# Implementation Steps

- [ ] 1. `git mv` rename both files (two-step on macOS for case-only rename)
- [ ] 2. Update `install.sh` file list (lines 162-163)
- [ ] 3. Update `install.ps1` file list (lines 114-115)
- [ ] 4. Update `docs/templates/AGENTS.md` references (lines 20, 22, 23, 36)
- [ ] 5. Update `.agents/skills/implement/SKILL.md` reference (line 17)
- [ ] 6. Stage and commit

# Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| macOS case-insensitive FS blocks rename | High | Low | Two-step `git mv` via temp name |
| Missed reference in archived files | Low | Low | Archive dirs excluded by `.gitignore` |

# UAT

1. `git ls-files docs/templates/` shows uppercase names
2. `grep -r project_structure.md` returns no matches outside `.archive/`
3. `grep -r todo.md` returns no matches outside `.archive/`
4. `install.sh` passes `shellcheck --shell=sh`
