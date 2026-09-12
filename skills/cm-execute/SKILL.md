---
name: cm-execute
description: >-
  Use when you say '/cm-execute', 'run the approved manifest', 'resume execution', 'pick up where we left off', 'run the approved actions', or when handed an Execution Manifest doc. Compound Marketing — the EXECUTE stage (Stage 5b, Run). Runs an already-approved Execution Manifest card-by-card against live platforms (your ad-platform tool / CRM-automation tool / browser automation / feed-CMS) with verification-of-effect and receipts — in this session or a fresh one. Never compiles or re-plans; if no approved manifest exists yet, run /cm-agent-plan first.
---

# /cm-execute — Compound Marketing: Execute stage (Run)

> **Where this sits.** `/cm-audit` → `/cm-analyze` → `/cm-plan` → `/cm-review` → `/cm-agent-plan` (Stage 5a, Compile) → **`/cm-execute` (this, Stage 5b, Run)**.
>
> **Split from the former fused `/cm-execute` (2026-09-12).** This skill now works like Compound Engineering's `ce-work`: given an already-approved Execution Manifest, it runs it — it does not compile a plan into one. If you're handed a plan doc with no manifest yet, or asked to "execute the plan" with nothing compiled, the right first step is `/cm-agent-plan`, not this skill.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the five contract steps are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> **Canonical spec (read FIRST, every run):** your channel's marketing-execution protocol doc — the Effect Probe, adapter contract, and receipt/artifact formats should all live there. (Red Pine's own copy: `protocol-marketing-execution.md` — see Appendix.)
> Pipeline reference: `reference/sop-cm-pipeline.md`. Companion: `/cm-experiment` runs a compiled test card on this same machinery (+ success metric + revert trigger).

## Core principle

**The Execution Manifest is the single source of truth, not this conversation's memory of it.** This skill may be the very first message in a brand-new session — no prior chat, no carried-over judgment calls. Everything needed to act safely (cards, derived rungs, gate stack, spend cap, adapters) already lives in the manifest `/cm-agent-plan` wrote. Read it in full before acting; don't reconstruct it from a summary.

## Core safety rules (non-negotiable — protocol §§2–4, restated for enforcement)

1. **Require an approved manifest.** If no Execution Manifest is given, or the one given hasn't cleared its Manifest Gate, stop and say so — point back to `/cm-agent-plan`. Never compile a plan into cards here.
2. **Never re-derive or downgrade a rung.** Run each card exactly at the rung `/cm-agent-plan` assigned it. If a card's rung looks wrong once you're looking at live state, that's a stop condition (surface it), not something to silently correct here.
3. **No auto-execution beyond what the manifest authorizes.** Fully-auto-eligible cards run unattended only if the client's graduation flag is ON (default OFF — until then they batch into one approval gate). Authorization is session-scoped — a fresh session re-confirms before acting, it doesn't inherit a prior session's "go."
4. **Floor invariant.** Hard-irreversible, unbounded-money, or client-comms cards require an explicit approval token (e.g. a literal `# APPROVED` marker in the triggering command) + pre-flight. Soft-irreversible or spend-adding cards (pauses, exclusions, restructures, status-flips — even at $0) require pre-flight + per-card approval. No exceptions, regardless of how the card is labeled.
5. **Spend cap, enforced cumulatively.** Track running spend impact against the manifest's `MAX_SPEND_CHANGE` and `APPROVAL_REQUIRED_ABOVE` — never let the total cross the cap even if each card looked small enough alone.
6. **Effect Probe on every card, every rung.** Baseline before acting (skip if already at `target_state`); read back after (prefer a different modality than the act); verdict CONFIRMED / PENDING(t) / FAILED. **FAILED halts the run** — rollback if safe, surface to the user, never retry blind.
7. **Credential posture.** All API calls run through MCP-brokered client auth; browser automation acts only inside an already-authenticated client session and never accepts, stores, or echoes raw credentials. Missing access = `🔴 ACTION REQUIRED`, stop.

