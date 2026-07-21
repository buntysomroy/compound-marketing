---
name: cm-compound
description: "Use when you say '/cm-compound', 'capture this marketing learning', 'save the CM decision', 'document why we chose X channel', 'compound this learning', 'write a learning doc for <client>', or after a /cm-plan / strategic-marketing decision worth remembering. Capture a solved marketing problem, a durable client-strategy decision, or a Compound Marketing methodology learning as a user-friendly Google Doc in a flat `Compound Marketing` Drive folder — so a future /cm-* run recalls it (via cm-learnings-researcher) instead of re-deriving it. The marketing mirror of /ce-compound (which writes engineering solutions-*.md to the repo); this writes to Drive because marketing docs belong where the client + team can read them."
---

# /cm-compound — Compound Marketing: capture a learning

> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the five contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging) are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> Pipeline reference: `reference/sop-cm-pipeline.md`.

The **write half** of the CM compound loop. `cm-learnings-researcher` is the recall half. Together they mirror the engineering loop (`/ce-compound` writes `protocols-and-sops/solutions-*.md`; `ce-learnings-researcher` recalls them) — except marketing learnings are written as **user-friendly Google Docs in Drive**, not repo markdown, because the client and team read them.

## When a learning qualifies

Capture when the session produced one of:

- A **settled client-strategy decision** with rationale ("lighting rebuild is the seasonal lever, not email — because Google is at its ceiling and lighting drives Sept→spring").
- A **methodology learning** about how to do the marketing work ("strategic-question replies need /cm-plan single-problem — free-handing misses the higher-leverage lever + the success signal").
- A **solved marketing problem** ("the Meta access block was an ownership issue, resolved by X").
- A **flagged evidence gap or open success signal** worth carrying forward ("recommended lighting but never pulled last season's lighting ROAS — gate still open").

**Bar:** would the next `/cm-*` run for this client be better if it inherited this? If yes, capture it. Size of the arc is irrelevant — a one-line "we decided X because Y" still qualifies.

## Step 1 — Dedup first

Search the flat `Compound Marketing` Drive folder for an existing `Learning` doc on the same client + topic (search your Drive / marketing-docs store for `"Learning <topic> <Client Display Name>"`). If one exists and this is an update, **append/revise it** rather than creating a second. Don't fragment the client's learnings.

### Decision-logging append mode

A special case of Step 1: when the purpose is to **log a decision at decision time** (not capture a full learning), use the per-engagement **`Learning — Decisions — <Client Display Name>`** doc. This doc accumulates one-line decisions across sessions and stages, forming the recall surface for `cm-learnings-researcher`:

- **Find or create** a `Learning — Decisions — <Client Display Name>` doc in the `Compound Marketing` folder. If it exists, **append** a new row; if not, create it with the title `Learning — Decisions — <Client Display Name>` (no date — this doc is perpetual, one per client).
- **Format** — one line per decision:
  ```
  | <YYYY-MM-DD> | <Stage> | <Decision> | <Why / rationale> |
  ```
  e.g. `| 2026-07-10 | cm-plan | Lighting rebuild is the seasonal lever, not email — because Google is at its ceiling and lighting drives Sept→spring | Google Ads ROAS plateaued at 5.2x for 6 weeks; lighting open rate 3× email in Sept |`
- **Index update** — after appending, update the folder's `CLAUDE.md` `## Index of Learning docs` list if this is a new doc (Skip if already listed).
- **Error path** — if the Drive tools are unreachable or the append fails, surface the failure loudly (never skip silently) and carry the unlogged decision verbatim in the session's handoff block as a pending-log item with: `PENDING DECISION LOG: <date> · <stage> · <decision> · <why>`

## Step 2 — Resolve the Drive destination

Write to the single flat **`Compound Marketing`** Drive folder — the shared parent for the whole `/cm*` suite (no per-client subfolders). Resolve it once at runtime:

1. Search/list your Drive (or equivalent marketing-docs store) for a folder named `Compound Marketing`.
2. **Resolve to exactly ONE folder — never guess when it's ambiguous.**
   - **0 matches:** create it (top-level, flat inside).
   - **1 match:** use it.
   - **>1 match (duplicate folders):** STOP. Do **not** silently pick one — a name search is nondeterministic and writing to the wrong copy silently splits the corpus (recall + write drift apart). Surface the ambiguity to the caller with the candidate folder IDs and modified dates, and ask which is canonical (or merge the duplicates into one first). The canonical folder's in-folder `CLAUDE.md` breadcrumb names its own ID — prefer the folder whose `CLAUDE.md` self-identifies as canonical.
