---
name: cm-audit
description: "Compound Marketing — the AUDIT stage (Stage 1). Gather the real state of a client's marketing: pull live data, read client context + SOPs, and produce a structured audit doc that feeds /cm-analyze. Use when the user says '/cm-audit', 'audit the account', 'pull the data before analysis', 'gather client context', 'what data do we have on <client/channel>?', or as the first step of a full CM pipeline run."
---

# /cm-audit — Compound Marketing: Audit stage

> **Where this sits.**
> **`/cm-audit` (this)** → `/cm-analyze` (Stage 2) → `/cm-plan` (Stage 3) → `/cm-review` (Stage 4) → `/cm-execute` (Stage 5).
>
> Full pipeline reference: `reference/sop-cm-pipeline.md`

This is the **explore stage** — gather the real state before forming any opinions. The output is a structured audit doc; the insight stage reads it first before pulling live data again. No recommendations here. Findings only.

## Step 1 — Frame the engagement

Establish:

- **Client slug** — maps to your client/account folder
- **Channel(s) in scope** — paid search, paid social, email/lifecycle, organic/SEO, CRO, full-funnel
- **Time horizon** — default last 30 days + trend over 90 days; adjust if recency matters (e.g., post-launch)
- **The success line** — what "good" means for this client (ROAS/CoS for ecom paid, CAC:LTV for SaaS, CPL for lead-gen, revenue-per-send for email). Pull from client context, never assume a generic benchmark.

If any of these is unclear after reading client context in Step 2, ask ONE outcome-framed question, then proceed.

## Step 2 — Read client context (MANDATORY, before pulling live data)

Read in this order — stop when you have enough context; don't load everything blindly:

1. **Client directory:** your client/account folder's routing/context doc (e.g. a `CLAUDE.md` or index) — read/search your marketing docs store (Google Drive, etc.)
2. **Prior CM artifacts:** search your marketing docs store (Google Drive, etc.) for this client's most recent `Analysis` / `Plan` docs to understand what was already found. This is the compounding read-back.
3. **Channel-specific SOP:** read your channel's audit SOP / account-intelligence doc for the channel(s) in scope (paid search, paid social, email, etc.) rather than reasoning from generic best practice.
4. **Recent meeting context:** check your client/account folder for meeting notes or transcripts from the last 30 days that surface known issues or priorities.
5. **Account intelligence:** your channel's account-intelligence doc (§ account economics, CoS/ROAS breakeven) for paid channels.

## Step 3 — Pull live data by channel

Pull what's accessible from available tools. Note anything inaccessible as a gap.

**Paid ads (Google Ads, Meta, etc.):**

- The performance dashboard sheet (via your spreadsheet/analytics tool) — most recent weeks + trend. Read full width; note provisional web analytics data (GA4, etc.; last 24–48h unprocessed).
- Your ad-platform data source (Google Ads, Meta, etc.) for live account data beyond the dashboard.
- Your web analytics for conversion path + assisted conversion data (when accessible).

**Email / lifecycle:**

- Platform export or dashboard: open rates, click rates, revenue-per-send, list health (churn rate, bounce rate, unsubscribes).

**CRM (when in scope):**

- Your CRM's pipeline/contacts data for pipeline health, lead volume, stage conversion.

**Organic / SEO:**

- Google Search Console export or SERP sampling for top keywords, CTR, ranking distribution.

Note the data freshness and any gaps (e.g., "Meta ROAS unavailable — no ad-platform Meta auth for this account").

## Step 4 — Structure the audit doc

Write a dated markdown doc — findings only, no recommendations yet:

**Location:** a doc in your marketing docs store (Google Drive, etc.), titled `Audit — <Channel> — <Client Display Name> — <YYYY-MM-DD>` (create via your docs/markdown tooling). See `reference/sop-cm-pipeline.md` § Artifact naming convention.

**Structure:**

```
# <Client> — <Channel> Audit — <YYYY-MM-DD>

## Context
- Success line: <metric + target>
- Period: <date range>
- Sources: <sheet ID / platform / SOP refs>
- Prior CM cycle: <link to last analysis doc if any>

## What the data shows
[By channel/category — numbers with source citations, no narrative spin]

### [Category 1 — e.g., Spend Health]
- <metric>: <value> (<source>)
- ...

### [Category 2 — e.g., Conversion Performance]
- ...

## Gaps + data quality
- <What's missing or provisional>
- <Discrepancies between sources (e.g., web analytics vs platform conversions)>

## Context from meetings / prior analysis
- <Key known issues from last meeting or prior CM doc>
```

Show the doc path in chat. Render the "What the data shows" summary inline (top 5 most significant findings, one line each) so you can see if the data is usable before the insight stage runs.

## Step 5 — Hand off

Offer to proceed to `/cm-analyze` (Stage 2) with the audit doc as input. Surface any blockers (missing data, access gaps) that the insight stage should know about.

## Self-update directive

When this run surfaces a new data source, a SOP gap, or a client context file that should exist but doesn't — note it in the audit doc under Gaps and surface it as a Spotted Improvement for you to act on.
