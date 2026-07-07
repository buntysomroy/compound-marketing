---
name: cm-analyze
description: "Compound Marketing — the ANALYZE stage (Stage 2). Turn a marketing data set / account / channel into a small set of high-confidence, scored strategic insights (what's working, what's not, what to change, why), written to a deliverable doc. Sits after /cm-audit (Stage 1) and before /cm-plan (Stage 3) + /cm-review (Stage 4). Use when the user says '/cm-analyze', 'strategic insights', 'what's working/not', 'analyze the <channel/account> data', 'what should we change', or after an audit/data refresh. Reads the data first — never analyzes from generic knowledge."
---

# /cm-analyze — Compound Marketing: Analyze stage

> **Where this sits.** Compound Marketing mirrors Compound Engineering's "80% before building":
> `/cm-audit` (Stage 1) → **`/cm-analyze` (this, Stage 2)** → `/cm-plan` (Stage 3) → `/cm-review` (Stage 4) → `/cm-execute` (Stage 5). This skill converts _what is_ (audit + data) into _what to do and why_, as a durable doc the plan stage consumes.
>
> Full pipeline reference: `reference/sop-cm-pipeline.md`

CE roots this carries: **ground every claim in real observed data** (no platitudes), **adversarial honesty** (call out what's not working + the cost of inaction), **economics first**, **capture as a durable artifact** that compounds (the doc feeds the plan stage and the next analysis).

## Core principle

An insight with no cited number from the actual account/data is an opinion, not analysis. Every claim names the **metric, the value, and where it came from** (row / week / segment / source). Read the data first; reason from it.

## Step 1 — Frame the engagement

Establish, briefly:

- **Domain / channel** — paid ads (Google/Meta), SEO, email/lifecycle, CRO, content, social, full-funnel. This selects the framework + the specialist (Step 3).
- **The profitability / success line** — what "good" means for THIS client (ROAS / CoS for ecom paid; CAC:LTV; pipeline/CPL for lead-gen; open/click/revenue-per-send for email). Confirm from client context, never assume a generic benchmark.
- **Inputs available** — the audit output (`/cm-audit` if it ran), the live data source, and the grounding docs (Step 2).

If the domain or success line is genuinely unclear, ask ONE outcome-framed question, then proceed.

## Step 2 — Read the data + ground in methodology (MANDATORY, before any conclusion)

1. **Pull the actual numbers.** Read the real source — the performance dashboard sheet (via your spreadsheet/analytics tool), your ad-platform data source (Google Ads, Meta, etc.), your web analytics (GA4, etc.), the analytics export, the email platform. Trust live cells over any stale dump; sample the boundary between recent and old data. Note provisional data (web analytics last 24–48h unprocessed; platform retention limits; double-counted conversions).
2. **Ground in your own methodology + client context** — read your channel's audit SOP / account-intelligence doc (e.g. a daily-analysis-questions framework, a channel audit SOP, and account economics / conversion-discrepancy / LP-audit gate notes) rather than reasoning from generic best practice. For other channels: the matching SOP + your client/account folder audits + recent meeting context. Cite them; don't paraphrase from memory.
3. **Delegate the deep channel read when your workspace has a specialist agent.** These channel specialists are **not bundled with this plugin** — if your workspace provides one (e.g. a Google Ads analyst, a Meta Ads analyst), dispatch it (it reads the performance dashboard + live ad-platform/web-analytics data and returns a scored read). If none exists, do the channel-specific dig inline in this skill. Either way this skill orchestrates + writes the doc. Add specialists per channel over time (the compounding move).

## Step 3 — Build the insights

Work the framework relevant to the domain (for paid search/shopping, a 10-category audit: Spend Health, Conversion Performance, Traffic Quality, Impression Share, Bidding, Ad Quality, Account Structure, Negatives, Vendor Activity, Business Context). Keep to the **highest-leverage findings** — a tight prioritized read beats an exhaustive dump.

Each recommendation is scored on three axes:

- **Impact** Low / Medium / High
- **Effort** Very Low (<5min) / Low (<15min) / Medium (<1h) / High (>1h)
- **Ownership / Automation Ladder** — who acts: **You / the operator** (strategic call) · **Copilot w/ approval** (executes with sign-off) · **Fully automated** (autonomous, safe) · **Vendor** (the ad vendor executes). Adapt the rung labels to the engagement.
- **Why** — reasoning tied to the data + the success line, not the generic rule.

## Step 4 — Write the deliverable doc

Write a dated markdown doc (ce-plan-style — a durable artifact, not just chat):

- **Location:** a doc in your marketing docs store (Google Drive, etc.), titled `Analysis — <Channel> — <Client Display Name> — <YYYY-MM-DD>` (create via your docs/markdown tooling). See `reference/sop-cm-pipeline.md` § Artifact naming convention.
- **Structure:**
  1. **Header** — account/scope, period, success line, sources (sheet IDs, SOPs, meeting docs), prepared-by + date.
  2. **Bottom line** — 2–3 sentences: healthy vs the success line? trending which way?
  3. **What's working** — 2–4 points, each with the number + why.
  4. **What's not** — 2–4 points, each with number + root cause + cost of inaction.
  5. **What to change** — scored table (Impact / Effort / Ownership / Why).
  6. **Watch-outs / data caveats** — provisional numbers, gates (e.g. LP-audit before any pause), tracking discrepancies, anything unverified.
- Render numbers cleanly (resolve IDs to names; show CoS as % with its ROAS twin). State the **framing** (internal "we found + fixed" prep vs client-facing — paid-vendor analysis is internal, never blame the ad vendor).

Confirm the doc path in chat and render the bottom line + the "what to change" table inline so you can act without opening the file.

## Step 5 — Hand off

The doc is the input to `/cm-plan`. Surface the single highest-leverage recommendation as the suggested next move, and offer to proceed to the plan stage.

## Self-update directive

Compound Marketing compounds: when this run surfaces a reusable framework, a new channel specialist worth building, or a scoring rubric tweak, update this file (or propose the new specialist agent) before finishing — don't let the learning evaporate. As `/cm-audit`, `/cm-plan`, `/cm-review`, and `/cm-execute` come online, keep the hand-off pointers here accurate.
