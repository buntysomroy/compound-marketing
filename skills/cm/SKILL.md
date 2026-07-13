---
name: cm
description: >-
  Use when the user says '/cm', "what should we do about <client>'s marketing", "need a marketing plan", "audit their ads", "analyze <client>", "check the marketing", "which lever should we pull", "marketing strategy for <client>", "offer decision", "which channel should we focus on", or any client-marketing question where you're not sure which entry stage to start from. /cm is the FRONT DOOR for Compound Marketing — performs symptom intake, runs decisions recall, checks for existing engagement artifacts, and recommends the right entry stage (cm-audit / cm-analyze / cm-plan / cm-review / cm-execute / cm-analytics-audit / cm-experiment) with a one-line reason, confirms with the user, then routes. Run this BEFORE any ce-* skill for client-marketing work.
---

# /cm — Compound Marketing: Front-Door Dispatcher

> **Where this sits.** This is the **front door** for the entire CM suite. Run it BEFORE any ce-\* skill for client-marketing work. It performs symptom intake, runs decisions recall, checks for existing engagement artifacts, and recommends the right entry stage.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the five contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging) are mandatory for every cm-\* stage. This dispatcher runs Step 1 (recall) once and passes results down so the routed stage doesn't re-dispatch.
>
> Pipeline reference: `reference/sop-cm-pipeline.md`.

This skill **only routes**. It does not perform stage work. The stage skills do the work; this skill gets you to the right one.

## Step 0 — Load Contract + Run Recall Once

1. Load the stage contract (`reference/protocol-cm-stage-contract.md`).
2. Dispatch `cm-learnings-researcher` with the work-context block (Client slug + display name / Stage: "intake" / Channels-topics from the symptom).
3. List the returned carry-forward items visibly in chat (per contract Step 1 output shape).
4. **Pass results down** — note in the handoff to the routed stage that recall was already run; the stage should not re-dispatch the researcher.

## Step 1 — Intake: Classify the Signal Source

Identify how the symptom arose. Classify into one of:

| Signal source           | Example                                                |
| ----------------------- | ------------------------------------------------------- |
| Slack message or report | "The client asked about lead quality in Slack/Discord" |
| Report or metric change | "Google Ads ROAS dropped 20% this week"                |
| Commitment              | "We decided to test lighting as the seasonal lever"    |
| Prior artifact          | Pasted handoff block from a prior session              |
| Vague symptom           | "What should we do about this client's marketing?"     |

Trace how the symptom arose — what triggered it, what data or conversation led to it. This is the provenance trace (R1).

## Step 2 — Artifact Check

Search your marketing docs store (Google Drive, etc.) for existing engagement docs for this client — the Compound Marketing folder for this account, filtered to the client's display name.

List what exists:

- `Audit —` doc → Stage 1 complete
- `Analysis —` doc → Stage 2 complete
- `Plan —` doc → Stage 3 complete
- `Lens Review Summary` appended to plan → Stage 4 complete
- `Execution Manifest —` or `Execution Tracker —` → Stage 5 in progress or complete
- `Learning —` docs → prior learnings exist (already surfaced in Step 0)
- `Experiment —` doc → a measured test ran or is running

Mark completed stages. Route past them rather than re-running (R3).

## Step 3 — Recommend Entry Stage

Use the intent→stage table to recommend ONE entry stage with a one-line reason:

| Intent / symptom                                                    | Recommended entry                     |
| ------------------------------------------------------------------- | ------------------------------------- |
| "What's happening with their marketing" / no prior artifacts        | `/cm-audit` (Stage 1)                 |
| "What's working / what should we change" / audit doc exists         | `/cm-analyze` (Stage 2)               |
| "Build a marketing plan" / "fix this problem" / analysis doc exists | `/cm-plan` (Stage 3)                  |
| "Review / pressure-test this plan" / plan doc exists                | `/cm-review` (Stage 4)                |
| "Make the changes / execute the plan" / approved plan exists        | `/cm-execute` (Stage 5)               |
| "Tracking is broken / conversions look off"                         | `/cm-analytics-audit` (diagnostic)    |
| "Test this before we roll it out" / plan action is a measured test  | `/cm-experiment` (companion)          |
| "Capture this learning / mark this decision"                        | `/cm-compound` (no dispatcher needed) |
| "Wrap the marketing session / what did we learn"                    | `/cm-session-review` (session-wrap trigger) |

**Never route silently on a coin-flip.** If the intent is ambiguous between two stages, ask one outcome-framed question (e.g., "Do you want to understand what's happening first (audit), or do you already have data and want to know what to change (analyze)?"). Then recommend.

Present the recommendation via AskUserQuestion (or equivalent):

- **Recommended option:** the stage you identified, with a one-line reason and the artifact(s) you'll build on (if any).
- **Alternative:** the next-most-likely stage, with a one-line reason.
- **Direct bypass:** "Skip dispatcher — I know which stage to start from" (routes to direct `/cm-<stage>` invocation).

## Step 4 — Announce and Route

After the user confirms:

1. Announce one line: "Routing to `/cm-<stage>` — <one-line reason>."
2. Invoke the stage via the Skill tool.
3. Pass the recall results from Step 0 in the invocation context so the stage doesn't re-dispatch the researcher.

## Handoff

If the dispatcher run produces no stage invocation (e.g., the user just wanted to check what artifacts exist), emit a handoff block per contract Step 4 summarizing what was found and the next action.

## Self-Update Directive

If a routing call was wrong (the user corrected the recommendation, or the routed stage immediately re-ran recall because the dispatcher's results were stale), tighten the intent→stage table's trigger phrases. The goal: the audit's verbatim confusion cases ("or maybe /cm-audit then /cm-analyze before /cm-plan") route correctly on the first try.
