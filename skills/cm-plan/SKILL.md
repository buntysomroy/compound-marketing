---
name: cm-plan
description: "Compound Marketing — the PLAN stage (Stage 3). Two input modes: FULL-ACCOUNT (consume a /cm-analyze doc → a sequenced multi-initiative plan) or SINGLE-PROBLEM (a stated problem + cited evidence → a hardened solution+execution doc — the single-problem solution capability). Use when the user says '/cm-plan', 'build the marketing plan', 'turn the insights into a plan', 'sequence the recommendations', 'solution + execution plan for <client>', 'marketing DD', 'fix this one problem for <client>', or after /cm-analyze produces an analysis doc."
---

# /cm-plan — Compound Marketing: Plan stage

> **Where this sits.**
> `/cm-audit` (Stage 1) → `/cm-analyze` (Stage 2) → **`/cm-plan` (this)** → `/cm-review` (Stage 4) → `/cm-execute` (Stage 5).
>
> Full pipeline reference: `reference/sop-cm-pipeline.md`
>
> **Companion:** when a plan action is a **measured test** (incrementality / brand-bid-down, geo holdout, budget-split lift, ad-platform native experiment, creative/LP A/B) rather than a direct change, route it to `/cm-experiment` (`reference/sop-cm-experiment.md`) to design + guardrail + baseline it before it ships.

This is the **plan stage** — turn scored insights into a sequenced action plan. The output is a durable plan doc that the review stage (Stage 4) will adversarially probe and the build prep stage (Stage 5) will map to execution surfaces. No execution here. Plan only.

## Core principle

A plan with no success signal is a wish list. Every action names: who does it, when, how we know it worked, and what it costs if it doesn't.

## Input modes — detect first (KTD-1)

`cm-plan` runs in one of two modes. Detect from the input:

- **Full-account mode** — input is a `/cm-analyze` doc (or "plan the account / channel"). Consume the analysis → a sequenced **multi-initiative** plan (the default flow below).
- **Single-problem mode** — input is a stated **problem + cited evidence** for one issue (or "solution + execution for X", "marketing DD", "fix this problem"). This is the single-problem solution capability: produce a hardened **solution+execution** artifact for that single problem.

> **Invariant exception (documented, intentional).** The CM pipeline's rule is "each stage consumes the prior stage's doc." Single-problem mode is an **explicit exception**: its upstream is a problem statement + evidence, **not** a `/cm-analyze` doc. This is why `/cm-plan` can safely serve a reactive single-problem entry without re-creating a second pipeline.

Both modes write a dated artifact, then hand off to `/cm-review` for the adversarial lens pass. The full-account flow is **Steps 1–5 below**; the single-problem flow is the **"Single-problem mode — methodology"** section immediately below (intake → evidence gate → draft → `/cm-review` → synthesize → approval gate), applying the same owner-map + evidence-pre-gate rules.

## Single-problem mode — methodology

A client problem/opportunity (from an investigation, a brief, a meeting, or an ad-platform/monitoring finding) becomes a review-hardened recommendation with an execution plan — before anything reaches a client or vendor. Two sub-modes:

- **Create (default):** author a new Solution+Execution artifact, then run the 7-step flow.
- **Review:** an existing client deliverable (audit, proposal, growth plan) already exists and needs hardening before it ships. Read the whole artifact, then audit it **section by section** through the four lenses with a per-section apply gate. Fix mechanical issues inline; defer numeric-table reconciliation to a clean rebuild.

### The 7-step flow

1. **Intake** — capture: client slug, the problem, and the evidence already in hand.
2. **Evidence gate (pre-draft)** — confirm the data is the FULL pull, not a sample. If a number came from a sampled/secondary source (a daily-brief sample, a dashboard tile), re-pull the authoritative source before drafting. Do NOT draft on un-verified numbers.
3. **Draft** the artifact (template below).
4. **Lens review** — dispatch all 4 lens agents in parallel over the draft (`cm-lens-evidence`, `cm-lens-measurement`, `cm-lens-ownership`, `cm-lens-brand-client`) via `/cm-review`. **Read the drafted artifact and embed its FULL text inline in each agent prompt between `<ARTIFACT>…</ARTIFACT>` markers — never pass only a file path.** A pathless task returns a single `missing` finding, and every real finding must quote a verbatim substring from the inline artifact (the anti-hallucination guard).
5. **Synthesize + revise** — fold confirmed findings into the artifact. Unresolved findings become "Open questions." Record every lens's verdict in the Lens Review Summary.
6. **Approval gate** — present inline via `AskUserQuestion` (Approve / Modify). Never skip.
7. **Hand off execution** — the artifact is a PLAN. Route execution to tactical `marketing-skills` (ads, cro, copywriting…) and to `/draft-message` for any client/vendor comms. Do not auto-send anything client-facing.

