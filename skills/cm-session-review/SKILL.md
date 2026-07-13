---
name: cm-session-review
description: "Use when you say '/cm-session-review', 'cm wrap', 'wrap the marketing session', 'what did we learn', 'capture the marketing learnings from this session', 'session review for cm', at the end of a marketing session, or when a host wrap ritual invokes the CM stage. The session-wrap trigger-half of the CM compound loop: mines the session for marketing learnings and routes them through /cm-compound, runs a produced-vs-actioned effectiveness pass, and notices due success signals from prior Learning docs. Ships generic; workspace-specific surfaces come from a declared workspace config. Also invoked via close-offer from any /cm-* pipeline skill when the session settled something durable."
---

# /cm-session-review — Compound Marketing: session-wrap trigger

> **Where this sits.** This is the **trigger half** of the CM compound loop. `/cm-compound` is the write half; `cm-learnings-researcher` is the recall half; this skill is the stage that decides *when* and *what* to capture. In a workspace with a host wrap ritual, it runs as the marketing lens inside that ritual. Standalone, it runs as the whole marketing wrap.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — this skill references the contract but is not itself a pipeline stage (it does not produce a Drive artifact). It invokes `/cm-compound` for the actual write.
>
> Pipeline reference: `reference/sop-cm-pipeline.md`.

## Workspace config

