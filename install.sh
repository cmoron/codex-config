#!/usr/bin/env bash
# Deploy codex-config into Codex config directories.
#
# WSL/Linux target uses symlinks to keep edits live.
# Windows host target, when available under /mnt/c/Users/<user>/.codex, uses real
# copies because native Windows apps cannot reliably read WSL symlinks to
# /home/cyril.

set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DIR="$HOME/.codex"
WINDOWS_CODEX_DIR="${CODEX_CONFIG_WINDOWS_DIR:-}"
BACKUP_STAMP="$(date +%Y%m%d-%H%M%S)"

if [ -z "$WINDOWS_CODEX_DIR" ] && [ -d "/mnt/c/Users/$USER" ]; then
  WINDOWS_CODEX_DIR="/mnt/c/Users/$USER/.codex"
fi

echo "-> Config source  : $CONFIG_DIR"
echo "-> WSL target     : $CODEX_DIR"
if [ -n "$WINDOWS_CODEX_DIR" ]; then
  echo "-> Windows target : $WINDOWS_CODEX_DIR"
fi
echo ""

mkdir -p "$CODEX_DIR"
mkdir -p "$CODEX_DIR/rules"
mkdir -p "$CODEX_DIR/skills"

prune_managed_links() {
  local dir="$1"

  [ -d "$dir" ] || return 0

  for link in "$dir"/*; do
    [ -L "$link" ] || continue
    if [ ! -e "$link" ] || [[ "$(readlink "$link")" == "$CONFIG_DIR"* ]]; then
      rm -f "$link"
      echo "  prune $link"
    fi
  done
}

backup_if_needed() {
  local target="$1"
  local root="$2"
  local backup_dir="$root/backups/$BACKUP_STAMP"

  if [ -L "$target" ] || [ ! -e "$target" ]; then
    return 0
  fi

  mkdir -p "$backup_dir/$(dirname "${target#$root/}")"
  mv "$target" "$backup_dir/${target#$root/}"
  echo "  backup $target -> $backup_dir/${target#$root/}"
}

link_file() {
  local source="$1"
  local target="$2"

  backup_if_needed "$target" "$CODEX_DIR"
  ln -sf "$source" "$target"
  echo "  link $target"
}

link_dir() {
  local source="$1"
  local target="$2"

  backup_if_needed "$target" "$CODEX_DIR"
  ln -sfn "$source" "$target"
  echo "  link $target"
}

deploy_wsl() {
  chmod +x "$CONFIG_DIR/scripts/"*.sh

  link_file "$CONFIG_DIR/global/AGENTS.md" "$CODEX_DIR/AGENTS.md"
  link_file "$CONFIG_DIR/config.toml" "$CODEX_DIR/config.toml"
  link_file "$CONFIG_DIR/rules/default.rules" "$CODEX_DIR/rules/default.rules"
  link_dir "$CONFIG_DIR/scripts" "$CODEX_DIR/scripts"
  link_dir "$CONFIG_DIR/assets" "$CODEX_DIR/assets"

  prune_managed_links "$CODEX_DIR/skills"

  for skill_dir in "$CONFIG_DIR/skills/"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    link_dir "$skill_dir" "$CODEX_DIR/skills/$skill_name"
  done
}

copy_managed_file() {
  local source="$1"
  local target_root="$2"
  local relative_target="$3"
  local target="$target_root/$relative_target"
  local marker="$target_root/.codex-config-managed"

  mkdir -p "$(dirname "$target")"

  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    echo "$relative_target" >>"$marker.tmp"
    return 0
  fi

  if [ -e "$target" ]; then
    if grep -Fxq "$relative_target" "$marker" 2>/dev/null; then
      rm -rf "$target"
    else
      backup_if_needed "$target" "$target_root"
    fi
  fi

  cp -p "$source" "$target"
  echo "  copy $target"
  echo "$relative_target" >>"$marker.tmp"
}

copy_managed_dir() {
  local source="$1"
  local target_root="$2"
  local relative_target="$3"
  local target="$target_root/$relative_target"
  local marker="$target_root/.codex-config-managed"

  mkdir -p "$(dirname "$target")"

  if [ -e "$target" ]; then
    if grep -Fxq "$relative_target" "$marker" 2>/dev/null; then
      rm -rf "$target"
    else
      backup_if_needed "$target" "$target_root"
    fi
  fi

  cp -a "$source" "$target"
  echo "  copy $target"
  echo "$relative_target" >>"$marker.tmp"
}

prune_windows_managed_paths() {
  local target_root="$1"
  local marker="$target_root/.codex-config-managed"

  [ -f "$marker" ] || return 0

  while IFS= read -r relative_target; do
    [ -n "$relative_target" ] || continue
    if ! grep -Fxq "$relative_target" "$marker.tmp"; then
      rm -rf "$target_root/$relative_target"
      echo "  prune $target_root/$relative_target"
    fi
  done <"$marker"
}

deploy_windows_copy() {
  local target_root="$1"
  local marker="$target_root/.codex-config-managed"

  mkdir -p "$target_root/rules"
  mkdir -p "$target_root/skills"
  : >"$marker.tmp"

  copy_managed_file "$CONFIG_DIR/global/AGENTS.md" "$target_root" "AGENTS.md"
  copy_managed_file "$CONFIG_DIR/config.toml" "$target_root" "config.toml"
  copy_managed_file "$CONFIG_DIR/rules/default.rules" "$target_root" "rules/default.rules"
  copy_managed_dir "$CONFIG_DIR/scripts" "$target_root" "scripts"
  copy_managed_dir "$CONFIG_DIR/assets" "$target_root" "assets"

  for skill_dir in "$CONFIG_DIR/skills/"*/; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    copy_managed_dir "$skill_dir" "$target_root" "skills/$skill_name"
  done

  prune_windows_managed_paths "$target_root"
  sort -u "$marker.tmp" >"$marker"
  rm -f "$marker.tmp"
}

echo "-> Deploy WSL symlinks"
deploy_wsl

if [ -n "$WINDOWS_CODEX_DIR" ]; then
  echo ""
  echo "-> Deploy Windows copies"
  deploy_windows_copy "$WINDOWS_CODEX_DIR"
fi

echo ""
echo "Done. Restart Codex CLI to pick up config changes."
