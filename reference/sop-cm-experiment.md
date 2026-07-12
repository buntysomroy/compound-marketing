# SOP — Compound Marketing: Experiment companion play (`/cm-experiment`)

> **Agent-facing reference for the `/cm-experiment` skill.** The skill (`.claude/skills/cm-experiment/SKILL.md`) is the thin entry point; this doc is the methodology, the experiment-type decision table, the measurement-source map, the safety model, and the Experiment-doc template. Read this when running or authoring a marketing experiment.
>
> **Reuses, does not duplicate:** statistical rigor (hypothesis framework, sample size, MDE, the peeking problem, ICE) lives in `.claude/skills/ab-test-setup/SKILL.md`. This SOP adds the **paid-media / PPC** layer that `ab-test-setup` (web-CRO-oriented) lacks, plus the CM safety model.

## Where it fits

Not a numbered CM stage. A **companion play** (like `/sales-letter`) invoked when a `/cm-plan` action is a _measured test_ rather than a direct change, or from `/cm-execute` to run that test under the Marketing Execution Protocol (`reference/sop-cm-pipeline.md` § "Marketing Execution Protocol"). Its output — an **Experiment doc** — feeds `/cm-compound` so proven/failed patterns accrue to CM memory.

## Core discipline (non-negotiable)

1. **Pre-register the decision rule, the guardrail, and the revert trigger BEFORE the test goes live.** Write them into the doc first. An experiment without all three is an unmonitored change.
2. **Don't peek and stop early on the primary metric.** Reaching significance early and stopping inflates false positives (`ab-test-setup` § "The Peeking Problem"). The _only_ thing that stops a test early is a **guardrail breach** — that's the safety trigger, not calling a winner.
3. **The doc is the deliverable, written up front.** Never run a test whose design lives only in chat.
4. **Baseline from real data, named source + window.** Never leave a baseline cell as "—" at launch.
5. **Measure incrementality/causality you can't assume — not every edit.** A safe obvious change (negative a 4,000% CoS junk term) is just done. The experiment is for reversible-but-uncertain moves with real downside (brand-bid-down, budget shifts, new creative/LP).

## Experiment types — pick by what you're testing

| Type                                              | What it isolates                                                        | Mechanic                                                                                                              | When                                                               | Traffic / time                                                 | Gotchas                                                                                                                                               |
| ------------------------------------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Creative / LP A/B**                             | A page/ad/creative change's effect on CVR                               | Split traffic (Google Ads ad variations, or LP split via the platform/CMS), single variable                           | Message match, headline, offer, layout                             | Moderate; 200+ conv/variant or `ab-test-setup` sample size     | Message-match/flicker; one variable only (a dynamic-keyword-insertion (DKI) test is a common reference format for this type)                                                               |
| **Google Ads native draft-and-experiment**        | A campaign-level change (bid strategy, structure) vs a built-in control | Google Ads "Experiments" → draft the change, run a % traffic split against the original                               | tROAS target change, bid-strategy swap, structure test             | Enough conv for the campaign to exit learning                  | Learning-phase lockout; needs sufficient conv volume; runs inside the account (the PPC vendor/team of record executes)                                                        |
| **Geo holdout / lift**                            | Incremental effect of _running ads at all_ in a region                  | Hold a matched geo dark (or PSA), compare converted outcomes vs an active matched geo                                 | "Is this spend incremental?" at regional scale                     | High; weeks; needs matched geos                                | Geo matching is hard; needs scale most SMB accounts lack                                                                                              |
| **Incrementality — brand-bid-down / PSA / ghost** | Whether _paid_ spend on a term is incremental over organic              | Reduce/pause the paid bid on the term for a window; measure whether **combined paid+organic** conversions/clicks hold | Brand-defense spend, any "does organic already own this?" question | Low-to-moderate; 2–4 wks; small spend OK for a time-based read | You need an organic baseline + source (GSC/paid_organic); competitor can bid the vacated auction (a real confound — watch combined, not just organic) |
| **Budget-split lift**                             | Incremental return of _more_ budget on a campaign                       | Step budget up (or down) by a set %, measure marginal CPA/ROAS at the new level vs baseline                           | "Does scaling this convert efficiently?"                           | Moderate; 2–3 wks                                              | Diminishing returns look like "no lift"; confounded by seasonality — annotate                                                                         |

