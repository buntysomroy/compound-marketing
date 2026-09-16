---
name: cm-handoff
description: >-
  The ONE handoff generator for Bunty's workspaces — I invoke this whenever I am about to hand
  work to a fresh session, park an item, or end a session with work still open, whether the work
  is Compound Engineering, Compound Marketing, or plain workspace work tracked on a board or an
  issue. Also on "hand this off", "give me the handoff", "pause this", "what's the state of this
  run", or any request for a resume/starter block. A handoff is a pastable fenced block whose first
  line is a SKILL INVOCATION and whose payload is a DURABLE PATH at the Drive root — never a bare
  tracker pointer, never restated conclusions, never a description of what to do next. Three
  modes: (A) route to a durable artifact with the owning CE or CM skill, (B) fallback that adapts
  CE's `/ce-handoff` to a Drive-root destination when no artifact owns the next step, (C) the CM
  stage-completion block from the stage contract. Never free-hand a handoff; use this skill.
---

# /cm-handoff — the single owner of handoffs

> **Where this sits.** This is the central source of truth for handoff format across every workspace
> that installs this plugin (ruled by Bunty 2026-09-16). Workspace instruction files (`CLAUDE.md`,
> the Cowork Work Board pickup pointer skill) POINT here; they do not carry a format of their own. CM stage
> skills emit their end-of-stage block per the stage contract Step 4; that block's `First step` line
> IS a Mode A invocation, so the two never disagree.
>
> **Stage contract (load in Step 0 when CM work is in play):** `reference/protocol-cm-stage-contract.md`
> — Step 4 (handoff block) and Step 6 (Open Items). This skill references both and restates neither.

## The principle

A handoff is **one fenced code block** the next session pastes as its first message. Line 1 is a
skill invocation; the payload is a durable path at the Drive root (`CE Artifacts/…`, a project
folder, a CM stage doc). An optional last line is the tracker pointer. Nothing else goes in the
block — no grounding prose, no step restatement, no summary of this session's conclusions. Everything
the next session needs is either ON the artifact or ON the tracker item; the block only points.

Two layers, always:

1. **Setup, OUTSIDE the block, addressed to the human:** `Start in:` (the folder to open the session
   in), `Recommended model: <tier + one-line why>`, which harness/permission mode if it matters, and
   any wall-clock constraint (a window with no scheduled fire). Prose, not payload.
2. **The block itself**, per the mode below.

**The route lives on the tracker item first, the block second.** ZenMaid: the Work Board item's
`route` field. RPD: the issue body's route line. Write the field, then emit the block; a block whose
route exists only in chat is gone the moment it is pasted alone.

## Step 0 — Pick the mode

| Situation | Mode |
|---|---|
| A durable artifact exists (plan, brainstorm, audit, stage doc) AND a CE or CM skill owns the next step on it | **A — route to the artifact** |
| A CM stage just completed and is emitting its end-of-stage block | **C — stage-contract block** (its `First step` is a Mode A line) |
| No artifact owns the next step, or the continuity context lives nowhere durable (a mid-stream investigation, a decision thread, a debugging state) | **B — fallback via `/ce-handoff`** |

Never emit a bare `Work Board item: <id>` or issue URL as the whole block. That form was retired
2026-09-16: a fresh session had to open the item, find the route, then invoke it, when it could have
started on the invocation directly.

## Mode A — route to a durable artifact (primary)

Line 1 is the owning skill plus the artifact's path. Same shape for both plugins:

```
/compound-engineering:ce-work "/<absolute Drive root>/CE Artifacts/plans/<plan>.md"
Work Board item: <id>
```

```
/compound-marketing:cm-analyze "<Drive doc title or path of the Audit artifact>"
Work Board item: <id>
```

Rules:
- The path is **absolute for machine-local files** (so it is clickable and unambiguous) and lives
  under the Drive root — `CE Artifacts/plans/`, `CE Artifacts/brainstorms/`, a project folder's
  stage doc. A plan is a CE artifact; it never lives inside a tracker item's fields.
- The skill is the one that OWNS the next step: `ce-work` for an implementation-ready plan,
  `ce-plan` for a brainstorm/requirements doc, `ce-doc-review` for a plan awaiting review,
  `cm-<next stage>` for a CM stage doc with no blocking Open Items, `cm-<same stage> — resume open
  items:` when the artifact's Open Items include a blocking one (contract Step 4 rule).
- Line 2 is the tracker pointer when one exists (`Work Board item: <id>` in ZenMaid; the issue URL
  in RPD). Grounding fires on it; hydration reads it.
- Scope a unit range only when the plan itself defines units and the next session should stop
  partway (`… — U1–U8 only`). Otherwise the plan's own sequencing governs.

## Mode B — fallback: adapt CE's `/ce-handoff`

