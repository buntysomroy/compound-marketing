# CM Dogfood — Recall path (cm-learnings-researcher) — 2026-07-21

Raw output of the real consume-path run against the just-merged `Compound Marketing`
Drive corpus (post #5 fix). Target client: **Sprinkler Supply Store** (richest history).
Purpose: prove the recall path resolves to the single merged folder and returns real
prior learnings (dogfood consume-side ROI + #5 fix verification).

## Folder resolution result

- **Folders matched:** exactly **1** (`fullText contains 'Compound Marketing'` + folder mimeType).
- **ID used:** `13QdtivfG1hjaGVWxayrAezlbaKwOuuwf` — matches the expected canonical ID.
- **Single-folder guarantee:** **HELD.** The 2026-07-21 de-dup is confirmed live — no
  duplicate-folder regression; the new duplicate-folder guard did not need to fire.

## Read failures

**None.** All 4 Sprinkler Supply Store `— Learning —` docs (including the perpetual
Decisions doc) returned full content via `shanti_read_drive_document`. Genuine complete
recall, not a tool-unavailable "couldn't read." (Corpus also holds 5 non-Learning SSS
artifacts — Solution / Experiment / Plan / Analysis — source docs, not distilled learnings.)

## Recall digest — what a /cm-analyze run inherits

| Date | Topic | The decision/finding | What still constrains THIS analyze run | Doc |
|------|-------|----------------------|----------------------------------------|-----|
| perpetual | Decisions log (settled calls) | 8 appended decisions — Shop App launched at defaults as signal test; CAC/budget floors | SETTLED — don't re-open: signal-test framing, $22 CAC / $45 New-floor / $55.07 budget floor | Learning — Decisions — SSS |
| 2026-06-29 | Channel prioritization | Lighting seasonal rebuild is THE single lever (not email, not more Google Ads) | Don't re-litigate email vs lighting. OPEN GATE: last-season lighting ROAS never pulled — can't greenlight lighting until a /cm-audit closes it | Learning — Channel Prioritization — SSS |
| 2026-07-03 | Conversion tracking | Large All-Conv >> Conv gap was redundant double-counting, NOT lost tracking | Judge ROAS off single Primary action (`ED | Purchase (Custom Pixel)`), NEVER All-Conv. Duplicate GTM tag paused 07-03 — verify it decayed | Learning — Conversion Tracking Double-Count Audit — SSS |
| 2026-07-14 | Shop App launch | First Shop App campaign launched at defaults as signal-gathering, sub-breakeven, disclosed | Shop App is target-CPA / pay-on-conversion — no spend-cap; don't port Google/Meta budget model. Success = clean signal, NOT profitability | Learning — Shop App Campaign Launch — SSS |

### Carry-forward — honor, don't re-derive

1. **Anchor all ROAS/CoS math to breakeven + the clean Primary action.** SSS breakeven = **20% CoS = 5.0x ROAS**. Report ROAS off `ED | Purchase (Custom Pixel)` only — All-Conversions was structurally inflated ~7x by two redundant Secondary actions (paused 2026-07-03).
2. **Two success signals still in flight — check before analyzing:** (a) conversion-tracking fix (07-03) — redundant `ED | Purchase (GTM)` should have decayed to "no recent conversions"; confirm it did. (b) Shop App campaign (~07-15) — evaluate day 7 (tracking/pacing) and day 14–21 (close); as of 07-21 it's ~day 6, still in the signal window → directional only.
3. **Lighting seasonal rebuild is the settled lever but has an OPEN EVIDENCE GATE.** Don't re-open the channel choice; but no one pulled last season's lighting ROAS/margins/search volume — that /cm-audit gate is open; don't greenlight the build until it closes. Watch lighting-keyword impression share climbing from 0 through August.
4. **Don't trust a client's verbal estimate of a data number — pull the dashboard.** Frankie's "handful of edge-case parts" was really 68 Ineligible + 5 Prohibited of ~4,275 (~10x undercount).
5. **Client-comms precedent (Andy):** evaluates in CoS terms, not a spend-pusher; lead with a shortfall number, don't bury it. Cadence is **weekly**, not daily.

**Still open:** exact SKU list for the 68+5 flagged Shop App products; whether a Shopify ad credit exists; the lighting-performance data pull.

---
Source: cm-learnings-researcher subagent (agentId a2e10e07df765e21e), run 2026-07-21 · docs-store: Shanti Drive MCP
