# CM Dogfood — Handoff path (cm-handoff) — 2026-07-21

Live-test of #12 (/cm-handoff standalone resume). The block below was emitted by
running the cm-handoff skill after the SSS recall run, simulating a paused analyst
handing off to /cm-analyze. Resumability test: does a fresh session have enough to
resume WITHOUT re-deriving state?

## Handoff — CM recall (Sprinkler Supply Store) complete

**What was done:** Ran cm-learnings-researcher recall for SSS against the merged corpus;
digest assembled, no /cm-analyze performed yet.

**Artifacts:** Recall digest (raw) — docs/audits/2026-07-21-cm-dogfood-recall.md

**Evidence:** Corpus resolves to ONE folder 13Qdtiv…; 4 SSS learning docs read clean.
SSS breakeven = 20% CoS = 5.0x ROAS; report off Primary action only (All-Conv inflated ~7x).

**Decisions made:** 2026-07-21 · recall · anchor ROAS to Primary action, never All-Conv.

**Carried-over context:** two signals in flight (tracking decay 07-03, Shop App ~day 6);
lighting rebuild settled lever but evidence gate open; Andy evaluates in CoS, weekly.

**Don't repeat:** email vs lighting (settled); CAC/budget floors; All-Conv for ROAS.

**First step:** `/cm-analyze Sprinkler Supply Store` — inherit digest; first confirm the
two in-flight signals landed.

---
Resumability verdict: PASS — First-step is an executable invocation; carried-context +
don't-repeat carry the transferable state; artifacts point at the raw digest. A fresh
session could paste this and resume /cm-analyze without re-reading this transcript.