3. Never write to the repo or a local per-client working folder — write through your Drive / marketing-docs tooling, not a filesystem path that may be symlinked or sandbox-blocked. Canonical convention: `reference/sop-cm-pipeline.md` § Artifact naming convention.

## Step 3 — Write the doc (user-friendly)

Title convention (broad → detailed, left to right; so `cm-learnings-researcher` + the stages find it): **`Learning — <topic> — <Client Display Name> — <YYYY-MM-DD>`** (e.g. "Learning — Channel Prioritization — Acme Retail — 2026-06-29"). See `reference/sop-cm-pipeline.md` § Artifact naming convention.

Create it as a formatted Google Doc (via your Drive tooling, or build markdown then convert it to a doc). Keep it skimmable — this is read by you and potentially the client, not a dev. Structure:

```
# Learning — <topic> — <Client Display Name> — <YYYY-MM-DD>
channels: <...>

## The decision / finding
[1-3 sentences, plain language. What we concluded and the one-line why.]

## The evidence it rests on
[The specific data/signals behind it — ROAS, CoS, channel state, dates. Cite real numbers.]

## How we'll know it worked (success signal)
[The observable signal + target + when to check. A learning with no success signal is a guess.]

## What this constrains next time
[The carry-forward: what a future /cm-* run must honor or not re-litigate. Open evidence
 gaps. Known failures to avoid.]

## Source
[The /cm-plan run / meeting / thread this came from.]
```

## Step 4 — Confirm + link

Render the doc title + Drive link in chat. Note that `cm-learnings-researcher` will now surface it before the next `/cm-*` run for this client.

## Step 5 — Update the folder's `CLAUDE.md` index (the cold-session breadcrumb)

The `Compound Marketing` folder contains a plain-text **`CLAUDE.md`** (real bytes, NOT a Google Doc — so it's readable on a plain `ls`/`Read`, unlike the `.gdoc` learnings). It's the breadcrumb a cold session reads when it lands in the folder: empirically (2026-06-29 test) a fresh agent orienting in the folder reads `CLAUDE.md` on its own and follows its "`.gdoc` is a pointer → read it via your Drive-doc-reading tool" recipe. **After writing a new Learning doc, append its title to the `## Index of Learning docs` list in `CLAUDE.md`** so the breadcrumb stays current.

It is a local Drive-mount file, so update it with a direct filesystem write (not a Drive-API doc-editing tool): your local Drive-mount path for the `Compound Marketing` folder (e.g. `~/My Drive/Compound Marketing/CLAUDE.md`). If it's missing, recreate it from the template (the read-recipe + title convention + the index). Keep it plain markdown — its whole value is that it survives a filesystem read where the Google Docs cannot.

## Relationship to the rest

- **Recall:** `cm-learnings-researcher` (bundled agent), dispatched before every `/cm-*` skill. Wire this via your workspace's skill-context-injection hook if you have one, or invoke it manually at the start of a `/cm-*` run.
- **Trigger:** your session-wrap / learning-capture routine (the marketing analog of an engineering "capture a solved problem" step) should offer `/cm-compound` when a session produced a marketing decision/learning. Also invoke directly, or at the end of a `/cm-plan` that settled something durable.
- **Distinct from an autonomous-copilot learning extractor, if your workspace has one:** that kind of skill would extract _playbook/guardrail_ patterns into code for an autonomous copilot. `/cm-compound` captures _client-strategy + methodology_ learnings into Drive for human + `/cm-*` recall — a different consumer. Run both when both apply.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

**Suppress this offer when `/cm-compound` was invoked by `/cm-session-review`** (i.e. running as the wrap's Step 4 capture sub-step, not standalone) — the wrap is already in progress, so re-offering it is redundant.

## Self-update directive

When a capture surfaces a better doc structure, a Drive-folder convention change, or a new learning type, update this file before finishing.

## Appendix — Red Pine reference implementation (optional)

Red Pine Digital's own deployment of this skill uses Shanti MCP (`shanti_search_drive`, `shanti_list_drive_files`, `shanti_create_drive_folder`, `shanti_create_drive_document`) as its Drive/marketing-docs tooling, the `/format-gdoc` skill to convert markdown to a formatted doc, `pre-tool-skill-context-injector.sh` to auto-dispatch `cm-learnings-researcher` before every `/cm-*` run, and `/learn` category 13 (its engineering-learning capture step) as the trigger to offer `/cm-compound`. A worked title example from that deployment: "Learning — Channel Prioritization — Sprinkler Supply Store — 2026-06-29". Red Pine also runs a distinct autonomous-copilot learning extractor (`/cmo-copilot-learn`) that writes `copilot-playbooks.ts` + `case-*.md` for its CMO copilot — unrelated to this skill's Drive output, run both when both apply.
