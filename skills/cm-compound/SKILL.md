---
name: cm-compound
description: "Capture a solved marketing problem, a durable client-strategy decision, or a Compound Marketing methodology learning as a user-friendly Google Doc in the flat `Compound Marketing` Drive folder — so a future /cm-* run recalls it (via cm-learnings-researcher) instead of re-deriving it. The marketing mirror of /ce-compound (which writes engineering solutions-*.md to the repo); this writes to Drive because marketing docs belong where the client + team can read them. Use when the user says '/cm-compound', 'capture this marketing learning', 'save the CM decision', 'document why we chose X channel', or after a /cm-plan / strategic-marketing decision worth remembering."
---

# /cm-compound — Compound Marketing: capture a learning

The **write half** of the CM compound loop. `cm-learnings-researcher` is the recall half. Together they mirror the engineering loop (`/ce-compound` writes `protocols-and-sops/solutions-*.md`; `ce-learnings-researcher` recalls them) — except marketing learnings are written as **user-friendly Google Docs in Drive**, not repo markdown, because the client and team read them.

## When a learning qualifies

Capture when the session produced one of:

- A **settled client-strategy decision** with rationale ("lighting rebuild is the seasonal lever, not email — because Google is at its ceiling and lighting drives Sept→spring").
- A **methodology learning** about how to do the marketing work ("strategic-question replies need /cm-plan single-problem — free-handing misses the higher-leverage lever + the success signal").
- A **solved marketing problem** ("the Meta access block was an ownership issue, resolved by X").
- A **flagged evidence gap or open success signal** worth carrying forward ("recommended lighting but never pulled last season's lighting ROAS — gate still open").

**Bar:** would the next `/cm-*` run for this client be better if it inherited this? If yes, capture it. Size of the arc is irrelevant — a one-line "we decided X because Y" still qualifies.

## Step 1 — Dedup first

Search the flat `Compound Marketing` Drive folder for an existing `Learning` doc on the same client + topic (search your marketing docs store (Google Drive, etc.) for `Learning <topic> <Client Display Name>`). If one exists and this is an update, **append/revise it** rather than creating a second. Don't fragment the client's learnings.

## Step 2 — Resolve the Drive destination

Write to the single flat **`Compound Marketing`** Drive folder — the shared parent for the whole `/cm*` suite (no per-client subfolders). Resolve it once at runtime:

1. Search your marketing docs store (Google Drive, etc.) for a folder named `Compound Marketing`.
2. If it doesn't exist yet, create it (top-level, flat inside).
3. Never write to the repo or a local `your client/account folder` path (Drive symlinks, sandbox-blocked). Use your marketing docs store's write tools (Google Drive, etc.), which write through the service account. Canonical convention: `reference/sop-cm-pipeline.md` § Artifact naming convention.

## Step 3 — Write the doc (user-friendly)

Title convention (broad → detailed, left to right; so `cm-learnings-researcher` + the stages find it): **`Learning — <topic> — <Client Display Name> — <YYYY-MM-DD>`** (e.g. "Learning — Channel Prioritization — Example Client — 2026-06-29"). See `reference/sop-cm-pipeline.md` § Artifact naming convention.

Create it as a formatted Google Doc (via your marketing docs store's write tools, or build markdown then convert to a Google Doc). Keep it skimmable — this is read by Bunty and potentially the client, not a dev. Structure:

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

The `Compound Marketing` folder contains a plain-text **`CLAUDE.md`** (real bytes, NOT a Google Doc — so it's readable on a plain `ls`/`Read`, unlike the `.gdoc` learnings). It's the breadcrumb a cold session reads when it lands in the folder: empirically (2026-06-29 test) a fresh agent orienting in the folder reads `CLAUDE.md` on its own and follows its "`.gdoc` is a pointer → read via your marketing docs store's read tools" recipe. **After writing a new Learning doc, append its title to the `## Index of Learning docs` list in `CLAUDE.md`** so the breadcrumb stays current.

It is a local Drive-mount file, so update it with a Bash write (not the doc tools) at your Drive mount's `Compound Marketing/CLAUDE.md`. If it's missing, recreate it from the template (the read-recipe + title convention + the index). Keep it plain markdown — its whole value is that it survives a filesystem read where the Google Docs cannot.

## Relationship to the rest

- **Recall:** `cm-learnings-researcher`, dispatched before every `/cm-*` skill.
- **Trigger:** `/learn` (the marketing analog of category 13 — engineering's `ce-compound`) should offer `/cm-compound` when a session produced a marketing decision/learning. Also invoke directly, or at the end of a `/cm-plan` that settled something durable.
- **Distinct from `/cmo-copilot-learn`:** that extracts copilot _playbook/guardrail_ patterns into code + case-study docs for the autonomous copilot. `/cm-compound` captures _client-strategy + methodology_ learnings into Drive for human + `/cm-*` recall. Different consumers; run both when both apply.

## Self-update directive

When a capture surfaces a better doc structure, a Drive-folder convention change, or a new learning type, update this file before finishing.
