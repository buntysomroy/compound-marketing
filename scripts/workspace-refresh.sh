#!/usr/bin/env bash
# workspace-refresh.sh — idempotent workspace freshness pass for compound-marketing.
#
# This repo is a plugin/skills bundle (no package.json, no build step), so the
# only freshness concern is branch drift. Adapted from the Red-Pine-Digital
# monorepo version of this script — that one also handles pnpm/npm install and
# a smart build; neither applies here, so those steps are omitted rather than
# calling scripts that don't exist in this repo.
#
# Best-effort: always exits 0 so a rebase conflict never blocks the workspace
# from opening.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔄 Checking rebase…"
bash "$SCRIPT_DIR/rebase-on-main.sh" || true

exit 0