When nothing durable owns the next step, do not invent a summary block. Create a CE handoff **at a
Drive-root destination** and hand off the resume command:

1. Invoke `/compound-engineering:ce-handoff create <focus>` and name the destination explicitly:
   `<Drive root>/CE Artifacts/handoffs/<YYYY-MM-DD>-<slug>.md`. `ce-handoff`'s default managed store
   is OS-managed `/tmp` and is NOT durable; naming the destination is what makes it one. Create the
   `handoffs/` folder if absent (it is a CE artifact home like `plans/`).
2. Confirm the file exists at that path (ce-handoff's own completion report does this).
3. The block is the resume invocation plus the tracker pointer:

```
/compound-engineering:ce-handoff resume "/<absolute Drive root>/CE Artifacts/handoffs/<YYYY-MM-DD>-<slug>.md"
Work Board item: <id>
```

The `ce-handoff` document is pointer-first by its own contract (plans, issues, files, what matters in
each), so this mode still honors the principle: the block points at a durable file, and the file
points at the artifacts. If `ce-handoff` is not installed on the host, say so, write the same
pointer-first document by hand at the same path, and emit the same resume line with a note that the
next session reads the file directly.

## Mode C — CM stage-completion block

When a CM stage completes, emit the contract Step 4 block verbatim (one fenced block from
`## Handoff — <Stage> complete` through `First step`). Its `First step` line is a Mode A invocation:
the same stage's resume command if any Open Item is blocking, the next stage's invocation otherwise
— one command, never both. Open Items are copied from the artifact's Step 6 section with the same IDs
and wording; findings are never restated (contract Step 4, and this skill's whole reason to exist).

## Step 1 — Gather session state (thin)

Collect pointers, not content:

1. **Artifacts created or updated** — title + Drive path/link for each. Findings live only there.
2. **Open Items** — from each artifact's `## Open Items` (contract Step 6), copied verbatim with IDs
   and blocking flags. An artifact with no Open Items section has none; say so, do not invent.
3. **Decisions made** — AskUserQuestion answers, chat confirmations. Logged per contract Step 5 or
   logged now (Step 3 below).
4. **Carried-over / don't-repeat** (Mode C only) — the one field this skill composes rather than
   points at.

If Step 1 starts building an evidence summary, the skill has drifted from thin to duplicative: stop,
point at the doc.

## Step 2 — Emit

Setup prose first (layer 1), then exactly one fenced block (layer 2) per the mode chosen in Step 0.
Where a tracker item exists, write its `route` field BEFORE emitting, then echo `Route: <skill>` in
the setup prose. Where a fresh session must open a particular folder so a project `CLAUDE.md` loads,
say so in `Start in:`.

## Step 3 — Decision logging (if needed)

Decisions from Step 1 not yet logged per contract Step 5: append them to the
`Learning — Decisions — <Client Display Name>` doc. If the Drive tools are unreachable, surface it
loudly and carry them in the block as `PENDING DECISION LOG` items (Mode C) or in the `ce-handoff`
document (Mode B).

## Step 4 — Offer a file copy (Mode C only, optional)

The inline block is the primary output (R12). Offer a `handoff-<client>-<date>.md` copy only if the
user wants one; never default to it. Modes A and B already produce or point at a durable file.

## Edge cases

- **No CE or CM work and no tracker item** — Mode B still applies; the `ce-handoff` document carries
  the continuity, and its `focus` names what the next session is for.
- **Invoked mid-stage** — Mode C with a note that the stage is incomplete, or Mode B if no artifact
  has been written yet.
- **Multiple clients or items** — one block per client/item, or ask which to hand off.
- **The next step is a human action, not a skill** (a UI toggle, an approval) — it goes in the
  tracker item's `next_action` and in the setup prose, never in the block; the block still routes
  the agent-executable part.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked
before approving, or surfaced a methodology learning, offer `/cm-session-review` as the wrap step.

## Self-update directive

If a pasted block makes the next session re-derive state instead of starting on the invocation, the
block was not thin enough or its artifact was not durable enough: fix the artifact or the mode
choice here, not the block's prose. If a workspace instruction file is found carrying its own
handoff format instead of pointing here, that is the defect this skill exists to end — repoint it.

## Change record

- **2026-09-16 (0.10.4)** — Became the single owner of handoff format for all workspaces (Bunty).
  Added the principle (invocation + durable Drive-root path), Modes A and B, the retirement of the
  bare tracker-pointer block, and the two-layer setup/block contract that lived in ZenMaid
  `CLAUDE.md` and the (since retired) Cowork grounding skill. Mode C is the prior 0.10.1 behaviour, unchanged.
- **0.10.1** — Handoff block wrapped in a fenced code block for one-click copy.
- **Contract Step 6** — Open Items made the handoff a thin pointer, not a restatement.
