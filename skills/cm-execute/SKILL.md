---
name: cm-execute
description: "Compound Marketing — the EXECUTE stage (Stage 5, execution bridge / build-prep). Map every approved plan action to its execution surface (your ad-platform data source / CRM tool / browser automation / a human owner), add spend cap + pre-flight checklist + approval gate, and produce a build plan doc ready for execution. Use when Bunty says '/cm-execute', 'build the execution plan', 'how do we actually do this', 'map the plan to tools', 'ready to execute', or after /cm-review approves the marketing plan."
---

# /cm-execute — Compound Marketing: Execute stage (execution bridge / build-prep)

> **Where this sits.**
> `/cm-audit` (Stage 1) → `/cm-analyze` (Stage 2) → `/cm-plan` (Stage 3) → `/cm-review` (Stage 4) → **`/cm-execute` (this)**.
>
> Full pipeline reference: `reference/sop-cm-pipeline.md`
>
> **Companion:** to actually RUN a plan action as a **measured experiment** under this execution protocol (same spend-cap / revert-trigger / approval / irreversible-op-floor gates), use `/cm-experiment` (`reference/sop-cm-experiment.md`).

This is the **execution bridge** — the marketing analogue of the EA Protocol + pre-flight gate. Stage 5 answers "HOW will Claude or a human actually do this?" It does NOT execute anything. It maps the plan to surfaces, adds guardrails, and waits for explicit Bunty approval before execution begins.

## Core safety rules (non-negotiable)

1. **No auto-execution.** Every build plan ends at an `AskUserQuestion` approval gate. Bunty decides; Claude prepares.
2. **Spend cap is required.** Every build plan must declare `MAX_SPEND_CHANGE`. Any execution action that would exceed it is blocked until Bunty upgrades the cap explicitly.
3. **Pre-flight before any paid change.** LP audit + tracking verify before any campaign pause, bid change, or budget reallocation — sourced from your channel's audit SOP / account-intelligence doc § LP audit. For non-paid channels: equivalent pre-flight (list health for email, crawl check for SEO).
4. **Audit trail.** The build plan doc is written and persisted before any execution begins. Every execution references back to it.
5. **Irreversible-op floor (overrides spend gate).** Pause, delete, budget-zero, and status-flip actions on campaigns, ad groups, or ads are **never `Copilot auto`** — they require individual per-action `AskUserQuestion` approval even when the spend delta is $0. The `APPROVAL_REQUIRED_ABOVE $X` threshold governs budget movements only; structural/irreversible ops are always `Copilot + approval`. No exceptions. **Credential note:** all ad-platform data source calls (your ad-platform data source — Google Ads, Meta, etc.) execute inside the client's authenticated ad-account session brokered by the MCP server — browser-automation actions must run inside an already-authenticated browser window and must never accept, store, or echo raw credentials. If the current session does not have confirmed client-account access, stop and surface as `🔴 BUNTY — ACTION REQUIRED` before proceeding.

## Step 1 — Read the approved plan

**Required input:** the approved `<Client> — Plan — <Channel> — <date>` Google Doc in the flat `Compound Marketing` Drive folder (search your marketing docs store — Google Drive, etc.), with the Lens Review Summary appended (Stage 4 output).

Also read:

- your client/account folder's execution notes — execution constraints, vendor scope, authority boundaries
- your channel's audit SOP / account-intelligence doc — for paid search surface details
- your autonomy-ladder / automation-ladder doc — the autonomy ladder tiers

## Step 2 — Map every action to its execution surface

For each action in the approved plan's Action table, determine:

**Surface options:**

| Surface                         | When to use                                                                                            | Auth / tool                                                        |
| ------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| **Ad-platform — search**        | Campaign/ad/bid/budget changes in your search ad platform                                              | your ad-platform data source (Google Ads, etc.); requires ad-account auth |
| **Ad-platform — social**        | Campaign/ad/budget changes in your social ad platform                                                  | your ad-platform data source (Meta, etc.); requires ad-account auth |
| **CRM tool**                    | CRM updates, workflow edits, contact management                                                        | your CRM / marketing-automation tool                              |
| **Email / Calendar**            | Client comms, meeting scheduling                                                                       | your email / calendar tools                                       |
| **Browser automation**          | Platforms with no API — LinkedIn organic, manual creative ops in social creative hubs, platform UIs    | your browser-automation tool                                      |
| **Human owner (e.g. Bunty)**    | Strategic calls above threshold: budget reallocation above cap, new campaign launch, pricing decisions | `🔴 BUNTY — ACTION REQUIRED` block                                |