**Note on formal statistical power for small paid accounts:** a full geo-incrementality experiment needs scale + matched controls most SMB accounts can't support. For small brand-defense spend, a **time-based measured test with a pre-registered hold threshold + revert trigger** is the honest, affordable substitute — it proves the direction and caps the downside without over-claiming causal precision. Say which you're running.

## Measurement sources (paid + organic)

| Source                                                      | Reaches                                                                                      | How                                                         | Requirement                                                                                                                                      |
| ----------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Your ad-platform data source (MCP)**                      | paid clicks, conv, spend, CoS/ROAS, search terms                                             | Your Ads MCP / API integration (Google Ads, Meta, etc.)     | Ads MCP auth                                                                                                                                     |
| **Ads↔Search-Console linked report** (Paid & Organic report) | paid vs **organic** vs **combined** clicks/CTR _per search term_ — the cleanest side-by-side | Google Ads GAQL (`paid_organic_search_term_view`)           | **Search Console linked to the Ads account at customer level** ([Google Ads Help 3097241](https://support.google.com/google-ads/answer/3097241)) |
| **Direct GSC integration**                                  | organic clicks/impr/CTR/position by query — independent of the Ads↔GSC link                  | Your GSC read tools (Search Console API v1)                 | GSC property accessible to your OAuth + `gsc_site_url` in client context                                                                          |
| **GA4** (organic sessions metric)                           | organic _sessions_ (macro), channel mix                                                      | Your GA4 read tools                                          | GA4 property linked; newest 24–48h unprocessed                                                                                                   |

**Worked example:** see `## Appendix — Red Pine reference implementation (optional)` at the end of this doc for a concrete run of the brand-bid-down incrementality test, including the fallback pattern to use when the Paid & Organic link isn't confirmed.

## Design essentials (reuse `ab-test-setup`)

- **Hypothesis:** _Because [cited data], we believe [change] will cause [outcome] for [audience]; we'll know it's true when [primary metric] hits [threshold] over [window]._
- **Metrics:** primary (tied to the business outcome — for paid media usually combined conv/revenue or CoS, NOT a subsystem self-report like "spend dropped"), secondary (context), and a **guardrail that must not get worse** (total branded revenue, blended CPA, lead volume).
- **MDE + sample size / duration:** `ab-test-setup` § "Sample Size". For paid media, translate to conv-volume-per-arm and a week count; annotate seasonality.
- **Pre-registered decision rule:** e.g. _"Ship the cap if combined paid+organic branded clicks hold within 10% over ≥ 2 full weeks; revert immediately if they drop > 10%."_

## Safety model (Marketing Execution Protocol)

Every experiment that touches a live paid account carries, in the doc:

1. **Spend cap** — `MAX_SPEND_CHANGE` for the test window; no increase beyond it without explicit approval.
2. **Revert trigger** — the exact guardrail threshold, **who reverts, and how fast**. This is the one condition that stops the test early.
3. **Approval gate** — the design is rendered inline and approved (`AskUserQuestion`) before anything goes live; scheduled/unattended changes bake in an explicit approval marker at schedule time (define your own convention, e.g. a literal approval token in the command).
4. **Irreversible-op floor** — pause / budget-zero / status-flip inside the experiment are **never auto-applied**, even at $0 delta (per-action approval always). See `cm-execute/SKILL.md` safety rule 5.
5. **Pre-flight (paid changes)** — LP live + conversion tag verified + tracking confirmed healthy before the change (if a client's LP-audit gate is un-run, that's a hard block). Name the owner of any tag fix explicitly.

## Experiment doc — template (grounded in a tracker format worth standardizing on)

Save as a **Google Doc in a flat `Compound Marketing` Drive folder** (via your Drive MCP tools / `/format-gdoc`, **NOT** repo markdown — per `reference/sop-cm-pipeline.md` § "Artifact naming convention"). Title **Type-first, broad→detailed**: `Experiment — <Channel / Topic> — <Client Display Name> — <YYYY-MM-DD>` (e.g. `Experiment — Google Ads Brand-Bid-Down — Client X — 2026-07-02`).

```markdown
# <Client> — <Channel> Experiment: <name> — <YYYY-MM-DD>

Status: Planned | Live | Concluded · Owner: <who> · Type: <experiment type>

## Hypothesis

Because <data>, we believe <change> will cause <outcome> for <audience>.
We'll know it's true when <primary metric> hits <threshold> over <window>.

## Mechanic

<Exact implementation: Ads config / bid change / holdout structure / LP change + fallback>

## Baseline (pre-experiment) [source + window named]

| Metric | Value | Source | Window |

## Segments / arms

| Arm | Definition | Allocation |

## Success metrics + guardrails

| Metric | Role (primary/secondary/GUARDRAIL) | Goal / threshold | Source |

## Decision rule (pre-registered)

Ship if <…>. Revert immediately if <guardrail> <breach threshold>.

## Safety

- Spend cap: MAX_SPEND_CHANGE = <…>
- Revert trigger: <threshold> → <who> reverts within <time>
- Approval: <gate> · Pre-flight: <LP/tracking + owner>

## Results [filled at conclusion — do NOT peek early]

| Metric | Baseline | Experiment | Delta | Sig / notes |

## Implementation notes [dated log]

- <YYYY-MM-DD>: <what happened>

## Learning → /cm-compound

Pattern: <one reusable line>. Apply to: <where else>. Status: <ship/revert/inconclusive>.
```

## Conclude + compound

Read the result against the pre-registered rule (winner / loser / inconclusive — `ab-test-setup` § "Interpreting Results"). Fill Results, write the one-line pattern, and hand to `/cm-compound`. A "significant loser" is a win: it retires an assumption and often seeds the next hypothesis.

## Appendix — Red Pine reference implementation (optional)

This section is a concrete worked example from Red Pine Digital's own use of this SOP, kept for illustration — the numbers and account names are specific to that engagement, not a template to copy literally.

**Client:** Sprinkler Supply Store ("SSS"), domain `sprinklersupplystore.com`. **PPC vendor of record:** WhiteGlovePPC ("WGPPC"), with Affan as the named point of contact who executes in-account changes; Frankie was the named owner for any tracking-tag fixes.

**Worked example (verified 2026-07-02):** for the brand-bid-down incrementality test, the Ads↔Search-Console linked report (`paid_organic_search_term_view`) needed a one-time Ads↔GSC UI link confirm, but **direct GSC worked immediately** (`sc-domain:sprinklersupplystore.com`, `siteFullUser`) — branded-organic baseline ~339 clicks/30d (`sprinkler supply store` 245 @ pos 2.0). Direct GSC was used as the primary organic monitor + GA4 organic sessions as the macro cross-check. This is the default fallback pattern when the Paid & Organic link isn't confirmed.

**Reference format:** the Experiment doc template above was grounded in a DKI (dynamic-keyword-insertion) creative/LP A/B test run for the Mowze account, and the tracker format Bunty used there became the standard template.

**Tooling used internally:** Red Pine's own Dharma Ads MCP (`dharma_ask_question`) and google-ads-mcp read tools (`get_gsc_performance`, `list_gsc_sites`, `organic_search_sessions`) supplied the measurement sources described generically above. Scheduled/unattended approval used a literal `# BUNTY-APPROVED` token baked into the command at schedule time.
