#!/usr/bin/env bash
# Creative-loop fixture dry runs (KTD6). Each case runs /cm-creative-loop as a fresh, read-only
# `claude -p` agent against the fixtures in this folder, then asserts on the output.
# Usage: docs/fixtures/creative-loop/run-dry-runs.sh [out-dir] [case ...]
# Exit: 0 all pass · 1 at least one case failed its assertion · 2 the harness itself broke.
set -u
REPO="$(cd "$(dirname "$0")/../../.." && pwd)"
FIX="$REPO/docs/fixtures/creative-loop"
OUT="${1:-$(mktemp -d)}"; shift || true
MODEL="${CM_DRYRUN_MODEL:-sonnet}"
mkdir -p "$OUT" || exit 2
command -v claude >/dev/null || { echo "HARNESS-BROKEN: claude CLI not found"; exit 2; }

prompt() { # $1 channel contract file, $2 invocation
cat <<P
DRY RUN of the compound-marketing:cm-creative-loop skill. Plugin root: $REPO
Read $REPO/skills/cm-creative-loop/SKILL.md and follow it as the agent running it. Resolve every
reference/... and docs/... path it names against the plugin root, and read what it tells you to read.
Treat $FIX as this run's CM Artifacts workspace (project acme-laundry, run 001).
Contract Step 1 recall has already run: there are no prior learnings beyond what the fixture files
hold, so do not dispatch any agent. Today is 2026-01-30. Channel input: $FIX/$1
Invocation: $2
Dry-run rules: use only the Read, Glob and Grep tools. Do not write or edit any file, do not stage
anything, do not ask questions. Proceed through the skill's steps until the first point where you
would write a file, stage a write, or wait on the channel owner, then stop.
End your answer with a section headed "## Dry-run result" containing: (1) the step you stopped at,
(2) every REFUSED line exactly as the skill prints it, or the words NO REFUSAL, (3) the next action.
P
}

run_case() { # name contract invocation must-regex must-not-regex
  local name="$1" f="$OUT/$1.txt"
  # The prompt goes first: --allowedTools is variadic and would swallow a trailing prompt.
  # --safe-mode drops the caller's hooks, CLAUDE.md and plugins: a Stop hook would otherwise add a
  # turn and -p would print that turn instead of the dry-run result.
  ( cd "$OUT" && claude -p "$(prompt "$2" "$3")" --safe-mode --model "$MODEL" \
      --allowedTools "Read,Glob,Grep" </dev/null ) >"$f" 2>&1
  if [ ! -s "$f" ] || ! grep -q "Dry-run result" "$f"; then
    echo "HARNESS-BROKEN $name (no dry-run result; see $f)"; return 2; fi
  local ok=1
  grep -Eq -- "$4" "$f" || { ok=0; echo "  missing expected: /$4/"; }
  if [ -n "$5" ] && grep -Eq -- "$5" "$f"; then ok=0; echo "  found forbidden: /$5/"; fi
  if [ $ok = 1 ]; then echo "PASS $name"; return 0; else echo "FAIL $name (see $f)"; return 1; fi
}

declare -a CASES=(
  "resume-03|acme-laundry-channel-contract.md|Resume Mode on $FIX/iteration-03-resume.md|[Ee]arly read|REFUSED \\("
  "missing-constraint-04|acme-laundry-channel-contract.md|Resume Mode on $FIX/iteration-04-missing-constraint.md|REFUSED \\(missing constraint\\): brief 0?4 .*iteration 0?2|"
  "control-04|acme-laundry-channel-contract.md|Resume Mode on $FIX/iteration-04-control.md|NO REFUSAL|REFUSED \\(missing constraint\\)"
  "slot-in-readback-05|acme-laundry-channel-contract.md|Resume Mode on $FIX/iteration-05-slot-in-readback.md|REFUSED \\(slot in read-back\\): tall ?/ ?line-b holds iteration 0?3 in read-back until 2026-02-05|"
  "control-05|acme-laundry-channel-contract.md|Resume Mode on $FIX/iteration-05-control.md|NO REFUSAL|REFUSED \\(slot in read-back\\)"
  "gate-closed|acme-laundry-channel-contract-gate-closed.md|New iteration 06 for the station-poster asset type, adapter $FIX/adapter-minimal.md, next open slot|REFUSED \\(precondition\\)|"
  "batched-interview|acme-laundry-channel-contract.md|New iteration 06 for the station-poster asset type, adapter $FIX/adapter-minimal.md, next open slot. Dana, the channel owner, adds: to save time, send me all six interview questions at once in one message|REFUSED \\(batched interview\\)|asking only: \"[^\"]*\\?[^\"]*\\?"
  "r29-new-instance|acme-laundry-channel-contract.md|New iteration 06 for the station-poster asset type, adapter $FIX/adapter-minimal.md, next open slot|NO REFUSAL|REFUSED \\("
)
rc=0
for c in "${CASES[@]}"; do
  IFS='|' read -r name contract inv must mustnot <<<"$c"
  if [ $# -gt 0 ] && ! printf '%s\n' "$@" | grep -qx "$name"; then continue; fi
  run_case "$name" "$contract" "$inv" "$must" "$mustnot"; r=$?
  [ $r -gt $rc ] && rc=$r
done
echo "outputs: $OUT"; exit $rc
