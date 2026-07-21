# CM Compound-Loop Dogfood — Verdict — 2026-07-21

**System dogfooded:** the CM compound loop — `cm-compound` (write) + `cm-learnings-researcher`
(recall) + `cm-handoff` — run against the real, just-merged `Compound Marketing` Drive corpus
(post #5 fix). Bounded to the loop; a full audit→execute client pipeline was explicitly NOT run
(that needs live ad data + client-facing deliverables — fulfillment, not a dogfood).

## Verdict: KEEP (with one REFINE fix applied)

The recall path delivers real, non-duplicated value: a fresh `/cm-analyze` genuinely inherits
provenance-tagged settled decisions + open evidence gates instead of a blank page. The consume
side works, the handoff is resumable, and nothing here is covered by another layer (code-side
CLAUDE.md/memory hold engineering rules, not marketing-corpus recall). Not a hollow KEEP —
proven by transcripts below, not asserted.

## What the run proved (real data, both directions)

| Check | Result | Evidence |
|-------|--------|----------|
| Recall consume path (SSS) | PASS | 4 learning docs read clean; rich digest with carry-forward + open gates. `2026-07-21-cm-dogfood-recall.md` |
| #5 fix live | PASS | Folder resolves to exactly ONE (`13Qdtiv…`); single-folder guarantee held; guard didn't need to fire |
| Handoff resumability (#12) | PASS | Fresh session given ONLY the block → RESUMABLE; inherited settled facts, didn't re-derive; only "gap" is the next stage's own work |
| Adversarial recall (no-corpus client) | PASS | "Blue Harbor Dental" → clean "genuinely none"; no hallucination, no borrowed learnings, no false tool-failure caveat |

## Findings

- **F2 — REFINE, FIXED (real latent scaling bug).** The recall recipe relied on
  `list_drive_files(folderId, query=…)` server-side name-filtering that is **not honored** by the
  Shanti Drive MCP, and did not paginate (default ~50/page). At corpus scale (>50 docs) a client's
  learnings on page 2+ would be **silently missed** — same silent-partial-recall class as #5.
  Fixed in `agents/cm-learnings-researcher.md`: list the FULL folder, paginate via `pageToken`,
  filter titles client-side (case-insensitive). Applied 2026-07-21.

- **F1 — REFINE candidate, NOT fixed (cross-cutting convention).** `cm-handoff/SKILL.md` says load
  `reference/protocol-cm-stage-contract.md`, but from the skill's own base dir that path doesn't
  resolve — the shared `reference/` sits at the plugin root, two levels up. A cold session following
  the path literally hits a not-found (observed this run). ALL CM skills use bare `reference/…` paths,
  so this is a plugin-wide path-convention question (fix all or document the resolve-from-root
  convention), not a one-file bug — flagged, not silently patched.

## Not tested (be honest)

- **#13 — stage-contract Step 5 decision-logging FAILURE path.** This run exercised the happy path
  only. The failure path (Drive tools unreachable → surface loudly + carry `PENDING DECISION LOG`)
  was NOT simulated. #13 remains open — it needs a forced Drive-tool-failure scenario.

## Ticket dispositions

- **#5** — FIXED (data merged + fail-loud guard in 3 files). Verified live this run.
- **#12** — PROVEN resumable; safe to close on this evidence.
- **#13** — still open; not exercised here.

---
Source: dogfood skill Step 4/6 · docs/audits/2026-07-21-cm-dogfood-{recall,handoff}.md
