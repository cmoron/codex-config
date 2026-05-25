#!/usr/bin/env bash
# Update this repository, then redeploy Codex configuration symlinks.

set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$CONFIG_DIR"
git pull --ff-only
"$CONFIG_DIR/install.sh"