## Step 1 — Read the manifest in full

Read the entire Execution Manifest doc named or handed to you. Confirm it cleared its Manifest Gate (Approved, not Modify/Cancel) and carries: a card table, a spend-cap block, and pre-flight results. If any of those are missing, or the gate never passed, stop and direct the user to `/cm-agent-plan` rather than guessing at safety rules the manifest never stated.

If the manifest (or its paired Execution Log) shows which cards already ran, treat that as current state, not a hint — a card marked done or CONFIRMED is done; don't re-run it.

## Step 2 — Re-verify before acting, never re-plan

For every card you're about to touch, re-pull its live state first via that card's `baseline_probe`. Treat anything in the manifest as provisional until re-confirmed live. This is re-verification, not re-planning — don't second-guess the manifest's sequencing, rung, or adapter choice; if live reality has genuinely diverged from what the manifest assumed, that's an anomaly (Step 4), not a cue to improvise.

## Step 3 — Run cards in manifest order

For each card: `baseline → (skip if ALREADY-CONVERGED) → gate(s) → act → read-back → receipt`.

- **Copilot-with-approval cards:** render baseline evidence + exact change + probe plan + rollback inline, then `AskUserQuestion` (EA-class cards: include your workspace's approval token, e.g. `# APPROVED`, in the executing command if your gate checks for one). Batch same-shape cards into one gate with a per-item evidence table.
- **Vendor/human cards:** generate the brief with baseline evidence embedded; EA gate on dispatch; still probe the human's change afterward.
- **Append every receipt to the Execution Log doc as it lands** (protocol §7) — never batch receipts to the end.

## Step 4 — Anomalies

**FAILED** probe → halt, rollback if safe, surface with evidence. **PENDING(t)** → schedule the re-check; the manifest stays open until all PENDINGs resolve (escalate a missed window). **Mid-run discoveries** (a card the manifest didn't anticipate) → compile as a new card, append to the manifest, re-gate as a delta — never execute ad hoc. If the delta is substantial, that's `/cm-agent-plan`'s job to compile properly, not a shortcut to take here.

## Step 5 — Close-out

Render the receipt summary inline (what changed, what's pending, spend delta), link the manifest + log docs, and offer `/cm-compound` if the run surfaced a durable learning.

## Execution Tracker updates (R9)

Keep the client-facing **Execution Tracker** (created by `/cm-agent-plan`) updated as cards execute — status + date per action, alongside (not replacing) the internal append-only Execution Log. Read the live tracker doc back via MCP after updates (deliverable-is-the-live-artifact rule).

## SOP Capture During Execution (R10)

When a run surfaces a platform quirk, adapter gotcha, probe latency, missing pre-flight item, or recurring authorization pattern — write or update the relevant reference/account-intelligence doc (or Drive Learning doc for marketing-side mechanics) **at discovery time**, not at session wrap.

- **Protocol updates:** your marketing-execution protocol doc (adapter notes, pre-flight lists) — update before finishing the run.
- **Marketing-side mechanics:** append to the relevant `Learning —` doc via `/cm-compound` path.
- **Skill updates:** update this skill's own SKILL.md only when the Run flow itself changes; a classification/rung gap belongs in `/cm-agent-plan` instead.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

## Self-update directive

When a run surfaces a new adapter gotcha, a probe latency, a missing pre-flight item, or a recurring authorization pattern — update your marketing-execution protocol doc (adapter notes / pre-flight lists) before finishing. Update this file only when the Run flow itself changes.

## Appendix — Red Pine reference implementation (optional)

Red Pine Digital's own deployment binds this skill to `protocols-and-sops/protocol-marketing-execution.md` (the full Effect Probe and adapter contract), `documents/clients/<slug>/CLAUDE.md` for per-client execution constraints, and `protocols-and-sops/protocol-automation-ladder.md` for the graduation-flag policy. Its approval token is the literal string `# BUNTY-APPROVED`, checked by a pre-commit-style hook on the executing command; its EA (Executive Assistant) posture assumes a single named human approver.
