# SOP — Compound Marketing Execution Owner Map

> **Read first:** the channel→owner mapping the `/cm-review` ownership lens (`cm-lens-ownership`) and the `/cm-plan` planner use to assign and verify the **right executor** for each action. Extracted from the old inline ownership-lens mapping so new channels can be added without editing the agent prompt.
>
> **Used by:** `cm-lens-ownership` (resolves the correct owner per action), `/cm-plan` (assigns owners when sequencing), `/cm-execute` (maps owner → execution surface).

---

## How to use this map

For each action in a plan, identify its **action type**, look up the **owner** below, and confirm the named owner in the plan matches. If it doesn't, the action's owner is wrong — flag it (`verdict: "unsupported"`) with the correct owner.

The map is **channel-extensible**: as a new channel specialist is grown (the specialist-growth rule), add its action types + owner here rather than hardcoding them in the lens agent.

---

## The ownership concept

Every marketing action has exactly one **owner who can actually execute it** — the person, vendor, team, or automation that has the access and the mandate to make that specific change. An action assigned to an owner who can't perform it is a dead action: it looks planned but never ships. The ownership lens exists to catch that mismatch before a plan is approved.

So this map is **user-fillable**: you name, per channel + action type, WHO in your setup owns execution. Fill the template below with your own owners before relying on the ownership lens.

---

## Owner map (template — fill with YOUR owners)

Replace each `<placeholder owner>` with the concrete person / vendor / team / automation in your setup. Add or remove channels to match the channels you actually run.

| Channel                                        | Action type                                                  | Owner who can execute                                              |
| ---------------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------- |
| **Paid search (Google Ads, etc.)**             | Bid / budget / negative / pause / ad-status changes          | `<your paid-search owner/vendor>`                                 |
| **Paid search — analysis**                     | Account analysis, change-history audit, build-plan authoring | `<your internal analysis owner>`                                  |
| **Paid social (Meta Ads, etc.)**               | Campaign / ad-set / budget / creative changes                | `<your paid-social owner/vendor>`                                 |
| **Website / landing page**                     | URL / redirect / page / tracking-tag fixes                   | `<the client's website / dev owner>`                              |
| **Product feed / data pipeline**               | Feed rules, data sync, automation                            | `<your feed/automation owner>`                                    |
| **CRM**                                        | Workflow edits, pipeline config, contact ops                 | `<your CRM owner>`, or the client's CRM admin                     |
| **Email / lifecycle**                          | Sends, sequences, list hygiene                               | `<your email owner>`, else the client's email owner               |
| **Strategy / approval / budget authorization** | Any go/no-go, budget sign-off, new-campaign launch, pricing  | **The client** (or your internal decision-maker for internal calls) |

> **Automation-ladder cross-reference.** The owner determines WHO; the automation-ladder rung (owner-only / Copilot-w-approval / Fully-auto / Vendor) determines HOW autonomously. A vendor-owned action is never "fully-auto" from your side. See the Marketing Execution Protocol in `sop-cm-pipeline.md`.

---

## Adding a channel

When a new channel specialist is built (e.g. SEO, an email platform), append a row per action type here with the executor. Keep the lens agent untouched — it reads this map.

---

## Appendix — Red Pine reference mapping (example)

The concrete roster below is one team's (Red Pine Digital's) filled-in version of the template above — included purely as a worked example of what a completed map looks like. Do **not** use these owners; substitute your own in the template.

| Channel                                        | Action type                                                  | Owner who can execute                                                                 |
| ---------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| **Google Ads (paid search/shopping)**          | Bid / budget / negative / pause / ad-status changes          | **White Glove PPC / Affan** (vendor executes)                                         |
| **Google Ads**                                 | Account analysis, change-history audit, build-plan authoring | **Dharma / RPD** (internal prep)                                                      |
| **Meta Ads (paid social)**                     | Campaign / ad-set / budget / creative changes                | **White Glove PPC / Affan** if managed there; else **Dharma / RPD** per account setup |
| **Website / landing page**                     | URL / redirect / page / tracking-tag fixes                   | **The client's website / dev team**                                                   |
| **Product feed / data pipeline**               | Feed rules, data sync, automation                            | **Dharma / RPD automation**                                                           |
| **CRM / GHL**                                  | Workflow edits, pipeline config, contact ops                 | **RPD (GHL-MCP)**, or the client's GHL admin                                          |
| **Email / lifecycle**                          | Sends, sequences, list hygiene                               | **RPD** if managed; else the client's email owner                                     |
| **Strategy / approval / budget authorization** | Any go/no-go, budget sign-off, new-campaign launch, pricing  | **The client** (or **Bunty** for RPD-internal calls)                                  |
