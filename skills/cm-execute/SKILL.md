---
name: cm-execute
description: >-
  Use when you say '/cm-execute', 'execute the plan', 'run the approved plan', 'build the execution plan', 'how do we actually do this', 'map the plan to tools', 'ready to execute', 'make the changes', 'implement the marketing plan', or after /cm-review approves the marketing plan. Compound Marketing — the EXECUTE stage (Stage 5, marketing→execution bridge). Compiles an approved marketing plan into a gated Execution Manifest, then RUNS it card-by-card against live platforms (your ad-platform tool / CRM-automation tool / browser automation / feed-CMS) with verification-of-effect and receipts.
---

# /cm-execute — Compound Marketing: Execute stage (Compile → Run)

> **Where this sits.** `/cm-audit` → `/cm-analyze` → `/cm-plan` → `/cm-review` → **`/cm-execute` (this)**.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the five contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging) are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> **Canonical spec (read FIRST, every run):** your channel's marketing-execution protocol doc — the Action Card schema, rung-derivation table, gate bindings, Effect Probe, adapter contract, and artifact formats should all live there. This skill is the thin driver; do not improvise safety mechanics from memory. (Red Pine's own copy: `protocol-marketing-execution.md` — see Appendix.)
> Pipeline reference: `reference/sop-cm-pipeline.md`. Companion: `/cm-experiment` runs a plan action as a measured experiment on the same machinery (+ success metric + revert trigger).

Two phases: **Compile** (plan → validated Action Cards → Execution Manifest → Manifest Gate) and **Run** (per card: baseline → gate(s) → act → read-back → receipt). Compile never executes anything; Run never executes anything ungated.

## Core safety rules (non-negotiable — protocol §§2–4, restated for enforcement)

1. **The rung is derived, never declared.** Compute each card's rung from its 3-axis classification via the protocol §2 table. A plan's rung label is advisory input; correct excess downward and flag it in the manifest.
2. **No auto-execution.** Nothing runs before the Manifest Gate. Fully-auto-eligible cards run unattended only if the client's graduation flag is ON (default OFF — until then they batch into one approval gate). Authorization is session-scoped.
3. **Floor invariant.** Hard-irreversible, unbounded-money, or client-comms cards require an explicit approval token (define your own convention, e.g. a literal `# APPROVED` marker in the triggering command) + pre-flight. Soft-irreversible or spend-adding cards (pauses, exclusions, restructures, status-flips — even at $0) require pre-flight + per-card approval. No exceptions.
4. **Spend cap.** The manifest declares `MAX_SPEND_CHANGE` + `APPROVAL_REQUIRED_ABOVE`; any action exceeding either requires your explicit approval regardless of class.
5. **Effect Probe on every card, every rung.** Baseline before acting (skip if already at `target_state`); read back after (prefer a different modality than the act); verdict CONFIRMED / PENDING(t) / FAILED. **FAILED halts the run** — rollback if safe, surface to the user, never retry blind.
6. **Credential posture.** All API calls run through MCP-brokered client auth; browser automation acts only inside an already-authenticated client session and never accepts, stores, or echoes raw credentials. Missing access = `🔴 ACTION REQUIRED`, stop.

## Phase A — Compile

1. **Read inputs:** the approved+reviewed plan doc (`<Client> — Plan — <Channel> — <date>` in the flat Compound Marketing Drive folder, with Lens Review Summary appended); your client/account folder's context doc; your automation-ladder / graduation-policy doc, if you have one; the protocol doc above.
2. **Compile each plan action into an Action Card** (protocol §1 schema): classify (reversibility × money × audience) → derive rung + gate stack (§2) → bind adapter + tool (§5; api / chrome-ui / feed-cms / human) → write `target_state`, `baseline_probe`, `effect_probe` (with expected delta + latency), `rollback`, `pre_flight`. A mixed action splits into multiple cards (mechanical vs generated-content vs vendor-dispatch).
3. **Validate:** every card has all required fields; no card's rung exceeds its derived max; manifest-level pre-flights pass (surface auth confirmed per adapter; upstream audit freshness — re-verify any tracking/LP audit older than its shelf life).
4. **Write the Execution Manifest** — `Execution Manifest — <Client> — <Channel> — <YYYY-MM-DD>` Google Doc in the flat Compound Marketing Drive folder (protocol §7 format: card table, spend block, pre-flight results). Render the card table inline in chat.
5. **Manifest Gate** (AskUserQuestion): **Approve — run** / Modify manifest / Cancel. On Modify/Cancel: execute nothing; update and re-present.

