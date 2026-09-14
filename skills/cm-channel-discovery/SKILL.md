---
name: cm-channel-discovery
description: "Use when a CM stage (most often /cm-audit Step 1, the success line) needs what good means for a client's channel: banded action thresholds (cutoff/maintain/scale) on a metric like CAC/CPA, ROAS/CoS, CPL, or revenue-per-send, plus a sustained-signal window before acting, and it isn't documented yet. Also use directly: what's our target CAC for X, set the success line for a channel, discover the success metric for a client. Channel-aware (SaaS asks CAC:LTV/CPA, ecom asks ROAS/CoS, email asks revenue-per-send, SEO asks traffic/ranking, CRO asks conversion lift) but one generic skill. Captures three bands, not one target, plus how many days or how much volume a metric must hold past a threshold before it's signal, not noise. Checks for an existing Client Context doc first. Writes a durable, non-dated doc to the flat Compound Marketing Drive folder so every future cycle reads it instead of re-asking. Companion to cm-audit the way cm-build-voice is a companion to cm-sound-like-me."
---

# /cm-channel-discovery — discover and persist a channel's success line

Every CM stage that forms an opinion about "is this good or bad" needs a success line — what defines good for this client on this channel, and how confidently to act on it. `/cm-audit` Step 1 names this requirement ("pull from client context, never assume a generic benchmark") but nothing in the pipeline actually gathers or persists it. This skill is that missing piece.

**A single target number is the wrong shape.** A real success line is a set of **action bands** on a metric — a cutoff below which you pull back, a maintain range where you hold spend, and a scale threshold above which you push more — plus a **sustained-signal window**: how long a metric has to sit past a threshold before it's a real signal to act, not a one-day blip. Scaling spend off a single good day is exactly the kind of premature call this skill exists to prevent.

Generic and workspace-agnostic: no hardcoded client names or channel assumptions baked in. What's channel-specific is the metric and the question shape (below), not the skill.

## Step 1 — Check for an existing Client Context doc first

Never re-interview a client/channel pair that already has an answer.

