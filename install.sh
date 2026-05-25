#!/usr/bin/env bash
# Deploy codex-config via symlinks into ~/.codex.

set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DIR="$HOME/.codex"
BACKUP_DIR="$CODEX_DIR/backups/$(date +%Y%m%d-%H%M%S)"

echo "-> Config source : $CONFIG_DIR"
echo "-> Target        : $CODEX_DIR"
echo ""

mkdir -p "$CODEX_DIR"
mkdir -p "$CODEX_DIR/rules"
mkdir -p "$CODEX_DIR/skills"

backup_if_needed() {
  local target="$1"

  if [ -L "$target" ] || [ ! -e "$target" ]; then
    return 0
  fi

  mkdir -p "$BACKUP_DIR/$(dirname "${target#$CODEX_DIR/}")"
  mv "$target" "$BACKUP_DIR/${target#$CODEX_DIR/}"
  echo "  backup $target -> $BACKUP_DIR/${target#$CODEX_DIR/}"
}

link_file() {
  local source="$1"
  local target="$2"

  backup_if_needed "$target"
  ln -sf "$source" "$target"
  echo "  link $target"
}

link_dir() {
  local source="$1"
  local target="$2"

  backup_if_needed "$target"
  ln -sfn "$source" "$target"
  echo "  link $target"
}

chmod +x "$CONFIG_DIR/scripts/"*.sh

link_file "$CONFIG_DIR/global/AGENTS.md" "$CODEX_DIR/AGENTS.md"
link_file "$CONFIG_DIR/config.toml" "$CODEX_DIR/config.toml"
link_file "$CONFIG_DIR/rules/default.rules" "$CODEX_DIR/rules/default.rules"
link_dir "$CONFIG_DIR/scripts" "$CODEX_DIR/scripts"
link_dir "$CONFIG_DIR/assets" "$CODEX_DIR/assets"

for skill_dir in "$CONFIG_DIR/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  link_dir "$skill_dir" "$CODEX_DIR/skills/$skill_name"
done

echo ""
echo "Done. Restart Codex CLI to pick up config changes."