## Phase B — Run

6. Execute cards in manifest order, each as `baseline → (skip if ALREADY-CONVERGED) → gate(s) → act → read-back → receipt`:
   - Copilot-with-approval cards: render baseline evidence + exact change + probe plan + rollback inline, then AskUserQuestion (EA-class cards: include your workspace's approval token, e.g. `# APPROVED`, in the executing command if your gate checks for one). Batch same-shape cards into one gate with a per-item evidence table.
   - Vendor/human cards: generate the brief with baseline evidence embedded; EA gate on dispatch; Claude still probes the human's change afterward.
   - Append every receipt to the **Execution Log** doc as it lands (protocol §7) — never batch receipts to the end.
7. **Anomalies:** FAILED probe → halt, rollback if safe, surface with evidence. PENDING(t) → schedule the re-check; the manifest stays open until all PENDINGs resolve (escalate a missed window). Mid-run discoveries → compile as new cards, append to the manifest, re-gate as a delta — never execute ad hoc.
8. **Close-out:** render the receipt summary inline (what changed, what's pending, spend delta), link the manifest + log docs, and offer `/cm-compound` if the run surfaced a durable learning.

## Execution Tracker (R9)

After the manifest is approved (Phase A, Step 5), create a client-facing **Execution Tracker** doc:

- **Title:** `Execution Tracker — <Plan topic> — <Client> — <YYYY-MM-DD>`
- **Location:** flat Compound Marketing Drive folder
- **Format:** plan actions as a checklist with owner (from the channel→owner map in `reference/sop-cm-execution-owner-map.md`), status, and date. This is the client-facing view — no internal scaffolding (no provenance blocks, no handoff blocks, no recall digests — per contract's client-facing stripping rule).
- **Shared:** with your approval, share via your Drive-sharing tools with the team and client.
- **Updated:** as cards execute, alongside (not replacing) the internal append-only Execution Log.

Read the live tracker doc back via MCP after updates (deliverable-is-the-live-artifact rule).

## SOP Capture During Execution (R10)

When a run surfaces a platform quirk, adapter gotcha, probe latency, missing pre-flight item, or recurring authorization pattern — write or update the relevant reference/account-intelligence doc (or Drive Learning doc for marketing-side mechanics) **at discovery time**, not at session wrap. This mirrors the decision-time-logging posture from the contract.

Specifically:

- **Protocol updates:** your marketing-execution protocol doc (adapter notes, pre-flight lists) — update before finishing the run.
- **Marketing-side mechanics:** append to the relevant `Learning —` doc via `/cm-compound` path.
- **Skill updates:** update this skill's own SKILL.md only when the flow itself changes.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

## Self-update directive

When a run surfaces a new adapter gotcha, a probe latency, a missing pre-flight item, or a recurring authorization pattern — update your marketing-execution protocol doc (adapter notes / pre-flight lists) before finishing. Update this file only when the flow itself changes.

## Appendix — Red Pine reference implementation (optional)

Red Pine Digital's own deployment binds this skill to `protocols-and-sops/protocol-marketing-execution.md` (the full Action Card schema, rung-derivation table, gate bindings, Effect Probe, and adapter contract), `documents/clients/<slug>/CLAUDE.md` for per-client execution constraints, and `protocols-and-sops/protocol-automation-ladder.md` for the graduation-flag policy (which clients/actions are cleared for unattended execution). Its approval token is the literal string `# BUNTY-APPROVED`, checked by a pre-commit-style hook on the executing command; its EA (Executive Assistant) posture assumes a single named human approver. Adapt these to your own repo layout and approval mechanism — the schema and safety rules are what matter, not the file names.