### Artifact location + template

**Location:** a doc in your marketing docs store (Google Drive, etc.) in the flat `Compound Marketing` folder, titled `Solution — <Problem/Channel> — <Client Display Name> — <YYYY-MM-DD>` (per `reference/sop-cm-pipeline.md` § Artifact naming convention — Type first, then Channel/Topic, then Client, then ISO date). The read-back and `cm-learnings-researcher` search that flat folder by title.

```
<!-- cm:solution -->
# CM Solution — <Client> — <Problem>

## 1. Problem
<recap, every claim linked to evidence in §2>

## 2. Evidence base                                   <!-- Evidence lens -->
| Claim | Source (pull/query/URL) | Value | Confidence |
<one row per number used anywhere in the doc>

## 3. Solution
2–3 options, then the recommendation and the root-cause reason it is correct (not the cheapest patch). Mark the recommended option.

## 4. Execution plan                                  <!-- Ownership lens -->
| # | Action | Owner | Effort | Impact | Depends on | Rollback |
<phased; every row has an owner and a rollback>

## 5. Measurement plan                                <!-- Measurement lens -->
| Action | Success signal | Where observed | Check when |
<one row per recommended action; no action without a signal>

## 6. Risk / brand & channel / client-framing         <!-- Brand-Client lens -->
<positioning conflict, channel cannibalization, and how any client-facing framing should read>

## 7. Open questions
<unresolved lens findings + anything needing a human decision>

## Lens Review Summary
| Lens | Verdict | Findings folded in |
<one row per lens>
```

### Lens contract

Each lens agent receives the draft artifact **inline** (between `<ARTIFACT>…</ARTIFACT>` markers — never a bare path) and returns a JSON array of findings. Every finding's `claim` MUST contain a verbatim substring copied from the inline artifact; a finding that can't be quoted is invalid (anti-hallucination guard):

```json
[{ "claim": "...", "verdict": "confirmed|overstated|unsupported|missing",
   "severity": "P0|P1|P2|P3", "confidence": 0-100, "fix": "..." }]
```

P0/P1 findings MUST be resolved (revise the doc) or surfaced in Open questions before the approval gate. P2/P3 are advisory. The owner lens resolves owners from `reference/sop-cm-execution-owner-map.md`.

### Global rules (single-problem mode)

- Data integrity: never draft on a number you have not traced to its authoritative source. Flag inferences with "⚠️ INFERENCE".
- Recommend the root-cause option, not the cheapest patch.
- Never auto-send client-facing comms — route through `/draft-message`.

## Step 1 — Read the inputs (full-account mode)

**Required input:** the insights doc from Stage 2. If it's not provided, ask for the path or offer to run `/cm-analyze` first. (Single-problem mode skips this — its input is the problem + evidence.)

Read:

1. **The insights doc** — the `<Client> — Analysis — <Channel> — <date>` doc in the flat `Compound Marketing` folder of your marketing docs store (search your marketing docs store — Google Drive, etc.). Read it fully; extract the "What to change" scored table as the primary raw material.
2. **Prior plan docs** — search the `Compound Marketing` folder for this client's prior `Plan` docs to see what was planned before and the delta. Don't plan what's already in flight.
3. **Client context** — your client/account folder for owner map, vendor relationships, and execution constraints (e.g., ad-vendor scope, integrations, in-house vs vendor authority).
4. **Business context** — any upcoming launches, seasonality, budget cycles, or known constraints from recent meeting notes.

Confirm the **planning horizon**: default 30-day sprint unless context suggests otherwise (a campaign launch, a seasonal peak, a quarterly planning cycle).

## Step 2 — Sequence the actions

