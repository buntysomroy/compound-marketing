---
name: cm-channel-discovery
description: "Use when a CM stage (most often /cm-audit's Step 1, 'the success line') needs 'what good means' for a client's channel — a target CAC/CPA, ROAS/CoS breakeven, CPL, revenue-per-send, or traffic/conversion target — and it isn't already documented. Also use directly: 'what's our target CAC for X', 'set the success line for <channel>', 'discover the success metric for <client>'. Channel-aware (paid-acquisition SaaS asks CAC:LTV/CPA; ecom asks ROAS/CoS; email asks revenue-per-send; SEO asks traffic/ranking targets; CRO asks conversion-rate lift) but one generic skill, not one per channel. Checks for an existing Client Context doc first — never re-interviews a client that's already answered this. Writes a durable, non-dated Client Context doc to the flat `Compound Marketing` Drive folder so every future CM cycle for this client+channel reads it instead of re-asking. Companion to cm-audit the way cm-build-voice is a companion to cm-sound-like-me: a setup/discovery skill, not a pipeline stage of its own."
---

# /cm-channel-discovery — discover and persist a channel's success line

Every CM stage that forms an opinion about "is this good or bad" needs a success line — the metric + target that defines good for this client on this channel. `/cm-audit` Step 1 names this requirement ("pull from client context, never assume a generic benchmark") but nothing in the pipeline actually gathers or persists it. This skill is that missing piece: a short, channel-aware interview that resolves the success line once and writes it durably, so it's read-back forever after instead of re-asked every cycle.

Generic and workspace-agnostic: no hardcoded client names or channel assumptions baked in. What's channel-specific is the QUESTION shape (below), not the skill.

## Step 1 — Check for an existing Client Context doc first

Never re-interview a client/channel pair that already has an answer.

1. Search the flat **`Compound Marketing`** Drive folder for a doc titled `Client Context — <Channel> — <Client Display Name>` (create the folder if it genuinely doesn't exist yet — see `reference/sop-cm-pipeline.md` § Artifact naming convention for the folder-resolution mechanics; this skill uses the same folder, not a new one).
2. If found: read it, confirm with the user it's still current ("Last set <date>: <target>. Still the right number?"), and skip straight to Step 4 if they confirm as-is.
3. If not found, or the user says it's stale: proceed to Step 2.

## Step 2 — Ask the channel-appropriate question

Pick the question shape that matches the channel's business model — don't ask a SaaS company for ROAS or an ecom store for CAC:LTV.

| Business model / channel shape | What "good" means | Ask for |
| --- | --- | --- |
| SaaS / subscription paid acquisition (Google Ads, Meta Ads) | Efficient CAC against LTV | Target cost-per-trial and/or cost-per-paid-subscription; LTV or payback-period if known, to sanity-check the target rather than take it on faith |
| Ecommerce paid acquisition | Profitable spend | Target ROAS or CoS (cost of sale %) breakeven, and whether that's blended or new-customer-only |
| Lead-gen (B2B, services) | Efficient qualified pipeline | Target cost-per-lead (CPL) and, if known, lead→close rate so CPL maps to a real CAC |
| Email / lifecycle | Revenue-generating sends, healthy list | Target revenue-per-send, and the churn/bounce ceiling that defines "list health is fine" |
| SEO / organic | Traffic that converts | Target ranking/traffic goal for priority terms, and the on-site conversion rate that makes traffic worth having |
| CRO | Conversion lift | The specific page/flow conversion rate today and the lift that would be worth shipping for |

**If the user doesn't have a number:** that's a valid answer, not a blocker. Record it as "no hard target — report the real metric and let the client/owner judge once they see it" and proceed. Do not manufacture a generic industry benchmark and present it as theirs — an invented target is worse than no target, because it launders a made-up number into the audit as if it were the client's own bar.

**Sanity-check, don't just transcribe.** If a target implies uneconomical unit economics on its face (e.g. a target CPA well above any plausible LTV for the stated price point), say so and ask them to confirm before writing it down — the same spirit as the stage contract's "client estimates are hypotheses" rule (`reference/protocol-cm-stage-contract.md` Step 2).

## Step 3 — Confirm and capture rationale

Read the target back along with the "why" (e.g. "under $150 per paid subscription because LTV is ~$450 and you want 3:1"). One line is enough — this isn't a full economics model, just enough to know the target wasn't a guess.

## Step 4 — Write the Client Context doc

**Location:** `Client Context — <Channel> — <Client Display Name>` in the flat `Compound Marketing` Drive folder. **Non-dated, perpetual** — like `Learning — Decisions — <Client>`, this doc is overwritten/updated in place, not re-created per cycle, because "what does good mean" doesn't expire the way a dated audit snapshot does. Update it in place whenever the target changes; don't accumulate dated duplicates.

```
# Client Context — <Channel> — <Client Display Name>

## Success line
- **Metric(s):** <e.g. cost-per-trial, cost-per-paid-subscription>
- **Target:** <the number(s)>
- **Rationale:** <the one-line why — LTV, payback period, prior benchmark, or "no hard target, report real metric" if that's what was chosen>
- **Set by:** <who confirmed it — the user's name>
- **Set on:** <YYYY-MM-DD>
- **Confidence:** <firm target | working assumption | no hard target>

## Notes
- <anything else that shapes what "good" means for this client+channel — e.g. seasonality, a known blended-vs-new-customer distinction, a hard budget ceiling unrelated to efficiency>
```

Also add/update a one-line pointer in the folder's `CLAUDE.md` breadcrumb index if this is the first Client Context doc for this client — same convention `/cm-build-voice` and `/cm-compound` follow for their own index entries.

## Step 5 — Hand back to the calling stage

Report the resolved success line inline in chat, then return control to whatever invoked this skill (most often `/cm-audit` Step 1, which was blocked on exactly this). Do not proceed into audit/analysis work yourself — this skill's job ends at "the success line now exists and is written down."

## Notes

- **One skill, not one per channel.** The channel-specific part is the question table in Step 2, not a forked skill per channel — a new channel just adds a row.
- **Distinct from `cm-build-voice`.** That skill discovers/persists HOW a client wants to sound; this one discovers/persists WHAT counts as working. Same shape (interview → persist → downstream skill reads it), different subject.
- **Read by:** `/cm-audit` Step 1 (primary), and any other stage that needs to judge "good vs bad" against a real target rather than assume one.
- **Gap this closes:** `/cm-audit` Step 1 named the success-line requirement but had no mechanism to discover or persist it — every audit either invented a generic benchmark or asked ad hoc and lost the answer at session end. This skill is that missing mechanism, generalized across channels rather than built one-off for a single engagement.
