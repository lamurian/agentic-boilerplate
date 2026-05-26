#!/bin/sh
#
# install.sh — agentic-boilerplate installer for macOS/Linux
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lamurian/agentic-boilerplate/master/install.sh | sh
#
# Downloads every file individually from the master branch so you can
# inspect exactly what runs. For .md files, if the target already exists
# the installer does a YAML-aware prepend merge (template front matter
# wins, existing body appended after a --- separator).
#
set -eu

BASE_URL="https://raw.githubusercontent.com/lamurian/agentic-boilerplate/master"

# Literal newline (POSIX-compatible)
# shellcheck disable=SC2034 # used indirectly inside ${...%$NL}
NL='
'

# ── Portable temp directory ──────────────────────────────────────────

_TMPDIR=""
if command -v mktemp >/dev/null 2>&1; then
  _TMPDIR=$(mktemp -d 2>/dev/null || mktemp 2>/dev/null) || _TMPDIR=""
fi
if [ -z "$_TMPDIR" ]; then
  _TMPDIR="${TMPDIR:-/tmp}/agentic-boilerplate.$$"
  mkdir -p "$_TMPDIR"
fi

trap 'rm -rf "$_TMPDIR"' EXIT HUP INT TERM

# ── Helpers ──────────────────────────────────────────────────────────

# Parse a file into YAML front matter and body.
# Writes two files into <outdir>:
#   <outdir>/fm    — front matter (empty string if none)
#   <outdir>/body  — body content
parse_frontmatter() {
  _pf_file="$1"
  _pf_outdir="$2"
  _pf_state="outside"
  _pf_fm=""
  _pf_body=""
  while IFS= read -r _pf_line; do
    case "$_pf_state" in
      outside)
        if [ "$_pf_line" = "---" ]; then
          _pf_state="fm"
        else
          _pf_body="$_pf_line"
          _pf_state="body"
        fi
        ;;
      fm)
        if [ "$_pf_line" = "---" ]; then
          _pf_state="body"
        else
          _pf_fm="$_pf_fm$_pf_line$NL"
        fi
        ;;
      body)
        _pf_body="$_pf_body$NL$_pf_line"
        ;;
    esac
  done < "$_pf_file"
  # Strip trailing newline from body if present
  _pf_body="${_pf_body%"$NL"}"
  # If we never transitioned out of "outside", the file was empty
  [ "$_pf_state" = "outside" ] && _pf_body=""
  # Write output files
  printf '%s\n' "${_pf_fm%"$NL"}" > "$_pf_outdir/fm"
  printf '%s\n' "$_pf_body" > "$_pf_outdir/body"
}

# Install a .md file — download and YAML-merge when target exists.
install_md() {
  _im_path="$1"
  _im_tmpfile="$_TMPDIR/md"
  mkdir -p "$(dirname "$_im_path")"
  if ! curl -fsSL "$BASE_URL/$_im_path" -o "$_im_tmpfile"; then
    rm -f "$_im_tmpfile"
    printf '  x Failed to download %s\n' "$_im_path" >&2
    return 1
  fi
  if [ -e "$_im_path" ]; then
    parse_frontmatter "$_im_tmpfile" "$_TMPDIR"
    _im_t_fm=$(cat "$_TMPDIR/fm")
    _im_t_body=$(cat "$_TMPDIR/body")
    parse_frontmatter "$_im_path" "$_TMPDIR"
    _im_e_body=$(cat "$_TMPDIR/body")
    {
      if [ -n "$_im_t_fm" ]; then
        printf '%s\n' "---"
        printf '%s\n' "$_im_t_fm"
        printf '%s\n' "---"
        printf '%s\n' ""
      fi
      [ -n "$_im_t_body" ] && printf '%s\n' "$_im_t_body"
      printf '%s\n' ""
      printf '%s\n' "---"
      printf '%s\n' ""
      printf '%s\n' "$_im_e_body"
    } > "$_im_path"
    printf '  ~ Merged %s\n' "$_im_path"
  else
    mv "$_im_tmpfile" "$_im_path"
    printf '  + Created %s\n' "$_im_path"
  fi
}