Convert the "What to change" table from the insights doc into a prioritized plan. Sequencing rules:

1. **Quick wins first** (Very Low / Low effort) — prove momentum, build trust, compound into bigger moves.
2. **Blockers before dependents** — if Action B requires Action A's output (e.g., LP fix before bid increase), A goes first.
3. **Risk-ordered for budget-affecting actions** — changes that affect live spend (bid changes, campaign pauses, budget reallocations) sequence AFTER their pre-flights (LP audit, tracking verify).
4. **Spread the automation ladder** — include at least one fully-automated action (copilot executes without sign-off), one copilot-with-approval action, and one operator-decision action per plan cycle. Avoid all-operator plans (creates bottleneck) and all-automated plans (removes oversight).

## Step 3 — Write the plan doc

**Location:** a doc in the flat `Compound Marketing` folder of your marketing docs store (Google Drive, etc.), titled `Plan — <Channel> — <Client Display Name> — <YYYY-MM-DD>` (create via your docs-store tools / `/format-gdoc`). See `reference/sop-cm-pipeline.md` § Artifact naming convention.

**Structure:**

```markdown
# <Client> — <Channel> Marketing Plan — <YYYY-MM-DD>

## Context

- Insights source: [link to Stage 2 analysis doc]
- Planning horizon: [30 days / specific date range]
- Success line: [metric + target from insights doc]
- Owner map: In-house · Copilot (Claude) · Vendor (the ad vendor / other) · Auto

## Bottom line

[2–3 sentences: what this plan does to the success metric and why now]

## Action plan

| #   | Action | Impact | Effort | Owner              | Surface    | Success signal                | Timing |
| --- | ------ | ------ | ------ | ------------------ | ---------- | ----------------------------- | ------ |
| 1   | ...    | High   | Low    | Copilot + approval | Ad platform | ROAS ↑ from X to Y within 14d | Week 1 |
| 2   | ...    | ...    | ...    | ...                | ...        | ...                           | ...    |

## Dependencies + sequencing

[Note any action → action dependencies that affect order]

## Budget impact

- Planned spend change: [+/- $X or %]
- Spend cap: [MAX_SPEND_CHANGE for Stage 5 build plan]
- Requires owner approval above: [$X threshold]

## What this plan doesn't address

[Actions from the insights doc intentionally deferred — with why]

## Success review date

[When to run the next /cm-audit to measure results]
```

Show the plan doc path in chat. Render the Action plan table inline so the operator can see the full sequence without opening the file.

## Step 4 — Surface the highest-risk action

After rendering the plan table, call out the single action most likely to fail review (Stage 4) or require the most care in execution (Stage 5). Frame it as:

> "Watch-out: Action #N ([name]) is highest-risk because [reason]. Stage 4 review will likely flag it — suggest we pressure-test the [evidence/measurement/ownership] before approving."

## Step 5 — Hand off

Offer to proceed to `/cm-review` (Stage 4) to adversarially probe the plan before committing to execution. Always recommend running the review before Stage 5 — the lenses exist to catch things the planner misses.

## Self-update directive

When this run surfaces a recurring planning pattern (e.g., "we always need a LP pre-flight before bid changes"), a missing owner category, or a plan structure improvement — update this file or propose the improvement before finishing.

## Appendix — Red Pine reference implementation (optional)

This skill was originally authored for the Red Pine Digital workspace. That team's concrete setup, for reference:

- **Docs store / tools:** Google Drive via the Shanti MCP (`shanti_search_drive`, `shanti_read_drive_document`); docs formatted with `/format-gdoc`.
- **Client context:** `documents/clients/<slug>/CLAUDE.md` per client (owner map, vendor scope, integrations).
- **Ad-platform data source:** the "Dharma" Google Ads/Meta MCP (`dharma_*`); the SSS-style dashboard Google Sheet read via `shanti_read_spreadsheet`.
- **Owner map:** Bunty (operator) · Copilot (Claude) · Vendor (WhiteGlovePPC / Affan) · Auto.
- **Reference SOPs:** `sop-cm-pipeline.md`, `sop-cm-experiment.md`, `sop-cm-execution-owner-map.md`, and the approval gates in `sop-pipeline-approvals.md` (bundled here under `reference/`).
