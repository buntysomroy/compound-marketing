---
name: cm-audit
description: "Use when you say '/cm-audit', 'audit the account', 'pull the data before analysis', 'gather client context', 'what data do we have on this client or channel?', 'show me the numbers', 'what's happening with their marketing', or as the first step of a full CM pipeline run. Compound Marketing — the AUDIT stage (Stage 1). Gather the real state of a client's marketing: pull live data, read client context + SOPs, and produce a structured audit doc that feeds /cm-analyze."
---

# /cm-audit — Compound Marketing: Audit stage

> **Where this sits.**
> **`/cm-audit` (this)** → `/cm-analyze` (Stage 2) → `/cm-plan` (Stage 3) → `/cm-review` (Stage 4) → `/cm-agent-plan` (Stage 5a) → `/cm-execute` (Stage 5b).
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the six contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging, open items) are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> Full pipeline reference: `reference/sop-cm-pipeline.md`

This is the **explore stage** — gather the real state before forming any opinions. The output is a structured audit doc; the insight stage reads it first before pulling live data again. No recommendations here. Findings only.

## Step 1 — Frame the engagement

Establish:

- **Client identifier** — maps to your client/account folder
- **Channel(s) in scope** — paid search, paid social, email/lifecycle, organic/SEO, CRO, full-funnel
- **Time horizon** — default last 30 days + trend over 90 days; adjust if recency matters (e.g., post-launch)
- **The success line** — what "good" means for this client (ROAS/CoS for ecom paid, CAC:LTV for SaaS, CPL for lead-gen, revenue-per-send for email). Pull from the `Client Context — <Channel> — <Client Display Name>` doc (see Step 2) — never assume a generic benchmark.

If the success line doesn't exist yet (no `Client Context` doc for this client+channel) or is stale, invoke **`/cm-channel-discovery`** to resolve and persist it before proceeding — don't ask an ad hoc question yourself and let the answer evaporate at session end. Any other framing gap (client identifier, channel, time horizon) still gets ONE outcome-framed question directly.

## Step 2 — Read client context (MANDATORY, before pulling live data)

Read in this order — stop when you have enough context; don't load everything blindly:

1. **Client Context doc:** read the project-designated current context document in project-local mode, or search shared Drive for `Client Context — <Channel> — <Client Display Name>`. Missing or stale → invoke `/cm-channel-discovery`, per Step 1.
2. **Client directory:** your client/account folder's routing doc (e.g. a `CLAUDE.md` or README at `clients/<slug>/`)
3. **Prior CM artifacts:** resolve the artifact workspace profile and search that workspace for this project's most recent Analysis/Plan artifacts. Continue the named stable run; do not merge local and shared histories implicitly.
4. **Channel-specific SOP:** your channel's audit SOP / account-intelligence doc, if you maintain one — e.g.:
   - Paid search: your Google Ads audit SOP + daily-analysis-questions reference
   - Paid social: your Meta Ads audit SOP (when it exists)
   - Email: email platform SOP (when it exists)
5. **Recent meeting context:** check the client/account folder for meeting notes or transcripts from the last 30 days that surface known issues or priorities.
6. **Account intelligence:** your paid-channel account-intelligence doc (account economics, CoS/ROAS breakeven) for paid channels.

## Step 3 — Pull live data by channel

Pull what's accessible from available tools. Note anything inaccessible as a gap.

**Google Ads / Meta Ads:**

- The performance dashboard sheet (via your spreadsheet/analytics tool) — most recent weeks + trend. Read full width; note provisional GA4 (or your web analytics platform) data (last 24–48h unprocessed).
- Your ad-platform data source (Google Ads, Meta, etc.) for live account data beyond the dashboard.
- Web analytics for conversion path + assisted conversion data (when accessible).

**Email / lifecycle:**

- Platform export or dashboard: open rates, click rates, revenue-per-send, list health (churn rate, bounce rate, unsubscribes).

**CRM (when in scope):**

- Your CRM tools for pipeline health, lead volume, stage conversion.