**For each action, specify:**

- The exact tool or method
- Pre-conditions (auth required, pre-flight, approval)
- The MCP tool call or Chrome action sequence (enough detail that a follow-up execution session can act without re-planning)
- Verification step (how we confirm it worked post-execution)

## Step 3 — Build the pre-flight checklist

For **paid ads actions** — run through this before any campaign change:

- [ ] Landing page(s) for affected campaigns are live and loading
- [ ] Primary conversion tag fires on the LP (verified via your web analytics (GA4, etc.) debug or platform pixel helper)
- [ ] No tracking discrepancies above 20% between platform and web analytics for the affected campaigns
- [ ] Bid strategy is not in a learning phase (if so, note the lockout window)
- [ ] Negative keywords list is current (no brand terms missing)

For **email actions:**

- [ ] Unsubscribe flow is functional
- [ ] List health: bounce rate < 2%, spam rate < 0.08%
- [ ] Test send reviewed (rendering + links)

For **CRM actions:**

- [ ] Workflow has a test contact run completed
- [ ] No live automations will be disrupted by the change

Add channel-specific items from the relevant SOP.

## Step 4 — Declare the spend cap

Calculate the total budget impact of all paid actions in the plan. Then:

```
MAX_SPEND_CHANGE: $X (or Y% of weekly budget)
CURRENT_WEEKLY_SPEND: $X
PLANNED_CHANGE: +/-$X (+/-Y%)
APPROVAL_REQUIRED_ABOVE: $X (threshold for explicit Bunty sign-off per action)
```

Any single action that would move spend by more than `APPROVAL_REQUIRED_ABOVE` is tagged as a Bunty action regardless of its automation-ladder rating.

## Step 5 — Write the build plan doc

**Location:** a Google Doc in the flat `Compound Marketing` Drive folder, titled `Build Plan — <Channel> — <Client Display Name> — <YYYY-MM-DD>` (create in your marketing docs store — Google Drive, etc. / `/format-gdoc`). See `reference/sop-cm-pipeline.md` § Artifact naming convention.

**Structure:**

```markdown
# <Client> — <Channel> Build Plan — <YYYY-MM-DD>

## Source

- Approved plan: [link to Stage 3/4 plan doc]
- Approved by: [date + any notes from approval gate]

## Spend cap

- MAX_SPEND_CHANGE: $X
- Approval threshold per action: $X
- Current weekly spend: $X

## Pre-flight checklist

[Channel-specific pre-flight from Step 3]

## Execution sequence

| #   | Action                         | Surface              | Tool / Method                                             | Pre-condition       | Verification                              | Owner              |
| --- | ------------------------------ | -------------------- | -------------------------------------------------------- | ------------------- | ----------------------------------------- | ------------------ |
| 1   | Increase max CPC on [campaign] | Ad-platform — search | update campaign bid (campaign_id=X, max_cpc=Y)           | LP live + tag fires | Check platform CPC + impressions next day | Copilot + approval |
| 2   | Pause [underperforming ad]     | Ad-platform — search | update ad status (ad_id=X, status=PAUSED)                | Pre-flight complete | Confirm status in platform                | Copilot + approval |
| ... | ...                            | ...                  | ...                                                      | ...                 | ...                                       | ...                |

## Bunty actions required

[Actions tagged as Bunty in the execution sequence, with the exact steps]

## Execution notes

[Any sequencing constraints, timing windows, platform considerations]
```

Show the doc path in chat. Render the Execution sequence table inline.

## Step 6 — Approval gate (non-negotiable)

After showing the build plan, present `AskUserQuestion`:

- **Approve — begin execution** (Copilot will run the Copilot-auto and Copilot+approval actions in sequence; Bunty action items will be surfaced as required)
- **Modify the build plan** — adjust scope, surface, or spend cap before starting
- **Cancel** — do not execute; return to planning

On Approve: begin the Copilot-auto actions immediately — **excluding any pause, delete, budget-zero, or status-flip ops, which are always `Copilot + approval` regardless of how they are labeled in the plan (safety rule 5).** Surface each Copilot+approval action as a separate `AskUserQuestion` before executing. Tag Bunty actions as `🔴 BUNTY — ACTION REQUIRED` blocks.

On Cancel or Modify: do NOT execute anything. Update the build plan doc and re-present.

## Self-update directive

When this run surfaces a new execution surface, a missing pre-flight step, or a recurring authorization pattern — update this file before finishing.
