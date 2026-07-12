# SOP — Compound Marketing Execution Owner Map

> **Read first:** the channel→owner mapping the `/cm-review` ownership lens (`cm-lens-ownership`) and the `/cm-plan` planner use to assign and verify the **right executor** for each action. Extracted from the old inline ownership-lens mapping so new channels can be added without editing the agent prompt.
>
> **Used by:** `cm-lens-ownership` (resolves the correct owner per action), `/cm-plan` (assigns owners when sequencing), `/cm-execute` (maps owner → execution surface).

---

## How to use this map

For each action in a plan, identify its **action type**, look up the **owner** below, and confirm the named owner in the plan matches. If it doesn't, the action's owner is wrong — flag it (`verdict: "unsupported"`) with the correct owner.

The map is **channel-extensible**: as a new channel specialist is grown (the specialist-growth rule), add its action types + owner here rather than hardcoding them in the lens agent.

---

## Owner map (by channel + action type)

**Fill in the Owner column with your own roster before using this map.** The rows below are placeholders — replace each `<...>` token with the actual person, team, or vendor who executes that action type for your agency/business.

| Channel                                        | Action type                                                   | Owner who can execute                                                                                                        |
| ----------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Google Ads (paid search/shopping)**          | Bid / budget / negative / pause / ad-status changes          | **`<your PPC vendor / agency team>`** (vendor executes)                                                                       |
| **Google Ads**                                 | Account analysis, change-history audit, build-plan authoring | **`<your internal ads specialist / agent>`** (internal prep)                                                                  |
| **Meta Ads (paid social)**                     | Campaign / ad-set / budget / creative changes                | **`<your PPC vendor / agency team>`** if managed there; else **`<your internal ads specialist / agent>`** per account setup |
| **Website / landing page**                     | URL / redirect / page / tracking-tag fixes                   | **`<the client's website / dev team>`**                                                                                       |
| **Product feed / data pipeline**               | Feed rules, data sync, automation                            | **`<your automation/data-pipeline owner>`**                                                                                   |
| **CRM / GHL**                                  | Workflow edits, pipeline config, contact ops                 | **`<your CRM/marketing-automation owner>`**, or the client's CRM admin                                                        |
| **Email / lifecycle**                          | Sends, sequences, list hygiene                               | **`<your team>`** if managed; else the client's email owner                                                                   |
| **Strategy / approval / budget authorization** | Any go/no-go, budget sign-off, new-campaign launch, pricing  | **`<the client>`** (or **`<the agency's decision-maker>`** for internal calls)                                                |

> **Automation-ladder cross-reference.** The owner determines WHO; the automation-ladder rung (Human / Copilot-w-approval / Fully-auto / Vendor) determines HOW autonomously. A vendor-owned action is never "fully-auto" from your side. See the Marketing Execution Protocol in `reference/sop-cm-pipeline.md`.

---

## Adding a channel

When a new channel specialist is built (e.g. SEO, an email platform), append a row per action type here with the executor. Keep the lens agent untouched — it reads this map.

## Provenance

This map exists so the `/cm-review` ownership-lens agent doesn't hardcode owners inline — it reads this file instead, so a new channel or a changed roster can be added here without editing the agent prompt.

---

## Appendix — Red Pine reference mapping (example)

This is the actual mapping used internally at Red Pine — for reference, not prescriptive. It shows what a filled-in Owner map looks like in practice.

| Channel                                        | Action type                                                   | Owner who can execute                                                                 |
| ---------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| **Google Ads (paid search/shopping)**          | Bid / budget / negative / pause / ad-status changes          | **White Glove PPC / Affan** (vendor executes)                                         |
| **Google Ads**                                 | Account analysis, change-history audit, build-plan authoring | **Dharma / RPD** (internal prep)                                                      |
| **Meta Ads (paid social)**                     | Campaign / ad-set / budget / creative changes                | **White Glove PPC / Affan** if managed there; else **Dharma / RPD** per account setup |
| **Website / landing page**                     | URL / redirect / page / tracking-tag fixes                   | **The client's website / dev team**                                                   |
| **Product feed / data pipeline**               | Feed rules, data sync, automation                            | **Dharma / RPD automation**                                                           |
| **CRM / GHL**                                  | Workflow edits, pipeline config, contact ops                 | **RPD (GHL-MCP)**, or the client's GHL admin                                          |
| **Email / lifecycle**                          | Sends, sequences, list hygiene                               | **RPD** if managed; else the client's email owner                                     |
| **Strategy / approval / budget authorization** | Any go/no-go, budget sign-off, new-campaign launch, pricing  | **The client** (or **Bunty** for RPD-internal calls)                                  |

Extracted 2026-06-24 from the inline owner mapping that previously lived inside the `/cm-review` ownership-lens agent (the ad-vendor/website-team/ad-platform/client mapping), as part of the Compound Marketing merge that folded the single-problem solution flow into `/cm-plan`. The lens now reads this map instead of hardcoding Google-Ads-only owners.