The skill reads a workspace-declared config for its surfaces. Discovery: look for `.cm-session-review.json` in the workspace root. If absent, fall back to generic standalone defaults (chat output + the plugin's marketing-docs-store conventions).

**Config schema:**

```json
{
  "tracking_surface": {
    "type": "work-board|file|chat",
    "path": "path-or-identifier"
  },
  "learnings_store": "drive-folder-path-or-convention",
  "calibration_log": "path-to-writable-log-file"
}
```

- **tracking_surface** — where routed items (effectiveness deltas, due success signals) go. `work-board` = a tracked-item ledger (e.g. commitments-log.json); `file` = a named file; `chat` = inline output only.
- **learnings_store** — where Learning docs live (the `Compound Marketing` Drive folder by convention).
- **calibration_log** — writable path for user override entries (R8). JSON lines format.

When no config exists, the skill uses chat output for all routing and the plugin's Drive-folder conventions for the learnings store. Nothing errors; nothing writes to undeclared surfaces.

---

## Step 1 — Detect marketing activity (R1)

Scan the session for marketing activity. Use these signals:

**Strong signals (any one → run the full wrap):**
- Any `/cm-*` skill was invoked (cm-audit, cm-analyze, cm-plan, cm-review, cm-execute, cm-experiment, cm-compound, cm-analytics-audit)
- A CM artifact was created or modified (Audit, Analysis, Plan, Learning, Experiment doc)
- An explicit client-strategy decision was made (e.g. "we decided channel X over channel Y because Z")

**Moderate signals (collect but do not decide on alone):**
- Discussion of channels, campaigns, ROAS, CPC, conversion rates
- Client marketing strategy discussion without a settled decision
- Campaign or channel work that did not produce a CM artifact

**Decision rule:**
- ≥1 strong signal → proceed to Step 2
- Only moderate signals → ask one clarifying question: "This session touched marketing topics but didn't settle a durable decision or produce a CM artifact. Run the CM wrap anyway?" If yes, proceed; if no, emit one line ("no marketing activity to wrap") and stop.
- No signals → emit one line ("no marketing activity this session") and stop. (AE1)

---

## Step 2 — Read workspace config + calibration log (R7, R8)

1. Read `.cm-session-review.json` from the workspace root if it exists. If absent, note "using generic defaults (chat output)" and proceed.
2. If a `calibration_log` path is declared, read it. This log contains user overrides from prior wraps — read it before triaging candidates so the same recommendation is not made twice.

---

## Step 3 — Mine session for learning candidates (R2)

Scan the session for candidates matching `/cm-compound`'s four learning types:

1. **Settled client-strategy decision** — "we decided X because Y"
2. **Methodology learning** — "the right way to do Z is…"
3. **Solved marketing problem** — "the issue was X, resolved by Y"
4. **Flagged evidence gap or open success signal** — "we recommended X but never checked Y"

For each candidate, present:
- **Candidate:** one-line description
- **Type:** which of the four types
- **Recommendation:** capture (route to `/cm-compound`) | skip (not durable enough) | defer (needs more evidence)
- **Reason:** why this recommendation

If the calibration log contains an override for a similar candidate (same client + same topic), note it: "Prior override: you chose X for a similar candidate on <date>."

Present all candidates and wait for user confirmation. The user can:
- Confirm the recommendation
- Override it (e.g. "capture this even though you said skip")
- Decline all

---

## Step 4 — Route confirmed candidates through /cm-compound (R3)

For each confirmed candidate with recommendation "capture":
- Invoke `/cm-compound` with the candidate's details (client, topic, type, rationale, evidence)
- `/cm-compound` handles dedup, doc format, and index update — this skill does not reimplement them

For each override, append an entry to the calibration log (R8):
```json
{"date": "YYYY-MM-DD", "candidate": "<one-line>", "recommendation": "<capture|skip|defer>", "user_override": "<capture|skip|defer>", "reason": "<why>"}
```

---

## Step 5 — Split dual-shaped learnings (R4)

When a learning is both marketing content and a mechanism defect (e.g. a methodology gap that is also a skill-trigger bug):
- The marketing content is captured via `/cm-compound` (Step 4)
- The mechanism component is handed to the host wrap's general engine (if running as a stage) or named explicitly for the user (if standalone): "Mechanism component: <description> — route to your session-review engine's destination matrix."

---

## Step 6 — Effectiveness pass: produced-vs-actioned delta (R5)

Diff what the session produced against what was actually actioned, approved, or shipped. Use in-session evidence only.

**What to diff:**
- Artifacts produced (Plan doc, Analysis doc, campaign draft, Slack post, etc.)
- Artifacts actioned (approved, sent, shipped, implemented)

**Report the delta:**
- If produced = actioned → "no delta"
- If produced ≠ actioned → report the gap: "Produced X; actioned Y. Delta: <what changed>."

**Routing a material delta:**
- If the delta is material (the user heavily reworked the artifact before approving, or rejected it), route it as a tracked item to the workspace's tracking surface. The item should name the generating skill/prompt and the delta class: "Tracked item: <skill/prompt> produced <artifact> with delta <class> — improving the generating prompt is the resolution path."
- This skill does NOT edit the generating prompt itself — it routes the item. (AE6)

---

## Step 7 — Notice due success signals from prior Learning docs (R6)

Scan prior Learning docs (via the learnings store) for success signals whose check date is due or overdue.

**For each due signal:**
- Read the signal's check date and target
- If the check date is today or past → route it once to the workspace's tracking surface: "Due signal: <Learning doc title> — check <metric> by <date> (target: <target>). Route to <tracking surface>."
- If the signal was already routed and is still tracked → skip it (do not re-route)

**Never pull live channel data at wrap.** This step notices and routes; it does not verify. Live verification belongs to `/cm-audit` or scheduled runs. (AE4)

---

## Step 8 — Emit summary

**Stage mode (invoked by a host wrap ritual):**
Return a summary to the host wrap for its own close block:
```
## CM Session Review — Summary

**Captures made:**
- <Learning doc title> (via /cm-compound)
- ...

**Items routed:**
- <tracked item description> → <tracking surface>
- <due signal> → <tracking surface>
- ...

**Delta reported:**
- <produced-vs-actioned delta, or "no delta">

**Dual-shaped learnings split:**
- <mechanism component handed to general engine, or "none">
```

**Standalone mode:**
End with a compact close block:
```
## CM Session Review — Complete

**Captures made:** N
**Items routed:** M
**Delta reported:** yes/no

**Captures:**
- <Learning doc title> (Drive link)
- ...

**Routed items:**
- <item description> → <destination>
- ...
```

---

## Invocation contract

**Stage mode (called by a host wrap ritual):**
- Input: the host wrap passes session context (what happened, artifacts produced, decisions made, client name if applicable)
- Output: the skill returns the summary block above; the host wrap incorporates it into its own close block

**Standalone mode:**
- Input: the user invokes `/cm-session-review` or accepts a `/cm-*` close-offer (R10)
- Output: the skill runs the full wrap and emits its own close block

---

## Scope boundaries

- **General (non-marketing) learning routing** stays with the host session-review engine — this skill never grows a general destination matrix.
- **No live channel-data pulls at wrap** — data belongs to `/cm-audit` and scheduled runs.
- **Not a replacement for deliverable QA** (redteam-style review) — that remains its own wrap stage where the workspace has one.
- **Does not reimplement `/cm-compound`** — dedup, doc format, and index update stay that skill's job.

---

## Self-update directive

When a wrap surfaces a new detection heuristic, a better effectiveness-pass criterion, or a config-schema gap, update this file before finishing. The trigger half compounds: each run sharpens the detection and routing.
