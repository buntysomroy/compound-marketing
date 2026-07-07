---
name: cm-experiment
description: >-
  Compound Marketing — the EXPERIMENT companion play. Design, guardrail, baseline, run, and measure a marketing / PPC experiment (Google Ads native draft-and-experiment, geo holdout, brand-bid-down / incrementality, budget-split lift test, or a creative/LP A/B) then write a durable Experiment doc that feeds /cm-compound. Use when Bunty says "/cm-experiment", "run a marketing experiment", "A/B test this campaign", "PPC experiment", "incrementality test", "geo holdout", "brand-bid-down test", "does organic absorb the paid traffic", "test this before we roll it out", or when a /cm-plan action is a measured test rather than a direct change.
---

# /cm-experiment — Compound Marketing: Experiment companion play

> **Where this sits.**
> NOT a numbered pipeline stage. A **companion play** invoked when a `/cm-plan` (Stage 3) action is a _measured test_ rather than a direct change, or from `/cm-execute` (Stage 5) to actually run that test under the Marketing Execution Protocol. It produces an **Experiment doc** and feeds `/cm-compound`.
>
> Methodology + type decision-table + doc template: `reference/sop-cm-experiment.md`
> Statistical rigor (reused, not duplicated): the `ab-test-setup` skill
> Safety model (spend cap / revert / approval / irreversible-op floor): the `cm-execute` skill + `reference/sop-cm-pipeline.md` § "Marketing Execution Protocol".

An experiment with no **pre-registered success threshold, guardrail metric, and revert trigger** is just an unmonitored change. Pre-register all three; write the doc _before_ the test starts; don't peek and stop early.

## When to reach for this (vs a direct change)

Run an experiment when the action is **reversible-but-uncertain and the downside is real** — a brand-bid-down where organic may or may not absorb the traffic, a budget shift whose incremental return is unproven, a new LP/creative. Do NOT wrap a genuinely safe, obvious change (adding a negative keyword to a 4,000% CoS junk term) in experiment ceremony — just do it. The test exists to _measure incrementality / causality you can't assume_, not to gate every edit.

## The flow

1. **Classify the experiment type.** Use the decision table in `reference/sop-cm-experiment.md` § "Experiment types". The paid-media types: **native draft-and-experiment** (A/B a campaign change with a built-in control split, e.g. Google Ads experiments), **geo holdout / lift** (hold a region dark, measure incremental conversions), **incrementality** (brand-bid-down, PSA/ghost-bid holdout — the "is this spend incremental?" test), **budget-split lift**, and **creative / LP A/B**. Pick by what you're testing and the traffic available.
2. **Write the hypothesis** in the `ab-test-setup` framework: _Because [data], we believe [change] will cause [outcome] for [audience]; we'll know it's true when [metric hits threshold]._
3. **Establish the baseline.** Pull the _real_ current numbers from the named measurement source (your ad-platform data source (Google Ads, Meta, etc.), Search Console performance, your web analytics (GA4, etc.), paid+organic search-term data — see the SOP § "Measurement sources"). Name the source + the window. Never leave a baseline as "—".
4. **Design.** Variant/holdout structure, allocation, **primary metric + secondary + a GUARDRAIL metric that must not get worse**, the MDE, and sample-size/duration (reuse `ab-test-setup` § "Sample Size"). Write the **pre-registered decision rule** ("ship if X ≥ Y at 95% over ≥ N; revert if guardrail drops > Z%").
5. **Guardrails + safety (Marketing Execution Protocol).** Declare the **spend cap**, the **revert trigger** (exact threshold + who reverts + how fast), the approval gate, and — for any paid change — the LP/tracking pre-flight. Pause/budget-zero/status-flip inside an experiment still obey the irreversible-op floor (per-action approval, never `Copilot auto`).
6. **Write the Experiment doc** as a **Google Doc in the flat `Compound Marketing` Drive folder** (via your marketing docs store — Google Drive, etc. / `/format-gdoc` — NOT repo markdown; per `reference/sop-cm-pipeline.md` § "Artifact naming convention"). Title **Type-first, broad→detailed**: `Experiment — <Channel / Topic> — <Client Display Name> — <YYYY-MM-DD>` (e.g. `Experiment — Google Ads Brand-Bid-Down — <Client> — 2026-07-02`). Template in the SOP, following an experiment-tracker format (Hypothesis → Mechanic → Baseline → Segments → Success Metrics + Guardrails → Decision Rule → Results → Implementation Notes). Render the design table inline for approval BEFORE anything goes live.
7. **Run + monitor.** Don't peek at significance and stop early. Weekly: check the guardrail; **revert immediately on a breach** (that's not "calling it early" — it's the safety trigger firing). Log dated Implementation Notes.
8. **Conclude + compound.** Read the result against the pre-registered rule (winner / loser / inconclusive). Fill Results, write the learning, and hand to `/cm-compound` so the pattern accrues to the CM memory.

## Output

A durable Experiment doc (never just a chat answer), design table rendered inline for approval, and — on conclusion — a Results block + a one-line reusable pattern for `/cm-compound`.

## Self-update directive

When a run surfaces a new experiment type, a measurement-source gotcha, a guardrail pattern, or a better doc structure — update `reference/sop-cm-experiment.md` (the heavy detail) or this file before finishing. The experiment practice compounds: each run sharpens the method.
