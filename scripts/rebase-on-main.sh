#!/bin/bash
# Rebase worktree branch onto latest origin/main at session start.
# Prevents branch divergence when other PRs merge while a workspace is open.
# Non-fatal: conflicts print a warning and abort the rebase.

set -euo pipefail

BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Skip on main or detached HEAD
if [ -z "$BRANCH" ] || [ "$BRANCH" = "main" ]; then
  exit 0
fi

# Skip if working tree is dirty — rebase would lose uncommitted work
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
  echo "⏭ Skipping rebase — working tree has uncommitted changes"
  exit 0
fi

git fetch origin main --quiet 2>/dev/null || exit 0

BEHIND=$(git rev-list HEAD..origin/main --count 2>/dev/null || echo 0)
if [ "$BEHIND" -eq 0 ]; then
  exit 0
fi

echo "🔄 Branch is $BEHIND commit(s) behind main — rebasing..."
if git rebase origin/main --quiet 2>/dev/null; then
  echo "✅ Rebased onto main (was $BEHIND behind)"
else
  echo "⚠️  Rebase conflict — aborting rebase, branch unchanged"
  git rebase --abort 2>/dev/null || true
fi