**Organic / SEO:**

- Google Search Console export or SERP sampling for top keywords, CTR, ranking distribution.

Note the data freshness and any gaps (e.g., "Meta ROAS unavailable — no ad-platform auth for this account").

## Step 4 — Structure the audit doc

Write a dated markdown doc — findings only, no recommendations yet:

**Location:** use the resolved artifact profile. Project-local: `CM Artifacts/<project-slug>-<run-id>-<YYYY-MM-DD>-audit.md`. Shared Drive: `Audit — <Channel> — <Client Display Name> — <YYYY-MM-DD>.docx`. Allocate the run ID once and reuse it downstream.

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

## Context from meetings / prior analysis
- <Key known issues from last meeting or prior CM doc>

## Open Items
[Contract Step 6 shape — every unresolved gap this audit couldn't close: a live tooling defect, missing data, an unreconciled discrepancy between sources, a capability gap. Omit this heading entirely, or write "None." under it, if the audit closed clean.]

- **OI-1** — <one-line description>
  - *Blocking:* yes/no
  - *Owner:* <tool/code fix | user decision | live-platform re-read | other>
  - *Closes when:* <concrete, testable condition>
  - *Status:* open
- **OI-2** — ...
```

Show the doc path in chat. Render the "What the data shows" summary inline (top 5 most significant findings, one line each) so you can see if the data is usable before the insight stage runs. Any finding tagged `⚠️ HYPOTHESIS` in "What the data shows" because of an unresolved gap should reference the Open Item by ID ("see OI-1") rather than restating the caveat inline.

## Step 5 — Resume mode (re-invoking `/cm-audit` to close open items)

`/cm-audit` is not only a fresh-start stage — it can be re-invoked scoped at a prior Audit doc's Open Items instead of running a full new audit. Recognize this mode when the invocation names a prior Audit doc, says "resume open items," or is itself the literal `` `/cm-audit — resume open items: "<doc title>"` `` command a handoff block emitted per the stage contract's Step 4.

In this mode:

1. Read the referenced Audit doc's Open Items section in full — this is the scope of work, not a fresh Step 1–3 pass over everything.
2. For each open item, do only the work its `Closes when` condition requires (verify a tool fix actually landed and re-call the affected tool; pull the one missing data point; reconcile the one flagged discrepancy against a live re-read). Do not silently re-run the full account pull from scratch — that duplicates work Step 3 already did and risks masking whether the SPECIFIC gap actually closed.
3. Write a new dated Audit artifact using the same resolved profile and stable run ID (same naming convention, new `<YYYY-MM-DD>`). Its Context section notes it resumes the prior artifact, and its own Open Items section marks each addressed item's `Status` as `closed (<date>, <one-line resolution>)`, carries forward anything still open, and adds any new items this pass surfaced. Do not edit the prior dated artifact in place — dated artifacts are immutable snapshots; the resume produces a new one that supersedes it for open-items purposes.
4. If closing an item surfaces new findings (e.g., a previously-blended metric can now be read cleanly), fold them into "What the data shows" as normal — this is still an audit doc, findings only, no recommendations.

## Step 6 — Hand off

If Step 5 (Resume mode) doesn't apply — this was a fresh audit — offer to proceed to `/cm-analyze` (Stage 2) with the audit doc as input, UNLESS the doc's own Open Items include a blocking item, in which case the handoff's first step is this stage's own resume command (per contract Step 4), not `/cm-analyze`. Surface any blockers (missing data, access gaps) that the next step should know about — by pointing at the Open Items section, not restating it.

## Close — session-wrap offer (R10)

If this session settled a durable marketing decision, produced a CM artifact the user reworked before approving, or surfaced a methodology learning worth carrying forward, offer `/cm-session-review` as the wrap step: "This session settled something worth capturing — run `/cm-session-review` to mine the learnings and close the CM loop."

## Self-update directive

When this run surfaces a new data source, a SOP gap, or a client context file that should exist but doesn't — note it in the audit doc's Open Items section and surface it as a Spotted Improvement for you to act on.