# Install a non-.md file (skip when target exists).
install_other() {
  _io_path="$1"
  if [ -e "$_io_path" ]; then
    printf '  - Skipped %s (exists)\n' "$_io_path"
    return 0
  fi
  mkdir -p "$(dirname "$_io_path")"
  if curl -fsSL "$BASE_URL/$_io_path" -o "$_io_path"; then
    printf '  + Created %s\n' "$_io_path"
  else
    rm -f "$_io_path"
    printf '  x Failed to download %s\n' "$_io_path" >&2
    return 1
  fi
}

# Ensure a directory exists with a .gitkeep placeholder.
ensure_dir() {
  _ed_dir="$1"
  mkdir -p "$_ed_dir"
  if [ ! -e "$_ed_dir/.gitkeep" ]; then
    touch "$_ed_dir/.gitkeep"
    printf '  + Created %s/\n' "$_ed_dir"
  else
    printf '  - Skipped %s/ (exists)\n' "$_ed_dir"
  fi
}

# ── Installation ─────────────────────────────────────────────────────

printf 'agentic-boilerplate — installing into %s\n' "$(pwd)"
printf '\n'

# .md files (YAML-aware prepend merge)
for f in \
  AGENTS.md \
  .agents/skills/init/SKILL.md \
  .agents/skills/brainstorm/SKILL.md \
  .agents/skills/concise/SKILL.md \
  .agents/skills/implement/SKILL.md \
  .agents/skills/init/references/tradeoffs.md \
  .agents/skills/init/references/templates-adr.md \
  .agents/skills/init/references/templates-docs.md \
  docs/templates/000-plan.md \
  docs/templates/ADR.md \
  docs/templates/AGENTS.md \
  docs/templates/ARCHITECTURE.md \
  docs/templates/PROJECT_STRUCTURE.md \
  docs/templates/TODO.md; do
  install_md "$f"
done

# Non-md files (skip when target exists)
install_other Makefile
install_other .agents/skills/init/scripts/detect.sh

# .gitignore — merge missing entries from template
if [ -e .gitignore ]; then
  _gi_template="$_TMPDIR/gitignore"
  curl -fsSL "$BASE_URL/.gitignore" -o "$_gi_template"
  while IFS= read -r _gi_line || [ -n "$_gi_line" ]; do
    # Skip empty lines and comments, check if line already present
    case "$_gi_line" in
      "" | "#"*) continue ;;
    esac
    if ! grep -qxF "$_gi_line" .gitignore 2>/dev/null; then
      # First missing entry gets a header
      if [ -z "${GIMERGED:-}" ]; then
        printf '\n' >> .gitignore
        printf '# agentic-boilerplate\n' >> .gitignore
        GIMERGED=1
      fi
      printf '%s\n' "$_gi_line" >> .gitignore
    fi
  done < "$_gi_template"
  if [ -n "${GIMERGED:-}" ]; then
    printf '  ~ Merged .gitignore\n'
  else
    printf '  - Skipped .gitignore (up to date)\n'
  fi
  unset GIMERGED
else
  curl -fsSL "$BASE_URL/.gitignore" -o .gitignore
  printf '  + Created .gitignore\n'
fi

# Directory structure
ensure_dir docs/agents
ensure_dir docs/ADR
ensure_dir docs/plans
ensure_dir docs/plans/.archive
ensure_dir docs/UAT
ensure_dir docs/UAT/.archive
ensure_dir docs/wiki
ensure_dir src

printf '\n'
printf 'Done.\n'
printf '\n'
printf 'Next step:\n'
printf '  make setup\n'
printf '    Creates symlinks for AI-tool compatibility\n'
printf '    (.cursorrules, .windsurfrules, CLAUDE.md -> AGENTS.md)\n'
printf '\n'
printf 'Then open the project with your AI agent.\n'
printf 'If docs/agents/ is empty, the init skill will prompt you\n'
printf 'to configure project-specific docs.\n'
