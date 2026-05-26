#!/usr/bin/env bash
#
# install.sh — agentic-boilerplate installer for macOS/Linux
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/lamurian/agentic-boilerplate/master/install.sh | bash
#
# Downloads every file individually from the master branch so you can
# inspect exactly what runs. For .md files, if the target already exists
# the installer does a YAML-aware prepend merge (template front matter
# wins, existing body appended after a --- separator).
#
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/lamurian/agentic-boilerplate/master"

# ── Helpers ──────────────────────────────────────────────────────────

# Parse a file into YAML front matter and body.
# Usage: parse_frontmatter FILE fm_var body_var
# Sets fm_var to "" when the file has no front matter.
parse_frontmatter() {
  local file="$1" fm_var="$2" body_var="$3"
  local state="outside" fm="" body=""
  while IFS= read -r line; do
    case "$state" in
      outside)
        if [ "$line" = "---" ]; then
          state="fm"
        else
          body="$line"
          state="body"
        fi
        ;;
      fm)
        if [ "$line" = "---" ]; then
          state="body"
        else
          fm="$fm$line"$'\n'
        fi
        ;;
      body)
        body="$body"$'\n'"$line"
        ;;
    esac
  done < "$file"
  # Strip trailing newline from body if present
  body="${body%"$'\n'"}"
  # If we never transitioned out of "outside", the file was empty
  [ "$state" = "outside" ] && body=""
  # If fm was set but body was empty after front matter, body stays ""
  printf -v "$fm_var" "%s" "${fm%$'\n'}"
  printf -v "$body_var" "%s" "$body"
}

# Install a .md file — download and YAML-merge when target exists.
install_md() {
  local path="$1" tmpfile
  tmpfile=$(mktemp) || return 1
  mkdir -p "$(dirname "$path")"
  if ! curl -fsSL "$BASE_URL/$path" -o "$tmpfile"; then
    rm -f "$tmpfile"
    echo "  x Failed to download $path" >&2
    return 1
  fi
  if [ -e "$path" ]; then
    # shellcheck disable=SC2034 # e_fm parsed but unused (template front matter wins)
    local t_fm t_body e_fm e_body
    parse_frontmatter "$tmpfile" t_fm t_body
    parse_frontmatter "$path" e_fm e_body
    {
      if [ -n "$t_fm" ]; then
        echo "---"
        echo "$t_fm"
        echo "---"
        echo ""
      fi
      [ -n "$t_body" ] && echo "$t_body"
      echo ""
      echo "---"
      echo ""
      echo "$e_body"
    } > "$path"
    echo "  ~ Merged $path"
  else
    mv "$tmpfile" "$path"
    echo "  + Created $path"
  fi
  rm -f "$tmpfile"
}

# Install a non-.md file (skip when target exists).
install_other() {
  local path="$1"
  if [ -e "$path" ]; then
    echo "  - Skipped $path (exists)"
    return 0
  fi
  mkdir -p "$(dirname "$path")"
  if curl -fsSL "$BASE_URL/$path" -o "$path"; then
    echo "  + Created $path"
  else
    rm -f "$path"
    echo "  x Failed to download $path" >&2
    return 1
  fi
}

# Ensure a directory exists with a .gitkeep placeholder.
ensure_dir() {
  local dir="$1"
  mkdir -p "$dir"
  if [ ! -e "$dir/.gitkeep" ]; then
    touch "$dir/.gitkeep"
    echo "  + Created $dir/"
  else
    echo "  - Skipped $dir/ (exists)"
  fi
}

# ── Installation ─────────────────────────────────────────────────────

echo "agentic-boilerplate — installing into $(pwd)"
echo ""

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
  docs/templates/project_structure.md \
  docs/templates/todo.md; do
  install_md "$f"
done

# Non-md files (skip when target exists)
install_other Makefile
install_other .agents/skills/init/scripts/detect.sh

# .gitignore — merge missing entries from template
if [ -e .gitignore ]; then
  local_ifs="$IFS"
  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments, check if line already present
    case "$line" in
      "" | "#"*) continue ;;
    esac
    if ! grep -qxF "$line" .gitignore 2>/dev/null; then
      # First missing entry gets a header
      if [ -z "${GIMERGED:-}" ]; then
        echo "" >> .gitignore
        echo "# agentic-boilerplate" >> .gitignore
        GIMERGED=1
      fi
      echo "$line" >> .gitignore
    fi
  done < <(curl -fsSL "$BASE_URL/.gitignore")
  IFS="$local_ifs"
  if [ -n "${GIMERGED:-}" ]; then
    echo "  ~ Merged .gitignore"
  else
    echo "  - Skipped .gitignore (up to date)"
  fi
  unset GIMERGED
else
  curl -fsSL "$BASE_URL/.gitignore" -o .gitignore
  echo "  + Created .gitignore"
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

echo ""
echo "Done."
echo ""
echo "Next step:"
echo "  make setup"
echo "    Creates symlinks for AI-tool compatibility"
echo "    (.cursorrules, .windsurfrules, CLAUDE.md -> AGENTS.md)"
echo ""
echo "Then open the project with your AI agent."
echo "If docs/agents/ is empty, the init skill will prompt you"
echo "to configure project-specific docs."
