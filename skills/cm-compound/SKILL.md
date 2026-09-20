---
name: cm-compound
description: "Use when you say '/cm-compound', 'capture this marketing learning', 'save the CM decision', 'document why we chose X channel', 'compound this learning', 'write a learning doc for this client', or after a /cm-plan / strategic-marketing decision worth remembering. Capture a solved marketing problem, durable client-strategy decision, or Compound Marketing methodology learning in the engagement's resolved artifact workspace so a future /cm-* run recalls it instead of re-deriving it."
---

# /cm-compound — Compound Marketing: capture a learning

> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the six contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging, open items) are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> Pipeline reference: `reference/sop-cm-pipeline.md`.

The **write half** of the CM compound loop. `cm-learnings-researcher` is the recall half. Both must resolve and use the same artifact workspace profile.

## When a learning qualifies

Capture when the session produced one of:

- A **settled client-strategy decision** with rationale ("lighting rebuild is the seasonal lever, not email — because Google is at its ceiling and lighting drives Sept→spring").
- A **methodology learning** about how to do the marketing work ("strategic-question replies need /cm-plan single-problem — free-handing misses the higher-leverage lever + the success signal").
- A **solved marketing problem** ("the Meta access block was an ownership issue, resolved by X").
- A **flagged evidence gap or open success signal** worth carrying forward ("recommended lighting but never pulled last season's lighting ROAS — gate still open").

**Bar:** would the next `/cm-*` run for this client be better if it inherited this? If yes, capture it. Size of the arc is irrelevant — a one-line "we decided X because Y" still qualifies.

## Step 1 — Dedup first

Search the selected artifact workspace for an existing learning on the same project/client + topic. If one exists and this is an update, **append/revise it** rather than creating a second. Do not search one profile and write to another.

### Decision-logging append mode

A special case of Step 1: when the purpose is to **log an accepted decision at decision time**, append it using Stage Contract Step 5. Project-local uses `<project-slug>-decisions.csv`; shared Drive uses `Learning — Decisions — <Client Display Name>.docx`. Do not wait for session wrap, do not treat proposals as accepted decisions, and do not redirect to the other profile if the selected log fails.

## Step 2 — Resolve the artifact destination

Resolve the profile once under `reference/sop-cm-pipeline.md`. Project-local writes to one flat `<project-root>/CM Artifacts` directory; shared Drive writes to exactly one canonical `Compound Marketing` folder. On ambiguity or write failure, stop. Never create a second corpus or fall back across profiles.

## Step 3 — Write the doc (user-friendly)

Project-local title: `<project-slug>-<run-id>-<YYYY-MM-DD>-learning-<topic-slug>.md`. Shared-Drive title: `Learning — <topic> — <Client Display Name> — <YYYY-MM-DD>.docx`. Keep it skimmable. Structure:

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

Render the artifact title plus its local path or Drive link in chat. Note that `cm-learnings-researcher` will now surface it before the next `/cm-*` run for this client.

## Step 5 — Keep the workspace discoverable

In project-local mode, the flat filename convention and project routing contract are the index; update an existing CM artifact index only when the project already maintains one. In shared-Drive mode, update the canonical folder's manual `CLAUDE.md` learning index. That breadcrumb is useful navigation, not guaranteed harness context.

## Relationship to the rest

- **Recall:** `cm-learnings-researcher` (bundled agent), dispatched before every `/cm-*` skill. Wire this via your workspace's skill-context-injection hook if you have one, or invoke it manually at the start of a `/cm-*` run.
- **Trigger:** your session-wrap / learning-capture routine (the marketing analog of an engineering "capture a solved problem" step) should offer `/cm-compound` when a session produced a marketing decision/learning. Also invoke directly, or at the end of a `/cm-plan` that settled something durable.
- **Distinct from an autonomous-copilot learning extractor, if your workspace has one:** that kind of skill would extract _playbook/guardrail_ patterns into code for an autonomous copilot. `/cm-compound` captures _client-strategy + methodology_ learnings into Drive for human + `/cm-*` recall — a different consumer. Run both when both apply.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer the wrap step:

- **Your workspace already has a terminal wrap** (detect: `.claude/skills/session-wrap/SKILL.md` exists in the workspace) — say "learning captured; `/session-wrap` is the terminal step in this repo" and do **not** offer `/cm-session-review`. The host wrap owns closing the session; a second offer would just be a competing entry point.
- **Otherwise**, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

**Suppress this offer when `/cm-compound` was invoked by `/cm-session-review`** (i.e. running as the wrap's Step 4 capture sub-step, not standalone) — the wrap is already in progress, so re-offering it is redundant.

## Self-update directive

When a capture surfaces a better doc structure, a Drive-folder convention change, or a new learning type, update this file before finishing.

## Appendix — Red Pine reference implementation (optional)

Red Pine Digital's own deployment of this skill uses Shanti MCP (`shanti_search_drive`, `shanti_list_drive_files`, `shanti_create_drive_folder`, `shanti_create_drive_document`) as its Drive/marketing-docs tooling, the `docx` skill + a Drive-upload tool with content-type conversion disabled to produce and place the `.docx` file (superseding the older `/format-gdoc` native-Google-Doc path — see `reference/sop-cm-pipeline.md` § Storage tradeoff & access for why), `pre-tool-skill-context-injector.sh` to auto-dispatch `cm-learnings-researcher` before every `/cm-*` run, and `/learn` category 13 (its engineering-learning capture step) as the trigger to offer `/cm-compound`. A worked title example from that deployment: "Learning — Channel Prioritization — Sprinkler Supply Store — 2026-06-29.docx". Red Pine also runs a distinct autonomous-copilot learning extractor (`/cmo-copilot-learn`) that writes `copilot-playbooks.ts` + `case-*.md` for its CMO copilot — unrelated to this skill's Drive output, run both when both apply.