1. Search the flat **`Compound Marketing`** Drive folder for a doc titled `Client Context — <Channel> — <Client Display Name>` (create the folder if it genuinely doesn't exist yet — see `reference/sop-cm-pipeline.md` § Artifact naming convention for the folder-resolution mechanics; this skill uses the same folder, not a new one).
2. If found: read it, confirm with the user it's still current ("Last set <date>: cutoff <X>, maintain <X–Y>, scale <Z>, <N>-day window. Still right?"), and skip straight to Step 4 if they confirm as-is.
3. If not found, or the user says it's stale: proceed to Step 2.

## Step 2 — Ask the channel-appropriate question

Pick the metric that matches the channel's business model — don't ask a SaaS company for ROAS or an ecom store for CAC:LTV. For whichever metric fits, ask for **bands, not a target**, plus the sustained-signal window.

| Business model / channel shape | Metric | Ask for |
| --- | --- | --- |
| SaaS / subscription paid acquisition (Google Ads, Meta Ads) | Cost-per-trial and/or cost-per-paid-subscription | Cutoff (pull back above this), maintain range, scale threshold (push more below this); LTV or payback-period if known, to sanity-check the bands |
| Ecommerce paid acquisition | ROAS or CoS (cost of sale %) | Cutoff (kill spend below/above this ROAS/CoS), maintain range, scale threshold; whether blended or new-customer-only |
| Lead-gen (B2B, services) | Cost-per-lead (CPL) | Cutoff, maintain, scale bands on CPL; lead→close rate if known, so CPL maps to a real CAC |
| Email / lifecycle | Revenue-per-send | Cutoff/maintain/scale bands on revenue-per-send, plus the churn/bounce ceiling that defines "list health is fine" |
| SEO / organic | Traffic / ranking | Bands on the traffic or ranking movement that would trigger pulling investment vs. doubling down |
| CRO | Conversion rate | The current rate, and the cutoff/maintain/scale bands for a test result before rolling out, holding, or killing it |

**Always also ask: the sustained-signal window.** How many days (or what volume — e.g. "at least 20 trials") does the metric need to hold past a threshold before it's a real signal to act? This is not optional — a band with no window invites acting on noise. If the client isn't sure, propose a default (7 days is a reasonable starting point for daily-ish metrics) and confirm rather than silently picking one.

**If the user doesn't have bands:** that's a valid answer, not a blocker. Record it as "no hard bands — report the real metric and let the client/owner judge once they see it" and proceed. Do not manufacture generic industry-benchmark bands and present them as theirs — invented bands are worse than none, because they launder a made-up number into the audit as if it were the client's own bar.

**Intuition-based bands are a legitimate answer, not a lesser one.** Not every business runs on hard KPI math — some clients set bands by watching the number over time and improving it, not by deriving them from a formula. That's fine: record "set by experience/observation, not a formula" as the rationale and move on. Don't push for false formulaic precision a client isn't offering.

**Sanity-check against a formula ONLY as a cross-check, and mind the granularity mismatch.** A general formula (e.g., for SaaS: target CAC ≈ LTV ÷ 3, so target cost-per-trial ≈ target CAC × trial→paid conversion rate) is useful background, but LTV and conversion rate are frequently **channel-specific, not one company-wide blended number** — a customer acquired via one channel can convert or retain differently than one from another. If the client gives blended/company-wide figures, note that as a limitation rather than treating the formula's output as a precise cross-check on THIS channel's bands. When a formula-implied number and the client's stated bands disagree, ask once whether that's deliberate (stricter/looser on purpose), a sign the inputs weren't channel-specific, or the bands simply weren't formula-derived — then record whichever the client confirms, without forcing agreement.

## Step 3 — Confirm and capture rationale

Read the bands + window back along with the "why" (e.g. "cutoff $100/trial, scale at $30/trial, maintain in between, because LTV supports up to ~$100 CAC and $30 is where you're comfortable pushing harder; 3-day window because trial volume is high enough that 3 days is already a stable read"). One line of rationale is enough — this isn't a full economics model, just enough to know the bands weren't a guess.

## Step 4 — Write the Client Context doc

**Location:** `Client Context — <Channel> — <Client Display Name>` in the flat `Compound Marketing` Drive folder. **Non-dated, perpetual** — like `Learning — Decisions — <Client>`, this doc is overwritten/updated in place, not re-created per cycle, because "what does good mean" doesn't expire the way a dated audit snapshot does. Update it in place whenever the bands change; don't accumulate dated duplicates.

```
# Client Context — <Channel> — <Client Display Name>

## Success line
- **Metric:** <e.g. cost-per-trial>
- **Cutoff (pull back):** <threshold + direction, e.g. "≥ $100 — reduce/pause spend">
- **Maintain (hold):** <range, e.g. "$30–$100 — hold spend steady">
- **Scale (push more):** <threshold + direction, e.g. "≤ $30 — increase spend">
- **Sustained-signal window:** <e.g. "3 consecutive days" or "at least N trials, whichever is longer"> — a threshold crossed for less than this is noise, not a signal to act
- **Rationale:** <the one-line why — LTV, payback period, prior benchmark, or "no hard bands, report real metric" if that's what was chosen>
- **Set by:** <who confirmed it — the user's name>
- **Set on:** <YYYY-MM-DD>
- **Confidence:** <firm bands | working assumption | no hard bands>

## Secondary metrics (if the client named one, otherwise omit)
- <e.g. cost-per-paid-subscription — not independently banded, tracked as a lagging sanity-check on the primary metric above>

## Notes
- <anything else that shapes what "good" means for this client+channel — e.g. seasonality, a known blended-vs-new-customer distinction, a hard budget ceiling unrelated to efficiency>
```

Also add/update a one-line pointer in the folder's `CLAUDE.md` breadcrumb index if this is the first Client Context doc for this client — same convention `/cm-build-voice` and `/cm-compound` follow for their own index entries.

## Step 5 — Hand back to the calling stage

Report the resolved bands + window inline in chat, then return control to whatever invoked this skill (most often `/cm-audit` Step 1, which was blocked on exactly this). Do not proceed into audit/analysis work yourself — this skill's job ends at "the success line now exists and is written down." Downstream stages (`/cm-audit`, `/cm-analyze`) are the ones that check a live metric against these bands and the sustained-signal window before recommending a spend change — this skill only discovers and persists the bands, it doesn't apply them.

## Notes

- **One skill, not one per channel.** The channel-specific part is the metric + question table in Step 2, not a forked skill per channel — a new channel just adds a row.
- **Bands, not a target — this is load-bearing.** A single number invites a false-precision "hit the number, act" read. Three bands plus a sustained-signal window forces the downstream stage to ask both "which band is this in" and "has it been there long enough to mean anything" before recommending a spend change.
- **Distinct from `cm-build-voice`.** That skill discovers/persists HOW a client wants to sound; this one discovers/persists WHAT counts as working and how confidently to act on it. Same shape (interview → persist → downstream skill reads it), different subject.
- **Read by:** `/cm-audit` Step 1 (primary), and any other stage that needs to judge "good vs bad, and is it real" against real bands rather than assume one.
- **Gap this closes:** `/cm-audit` Step 1 named the success-line requirement but had no mechanism to discover or persist it, and an earlier draft of this skill still modeled it as a single target — collapsing "are we over/under the number" and "is this a real trend or one good/bad day" into one question. Bands + a sustained-signal window keep those two questions separate, which is what actually prevents a premature scale-up or panic-cutoff off noisy data.
