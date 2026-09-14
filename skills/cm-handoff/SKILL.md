---
name: cm-handoff
description: >-
  Use when the user says "pause this cm session", "hand off the cm work", "generate a handoff for <client>", "what's the state of this cm run", "create a cm handoff block", or when a CM session is ending or forking and a structured handoff is needed. Generates a THIN structured handoff block (What was done / Artifacts / Open Items / Decisions / Carried-over context / Don't-repeat / First step) inline in chat — pointing at the durable artifact and its own Open Items section (contract Step 6) rather than restating findings, and emitting a literal, pastable command as the First step (a resume command when the artifact's Open Items include a blocking item, the next stage's invocation otherwise) — per contract Step 4. Never free-hand a CM handoff, and never let this skill re-derive or summarize an artifact's findings into new prose; use this skill instead. Works mid-stage and outside any stage.
---

# /cm-handoff — Compound Marketing: Standalone Handoff Block

> **Where this sits.** This is the **standalone handoff generator** for the CM suite. It produces the same handoff block shape that every cm-\* stage emits at the end (per contract Step 4), but on demand — mid-stage, between stages, or when a session is ending without a stage completion.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — this skill references the contract's Step 4 (handoff block) and Step 6 (Open Items) and does not restate either format.
>
> Pipeline reference: `reference/sop-cm-pipeline.md`.

This skill is **thin** — genuinely thin, not just short. It gathers session state and emits the contract's handoff block; it does not perform stage work, and it does not re-describe what a durable artifact already says. If you find yourself writing more than a pointer sentence about a finding, stop — that finding belongs in the artifact, and the handoff block should link to it, not repeat it.

## Step 0 — Load Contract

Load the stage contract (`reference/protocol-cm-stage-contract.md`). The handoff block format is defined in contract Step 4; Open Items are defined in contract Step 6. This skill references both, not restates them.

## Step 1 — Gather Session State

Collect what this session touched — as pointers to where it lives, not as re-typed content:

1. **Stage docs created or updated** — list any Drive docs (Audit, Analysis, Plan, Execution Manifest, Learning, etc.) with titles and links. This is the only place full findings live; the handoff block never duplicates them.
2. **Open Items** — for each artifact from #1, read its own `## Open Items` section (contract Step 6) and copy the ID + one-line description + blocking flag verbatim. Do not summarize, merge, or reword them — if the doc says `OI-1 — get_asset_performance returned empty`, the handoff says exactly that, not a paraphrase. If an artifact has no Open Items section, it has none to carry — say so, don't invent one.
3. **Decisions made** — list any decisions from this session (AskUserQuestion answers, chat confirmations, explicit choices). If decisions were already logged via contract Step 5, note that; if not, this skill logs them now.
4. **Carried-over / don't-repeat context** — what's settled and what the next invocation needs without re-deriving. This is genuinely new framing (not present verbatim in the artifact), so it's the one field this skill is allowed to compose rather than just point at.

Deliberately absent from this list: a step to restate findings or evidence. That's the artifact's job. If Step 1 catches itself building an evidence summary, that's the signal this skill has drifted from thin to duplicative — stop and point at the doc instead.

## Step 2 — Emit Handoff Block

Render the handoff block inline in chat using the contract Step 4 format, wrapped in a single fenced code block (the whole block, from `## Handoff —` through the `First step` line, inside one set of triple backticks) so it is copyable in one click and pasteable in a second — never as bare chat markdown:

```
## Handoff — <Stage or "CM session"> complete

**What was done:**
- <1-2 lines summarizing the session's work>

**Artifacts:**
- <artifact type> — <doc title> (Drive link or path)
- ...

**Evidence:**
- See <doc title> for full findings with provenance. <0-1 lines of pointer framing only — no restated findings.>

**Open items (from <doc title>):**
- <OI-id> (blocking: yes/no) — <description, verbatim from the doc>
- ... (or "No open items — this artifact carries no unresolved gaps.")

**Decisions made:**
- <date> · <stage> · <decision> — <why>
- ...

**Carried-over context (for the next stage):**
- <what the next stage needs to know without re-deriving>

**Don't repeat (confirmed findings, closed questions):**
- <what's settled and should not be re-opened>

**First step:**
- `<literal, pastable command>` — <one-line reason>
```

**First step is a command, decided by the Open Items, not by habit.** Check every artifact's Open Items list gathered in Step 1:

- **Any blocking item, on any artifact this session produced or is handing off from:** the first step is that stage's own resume invocation — `` `/cm-<stage> — resume open items: "<doc title>"` `` — never the next pipeline stage. If more than one artifact has blocking items, name the most upstream one (the earliest stage) — closing it may change what downstream needs anyway.
- **No blocking items (or no Open Items at all):** the first step is the next pipeline stage's normal invocation.

Never render both as options in the same field — one line, one command, chosen by the rule above.

If the session produced no artifacts (e.g., just a discussion or a recall run), the handoff block says "no artifacts produced" and the first step is `/cm` to route to the right stage.

## Step 3 — Decision Logging (if needed)

If any decisions from Step 1 were not already logged via contract Step 5, log them now:

1. Append each decision to the `Learning — Decisions — <Client Display Name>` doc (per contract Step 5).
2. If the Drive tools are unreachable, surface the failure loudly and carry the unlogged decisions in the handoff block as `PENDING DECISION LOG` items.

## Step 4 — Offer File Copy (optional)

Offer to save the handoff block as a file (e.g., `handoff-<client>-<date>.md` in the session's working directory). **Never default to file copy** — the inline block is the primary output (R12). The file is optional and only if the user wants a persistent copy.

## Edge Cases

- **Invoked with no CM work in session** — say "no CM work in this session" and offer `/cm` to start a CM run instead of emitting an empty block.
- **Invoked mid-stage** — gather what the stage has produced so far (partial findings, draft artifacts) and emit the handoff block with a note that the stage is incomplete. The next session can resume from the handoff block.
- **Multiple clients in session** — emit one handoff block per client, or ask the user which client to hand off.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

## Self-Update Directive

If a handoff block is pasted into a fresh session and the next session re-derives state instead of resuming from the block, the block's "Carried-over context" or "Don't repeat" fields were insufficient. Tighten the field guidance to make the transferable context explicit.
