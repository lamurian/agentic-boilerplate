---
title: POSIX-Compliant install.sh
description: Rewrite install.sh to use only POSIX shell features with pragmatic fallbacks
date: 2026-05-26
---

# Overview

`install.sh` currently uses bash-specific features (`local`, `set -o pipefail`,
`printf -v`, `$'\n'`, process substitution, `mktemp`) that prevent it from
running under a strict POSIX `/bin/sh`. This plan replaces every bashism with
a POSIX-compatible equivalent while preserving all behavior.

Approach: Pragmatic POSIX — shell language strictly POSIX (`set -eu`,
no `local`, no `$'\n'`, etc.), external tools with POSIX-compatible fallbacks
(e.g., try `mktemp -d` first, fall back to `$$`).

# Goals

- Shebang changes from `bash` to `sh`
- All shell language features are POSIX.1-2008/2017 compliant
- External utilities (`curl`, `mkdir`, `mv`) preserved as-is
- `mktemp` used when available, with a POSIX fallback
- Zero `shellcheck --shell=sh` warnings
- All existing behavior preserved (merge, skip, create)

# Implementation Steps

- [ ] 1. Shebang + set + newline variable — `#!/bin/sh`, `set -eu`,
      `NL` variable with literal newline
- [ ] 2. Portable temp directory — try `mktemp -d`, fallback to
      `${TMPDIR:-/tmp}/agentic-boilerplate.$$`, add cleanup `trap`
- [ ] 3. Refactor `parse_frontmatter` — replace `local` with `_pf_` prefix,
      replace `printf -v` with writing to temp files, replace `$'\n'` with `$NL`
- [ ] 4. Refactor `install_md` — replace `local` with `_im_` prefix,
      replace `mktemp` with `$_TMPDIR/md`, replace unsafe `echo` with `printf '%s\n'`
- [ ] 5. Refactor `install_other` and `ensure_dir` — replace `local`
      with `_io_`/`_ed_` prefixes
- [ ] 6. Replace process substitution in `.gitignore` — download to
      `$_TMPDIR/gitignore`, redirect from file
- [ ] 7. `shellcheck --shell=sh install.sh` — zero warnings

# Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| `mktemp -d` differs on macOS vs Linux | Medium | Low | Handle both `-d` and bare `mktemp` |
| Literal newline in `NL` breaks on some shell | Very Low | Medium | Standard POSIX idiom, verified by shellcheck |
| Behavior drift between old and new script | Medium | High | Read diff carefully, test manually |
| `[ -e` vs `[ -f` behavioral mismatch | Low | Low | Keep `-e` to match original semantics |

# UAT

1. `shellcheck --shell=sh install.sh` passes with zero warnings
2. `sh install.sh` on macOS — creates all files correctly
3. `sh install.sh` on Linux (dash) — creates all files correctly
4. Rerun on existing installation — `.md` YAML merge works correctly
5. Rerun on existing installation — non-md files are skipped
6. `.gitignore` merge works on fresh and existing installations
7. Temp directory is cleaned up after exit and on SIGINT/SIGHUP
