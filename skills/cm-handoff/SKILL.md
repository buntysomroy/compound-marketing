---
name: cm-handoff
description: >-
  Use when the user says "pause this cm session", "hand off the cm work", "generate a handoff for <client>", "what's the state of this cm run", "create a cm handoff block", or when a CM session is ending or forking and a structured handoff is needed. Generates a structured handoff block (What & why / Carried-over context / Don't-repeat / First step) inline in chat — the same format the stage contract requires every cm-* stage to emit before finishing. Never free-hand a CM handoff; use this skill instead. Works mid-stage and outside any stage.
---

# /cm-handoff — Compound Marketing: Standalone Handoff Block

> **Where this sits.** This is the **standalone handoff generator** for the CM suite. It produces the same handoff block shape that every cm-\* stage emits at the end (per contract Step 4), but on demand — mid-stage, between stages, or when a session is ending without a stage completion.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — this skill references the contract's Step 4 (handoff block) and does not restate the format.
>
> Pipeline reference: `reference/sop-cm-pipeline.md`.

This skill is **thin** — it gathers session state and emits the contract's handoff block. It does not perform stage work.

## Step 0 — Load Contract

Load the stage contract (`reference/protocol-cm-stage-contract.md`). The handoff block format is defined in contract Step 4; this skill references it, not restates it.

## Step 1 — Gather Session State

Collect what this session touched:

1. **Stage docs created or updated** — list any Drive docs (Audit, Analysis, Plan, Execution Manifest, Learning, etc.) with titles and links.
2. **Decisions made** — list any decisions from this session (AskUserQuestion answers, chat confirmations, explicit choices). If decisions were already logged via contract Step 5, note that; if not, this skill logs them now.
3. **Open questions** — list any unresolved questions or gaps the next session needs to address.
4. **Evidence with provenance** — list the key findings from this session with their source, denominator/coverage, and proxy-validity note (per contract Step 2 shape).

## Step 2 — Emit Handoff Block

Render the handoff block inline in chat using the contract Step 4 format:

```
## Handoff — <Stage or "CM session"> complete

**What was done:**
- <1-2 lines summarizing the session's work>

**Artifacts:**
- <artifact type> — <doc title> (Drive link or path)
- ...

**Evidence (with provenance):**
- <finding> (Source: <source>; Denominator: <coverage>)
- ...

**Decisions made:**
- <date> · <stage> · <decision> — <why>
- ...

**Carried-over context (for the next stage):**
- <what the next stage needs to know without re-deriving>

**Don't repeat (confirmed findings, closed questions):**
- <what's settled and should not be re-opened>

**First step (next stage entry prompt):**
- `<next-stage-invocation>` — <one-line reason>
```

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

## Self-Update Directive

If a handoff block is pasted into a fresh session and the next session re-derives state instead of resuming from the block, the block's "Carried-over context" or "Don't repeat" fields were insufficient. Tighten the field guidance to make the transferable context explicit.
