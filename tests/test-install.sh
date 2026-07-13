#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/bin" "$TMP/home"
printf '%s\n' '#!/usr/bin/env bash' 'printf "%s\\n" "$*" >>"$CODEX_TEST_LOG"' >"$TMP/bin/codex"
chmod +x "$TMP/bin/codex"

export CODEX_TEST_LOG="$TMP/codex.log"
export HOME="$TMP/home"
export PATH="$TMP/bin:$PATH"

before=$(shasum -a 256 "$ROOT/config.toml" | cut -d' ' -f1)
"$ROOT/install.sh" >/dev/null
[ ! -L "$HOME/.codex/config.toml" ]
[ ! -L "$HOME/.codex/hooks.json" ]
cmp -s "$ROOT/config.toml" "$HOME/.codex/config.toml"
cmp -s "$ROOT/hooks.json" "$HOME/.codex/hooks.json"

grep -q '^model = "gpt-5.6-sol"$' "$HOME/.codex/config.toml"
grep -q '^model_reasoning_effort = "medium"$' "$HOME/.codex/config.toml"
grep -q '^\[profiles.terra\]$' "$HOME/.codex/config.toml"
grep -q '^\[profiles.luna\]$' "$HOME/.codex/config.toml"
grep -q '^\[profiles.sol-high\]$' "$HOME/.codex/config.toml"
grep -q '^multi_agent = false$' "$HOME/.codex/config.toml"
grep -q '^multi_agent_v2 = false$' "$HOME/.codex/config.toml"
grep -q '^fast_mode = false$' "$HOME/.codex/config.toml"

printf '\n[hooks.state]\n[hooks.state."test"]\ntrusted_hash = "sha256:test"\n' >>"$HOME/.codex/config.toml"
"$ROOT/install.sh" >/dev/null
after=$(shasum -a 256 "$ROOT/config.toml" | cut -d' ' -f1)

[ "$before" = "$after" ]
grep -q '^\[hooks.state\."test"\]$' "$HOME/.codex/config.toml"
[ "$(readlink "$HOME/.agents/skills/api-design")" = "$ROOT/skills/api-design/" ]
[ "$(readlink "$HOME/.codex/agents")" = "$ROOT/agents" ]
grep -q '^plugin marketplace upgrade ' "$CODEX_TEST_LOG"
grep -q '^plugin add ' "$CODEX_TEST_LOG"

echo "install: ok"
