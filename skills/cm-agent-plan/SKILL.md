---
name: cm-agent-plan
description: >-
  Use when you say '/cm-agent-plan', 'compile the execution plan', 'build the execution manifest', 'map the plan to tools', 'how do we actually do this', 'get this ready to execute', or after /cm-review approves the marketing plan. Compound Marketing — the AGENT-PLAN stage (Stage 5a, Compile). Compiles an approved marketing plan into validated Action Cards with derived automation rungs, and a gated Execution Manifest — then stops. Never executes anything; hand off to /cm-execute (Stage 5b) to actually run the approved manifest.
---

# /cm-agent-plan — Compound Marketing: Agent-Plan stage (Compile)

> **Where this sits.** `/cm-audit` → `/cm-analyze` → `/cm-plan` → `/cm-review` → **`/cm-agent-plan` (this, Stage 5a)** → `/cm-execute` (Stage 5b).
>
> **Split from the former fused `/cm-execute` (2026-09-12).** `/cm-execute` used to Compile AND Run in one skill. It now only Runs — modeled after Compound Engineering's `ce-work`: it takes an already-compiled, already-approved artifact and executes it, in this session or a fresh one, without re-planning. `/cm-agent-plan` is the new home for the Compile half: read the approved plan, classify every action, derive its rung, and write the gated Execution Manifest `/cm-execute` will run.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the five contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging) are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> **Canonical spec (read FIRST, every run):** your channel's marketing-execution protocol doc — the Action Card schema, rung-derivation table, gate bindings, Effect Probe, adapter contract, and artifact formats should all live there. This skill is the thin driver; do not improvise safety mechanics from memory. (Red Pine's own copy: `protocol-marketing-execution.md` — see Appendix.)
> Pipeline reference: `reference/sop-cm-pipeline.md`. Companion: `/cm-experiment` compiles + runs a plan action as a measured experiment on the same machinery (+ success metric + revert trigger).

This is the **Compile half** of the execution bridge — the marketing analogue of the EA Protocol's pre-flight gate. It answers "what exactly will run, and under what rung?" It never executes anything; it ends at an approval gate and a bare handoff to `/cm-execute`.

## Core safety rules (non-negotiable — protocol §§2–4, restated for enforcement)

1. **The rung is derived, never declared.** Compute each card's rung from its 3-axis classification (reversibility × money × audience) via the protocol §2 table. A plan's rung label is advisory input; correct excess downward and flag it in the manifest. `/cm-execute` inherits whatever rung this stage derives — it does not re-derive or downgrade it at run time.
2. **Nothing runs until this stage's gate passes.** The Manifest Gate is the one authorization that unlocks `/cm-execute`. An unapproved manifest is not a valid `/cm-execute` input — that skill checks for this and stops if it's missing.
3. **Floor invariant, classified here, enforced at run time.** Hard-irreversible, unbounded-money, or client-comms cards must be classified as requiring an explicit approval token (define your own convention, e.g. a literal `# APPROVED` marker) + pre-flight — flag this on the card. Soft-irreversible or spend-adding cards (pauses, exclusions, restructures, status-flips — even at $0) must be classified as requiring pre-flight + per-card approval. No exceptions, and no card may be classified onto the fully-auto rung to route around this.
4. **Spend cap is declared here.** The manifest declares `MAX_SPEND_CHANGE` + `APPROVAL_REQUIRED_ABOVE`; `/cm-execute` enforces it against the running total as cards act.
5. **Credential posture.** Confirming auth/access for every data source and adapter this manifest will need happens here, before the gate — not discovered mid-run. If the current session does not have confirmed client-account access, stop and surface as `🔴 ACTION REQUIRED` before proceeding.

## Step 1 — Read the approved plan

**Required input:** the approved `<Client> — Plan — <Channel> — <date>` doc (Google Doc in the flat Compound Marketing Drive folder, or the equivalent dated file in the client's own project folder), with the Lens Review Summary appended (Stage 4 output).

Also read:

- your client/account folder's execution notes — execution constraints, vendor scope, authority boundaries
- your channel's audit SOP / account-intelligence doc — for paid search surface details
- your automation-ladder / graduation-policy doc, if you have one

## Step 2 — Compile each plan action into an Action Card

Per action (protocol §1 schema): classify (reversibility × money × audience) → derive rung + gate stack (§2) → bind adapter + tool (§5; api / chrome-ui / feed-cms / human) → write `target_state`, `baseline_probe`, `effect_probe` (with expected delta + latency), `rollback`, `pre_flight`. A mixed action splits into multiple cards (mechanical vs generated-content vs vendor-dispatch).

## Step 3 — Validate

Every card has all required fields; no card's rung exceeds its derived max; manifest-level pre-flights pass (surface auth confirmed per adapter; upstream audit freshness — re-verify any tracking/LP audit older than its shelf life).

## Step 4 — Write the Execution Manifest

`Execution Manifest — <Client> — <Channel> — <YYYY-MM-DD>` Google Doc in the flat Compound Marketing Drive folder (protocol §7 format: card table, spend block, pre-flight results). Render the card table inline in chat.

## Step 5 — Manifest Gate (non-negotiable)

Present `AskUserQuestion`: **Approve — ready for `/cm-execute`** / **Modify manifest** / **Cancel**.

On Approve: **do not execute anything here.** Confirm the manifest doc is saved, then create the **Execution Tracker** (Step 6 below), and hand off with the exact next step: `/cm-execute <path to this manifest doc>`. That's sufficient on its own — everything `/cm-execute` needs (cards, rungs, gates, spend cap) already lives in the manifest; don't restate it in the handoff message.

On Modify/Cancel: execute nothing; update the manifest and re-present.

## Step 6 — Create the Execution Tracker (R9)

Once the manifest is approved, create a client-facing **Execution Tracker** doc:

- **Title:** `Execution Tracker — <Plan topic> — <Client> — <YYYY-MM-DD>`
- **Location:** flat Compound Marketing Drive folder
- **Format:** plan actions as a checklist with owner (from the channel→owner map in `reference/sop-cm-execution-owner-map.md`), status, and date. This is the client-facing view — no internal scaffolding (no provenance blocks, no handoff blocks, no recall digests — per the stage contract's client-facing stripping rule).
- **Shared:** with your approval, share via your Drive-sharing tools with the team and client.

`/cm-execute` keeps this Tracker updated as cards run — this stage only creates it.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

## Self-update directive

When this stage surfaces a new execution surface, a missing pre-flight item, a classification the rung table doesn't cover, or a recurring authorization pattern — update your marketing-execution protocol doc (adapter notes / rung table) before finishing. Update this file only when the Compile flow itself changes.

## Appendix — Red Pine reference implementation (optional)

Red Pine Digital's own deployment binds this skill to `protocols-and-sops/protocol-marketing-execution.md` (the full Action Card schema, rung-derivation table, gate bindings, Effect Probe, and adapter contract) and `documents/clients/<slug>/CLAUDE.md` for per-client execution constraints. Its approval token is the literal string `# BUNTY-APPROVED`. Adapt these to your own repo layout and approval mechanism — the schema and safety rules are what matter, not the file names.
