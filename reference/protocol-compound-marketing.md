# Compound Marketing (CM) — North-Star / Requirements

> **Status:** Durable north-star + requirements doc for the CM pipeline. Live operational reference: `sop-cm-pipeline.md`.
>
> **The 5 stages exist as live skills under verb-forward names** (`/cm-audit`, `/cm-analyze`, `/cm-plan`, `/cm-review`, `/cm-execute`); `cm-plan` has two input modes; the 4 lenses are generalized and repointed to `/cm-review`. `cm-audit` + `cm-execute` are _candidate stages_ kept as working skills — the validated core is `cm-analyze → cm-plan → cm-review`. Authoritative pipeline reference: `sop-cm-pipeline.md`.

---

## Problem / Why

Marketing fulfillment often runs on a flat library of lenses (e.g. Corey Haines' `marketing-skills`) and one-shot prompts. There is no staged, data-grounded, compounding pipeline — the marketing analogue of Compound Engineering (`compound-engineering:ce-*`). The result: analysis lives in chat and evaporates, recommendations aren't scored by who-can-execute, and there's no durable artifact trail that compounds across clients and sessions.

**Compound Marketing = CE's rigor + staged pipeline, applied to marketing channels.** Read the client's real data first → produce durable deliverable docs → score every action by ownership/automation ladder → bridge into safe, observable execution.

> **Premise to keep honest (review ⑤).** The pipeline shape is borrowed from CE by analogy — it is not yet proven for marketing. The strongest available evidence is the cm-analyze ship itself: a _single_ skill producing a durable, scored doc already discharged "analysis evaporates" and "score by owner" without any downstream stage. So the open question the build must answer is **"why a staged pipeline rather than richer flat skills?"** The bet is that _plan sequencing_ and _adversarial review_ add value a single analysis skill can't — but until cm-plan→cm-review demonstrably beats cm-analyze-alone on a real client, treat the downstream stages as a hypothesis under test, not a settled architecture. The premise-test success criterion below makes this measurable.

## What we're building

An internal marketing pipeline that, today, is a **validated 3-stage chain** plus **2 candidate stages** not yet earned (review ⑥):

```
cm-audit → cm-analyze → cm-plan → cm-review → cm-execute
[candidate]  (insight)   (plan)    (review)   [candidate]
            └──────── validated 3-stage chain ────────┘
```

- **cm-analyze → cm-plan → cm-review** is the real, in-build chain — each stage produces a durable artifact the next consumes.
- **cm-audit** (explore) and **cm-execute** (live ops) are _candidate_ stages, named for the eventual shape but not locked pipeline members: cm-audit is currently an extraction of cm-analyze's own data-read (changes nothing today), and cm-execute is framework-only. Each earns its own skill when a real engagement exposes the seam.

Stages 1–4 are strategy (the "80% before doing"). Stage 5 is the bridge into actually running marketing operations — often via Claude-in-Chrome control of no-API platforms — under a reused safety model.

## The 6 locked decisions

| #   | Decision                                  | Resolution                                                                                                                                                                                                                                                                                                                                                                         |
| --- | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q1  | Marketplace vs internal                   | **Internal-first, marketplace-clean.** Build in `.claude/skills` + `.claude/agents`; keep the orchestration↔specialist seam clean. Defer the marketplace manifest + the "is this a product Bunty sells?" business call until the pipeline proves out internally.                                                                                                                   |
| Q2  | Relationship to single-problem flow + ad-platform data source | **Full merge** (end state: one pipeline). A prior single-problem solution flow's 4 lens agents become `cm-review`'s lenses; its problem→solution methodology folds into `cm-plan` (single-problem mode); the lenses fold into `cm-review`. Your ad-platform data source (Google Ads, Meta, etc.) stays an execution backend, never a competing pipeline. **Deprecation is staged, not same-PR — see Q6 + the migration table.**                 |
| Q3  | Stage names                               | **cm-audit / cm-analyze / cm-plan / cm-review / cm-execute.** "execute" reads honestly for live ops.                                                                                                                                   |
| Q4  | Channel specialists                       | **Start with one channel; specialists grown from live client work** with a forcing function (see Core principle). Standing rule: any session where Claude works a client channel that lacks a specialist builds + dogfoods one as a byproduct. No speculative roster.                                                                                                                     |
| Q5  | `cm-execute` guardrail model              | **Reuse + extend your workspace's proven gates** into one "Marketing Execution Protocol": automation-ladder rung per action, each rung carrying the matching existing gate, **with a hard floor invariant** (gates compose per-action — irreversible/money-moving ops are never fully-auto without pre-flight + approval). Framework locked now; detailed spec deferred to the stage-5 build. |
| Q6  | First build                               | **Merge + build `cm-plan` & `cm-review` together**, with the single-problem-flow deprecation **staged** (route → bake-in on one real engagement → delete entry points only after proven parity). Unblocks the analyze→plan→review chain.                                                                                                                                                              |

## Stage definitions

1. **`cm-audit`** (explore) — _candidate stage._ Gather the real state: pull account/channel data, client context, SOPs, recent meetings. Marketing analogue of `/explore`. Currently folded into `cm-analyze`'s own data-read (skill Step 2); earns its own skill only when an engagement proves the seam. **Not built; not a locked pipeline member.**
2. **`cm-analyze`** (insight) — turns audit + data into a small set of high-confidence, scored strategic insights (what's working/not/change/why) → deliverable doc. Delegates the deep channel read to a specialist agent (e.g. a Google Ads analyst) where one exists.
3. **`cm-plan`** (plan) — turns the analysis doc into a sequenced marketing plan (campaigns, tests, deliverables, owners, success signals). **Accepts two scope modes:** _full-account_ (consumes a `cm-analyze` doc) and _single-problem_ (the absorbed single-problem intake, which has **no** upstream cm-analyze doc — see the contract gate below). Analogue of `/ce-plan`.
4. **`cm-review`** (review) — adversarial multi-lens review of the analysis/plan docs. **Is the 4 `cm-lens-*` agents:** evidence rigor, measurement, ownership/feasibility, and brand-fit (the `cm-lens-brand-client` agent — concept name "brand/channel-fit", filename `brand-client`), behind an approval gate. Analogue of `/ce-doc-review`.
5. **`cm-execute`** (live ops) — _candidate stage._ The marketing→execution bridge. Names HOW Claude executes (API: your ad platform / email platform / CRM; or Claude-in-Chrome for no-API platforms), the auth, the guardrails (the Marketing Execution Protocol below), and the verification. **Framework-only.**

Corey Haines' `marketing-skills` stay available as _lenses CM can call_ (e.g. `cm-analyze` pulling `marketing-skills:cro` for a landing-page angle). CM is the orchestration layer, not a replacement.

### Pre-first-build gate: resolve the single-problem contract (review ②)

`cm-plan`'s **single-problem mode has no upstream `cm-analyze` doc to consume**, which breaks the pipeline's "each stage consumes the prior" invariant. This is load-bearing: it determines whether the single-problem path can be safely served by `cm-plan` at all. **Resolve this before the first build ships** — either (a) one skill with a mode switch where single-problem mode declares an explicit exception to the consume-the-prior invariant, or (b) a thin reactive entry that calls the same plan machinery with a synthetic/empty analysis input. Do not punt it into implementation.

## Core principle — specialists are grown, not built (with a forcing function)

CM's compounding loop (its `/ce-compound` analogue): **specialist analyst agents are born from real client work, never pre-built speculatively.** When a session works a client channel that has no specialist, that session builds + dogfoods the specialist as a byproduct of the engagement. The roster (paid search → paid social → email → SEO → CRO → …) accrues organically, gated by live engagements. This is also where winning angles, channel playbooks, and client patterns accrue and get recalled.

> **Forcing function (review ③).** This rule is CM's _defining_ claim, and an aspirational convention a deadline-pressured session will skip — leaving the roster stalled at one channel and "Compound" Marketing quietly reduced to a single-channel play. So it needs a mechanical trigger, not just a stated norm. **Requirement:** a session-wrap-time hook/gate (modeled on any existing learn-gate + behavioral-invariant patterns in your workspace) that detects "a client channel was worked with no matching specialist" and nudges/blocks until a specialist is built or the omission is consciously declined. The detector's design is deferred to the stage that first builds a second specialist; until then this is the explicitly-named gap, not a silent assumption.

## Marketing Execution Protocol (the `cm-execute` guardrail framework)

Reuses three proven safety primitives — one model, no parallel spec to drift:

| Risk surface                 | Existing gate reused                                                           | Applies to                                               |
| ---------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------- |
| Client-facing / irreversible | **Approval gate** — an explicit human-approval token + never-auto-send         | Any client comms, irreversible account change            |
| Destructive ad-account op    | **Pre-flight** — required checks (LP live, tracking verified) before the action | Pauses, restructuring, budget kills                      |
| Autonomous action            | **Autonomous-dispatch guardrails** — spend cap + allowlist + idempotency + audit trail | Reversible, non-financial actions on the fully-auto rung |

Every `cm-execute` action declares its **automation-ladder rung** (owner-only / copilot-w-approval / fully-auto / vendor); the rung determines which gate(s) fire.

> **Floor invariant (review ④ — gates compose per-action, not one-per-rung).** A campaign pause / restructure / budget-kill is irreversible but costs $0, so a spend-cap gate alone never trips on it. Therefore: **irreversible OR money-moving actions are NEVER eligible for the fully-auto rung** without BOTH the pre-flight AND a human approval token. The fully-auto rung is reserved for reversible, non-financial actions unless the per-action spec explicitly grants an exception. Gates stack on a single action; they are not mutually exclusive per rung.

> **Credential / trust-boundary posture (review ④/security).** Stage 5 crosses into client ad-account credentials and authenticated sessions (API keys, CRM/email auth, the live browser session Claude-in-Chrome drives). The stage-5 spec must commit to: least-privilege, per-engagement-scoped access (no standing Owner-level keys); audit-trail + idempotency for **every** rung (not only fully-auto); and Claude-in-Chrome acting only inside an already-authenticated client session, never capturing or persisting raw credentials. Detail deferred to the build; the posture is named here.

Detailed spec (thresholds, per-platform pre-flight checklists, audit schema, and whether browser-control needs a verification-of-effect primitive the three reused gates don't cover) is deferred to the stage-5 build.

## The single-problem-flow → CM merge (migration scope for the first build)

**Deprecation is staged (review ①), not same-PR.** If a workspace has a pre-existing standalone single-problem solution flow, fold it into CM in this sequence: (1) build `cm-plan` + `cm-review`; (2) route the old flow's entry into `cm-plan` single-problem mode but keep the old skill as a thin deprecated alias/fallback; (3) bake-in on **one real single-problem engagement** and verify parity (the 4 lenses + single-problem intake + approval gate all reachable, no lost function); (4) delete the old entry points **only after** parity is demonstrated. This preserves the full-merge end state while making the irreversible deletion contingent on evidence, not on the first PR landing — reversal cost drops from "resurrect a deleted skill" to "flip a pointer back."

| Artifact                                | Action                                                                                                                                                                                                                                                                        |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The old single-problem lens agents      | Repoint as `cm-review` lenses (`cm-lens-*`). Keep the inline-artifact + verbatim-quote guards. **Note:** old prompt bodies may hardcode section-numbers and channel-specific owner/failure mappings, so repointing includes light prompt-body generalization — not a pure filename swap (review G). |
| The old single-problem skill            | Stage-deprecate (alias → bake-in → delete); fold its step flow into `cm-plan` (single-problem mode) + `cm-review`.                                                                                                                                                            |
| The old single-problem methodology doc  | Fold methodology into the CM plan/review SOP(s).                                                                                                                                                                                                                             |
| Any case study / pointer to the old flow | Update the pointer to CM.                                                                                                                                                                                                                                                    |

Sweep all references to the old flow in the same PR. Verify no hook injector branch or skill-context injector still points at the old skill.

## Scope boundaries

**In scope (now / first build):** the 5 stage names; the single-problem-flow→CM **staged** merge; `cm-plan` + `cm-review` built; the single-problem-contract resolution; the Marketing Execution Protocol _framework_ (incl. the floor invariant + credential posture as stated requirements); naming the specialist-growth forcing function as a requirement.

**Deferred for later:** `cm-audit` (candidate stage 1) and `cm-execute` (candidate stage 5) builds; the marketing-execution protocol _detailed spec_ + the forcing-function _detector implementation_; new channel specialists (grown on demand); marketplace/plugin packaging.

**Outside this product's identity:** CM is not a replacement for `marketing-skills` (those are callable lenses); not a real-time campaign manager; not a client-facing self-serve tool (it's your internal fulfillment pipeline until the business decision says otherwise).

## Success criteria

**First-build criteria (evaluable when cm-plan + cm-review ship):**

- A client analysis (`cm-analyze` doc) flows into `cm-plan` → a sequenced plan doc → `cm-review` hardening → approval, each stage producing a durable artifact the next consumes — demonstrated end-to-end on one real client.
- **Premise test (review ⑤):** on that client, the staged analyze→plan→review chain produces a materially better, more actionable outcome than `cm-analyze` alone did — i.e. the pipeline earned its added stages, not just "we migrated correctly."
- After the staged deprecation completes, zero old single-problem-flow entry points remain and every prior single-problem capability (single-problem intake, 4 lenses, approval gate) is reachable through CM with no lost function — **verified on a real single-problem engagement before the entry points are deleted.**

**Future-build / standing-rule criteria (not evaluable at first-build time):**

- `cm-execute` actions, once built, never fire a client-facing, irreversible, or money-moving op without the matching gate(s) from the Marketing Execution Protocol — and never run such an op on the fully-auto rung.
- A new channel specialist gets built + dogfooded the first time a session works that channel — enforced by the forcing function, confirmed by the roster growing from real engagements, not speculative batches.

## Outstanding questions (do not block the first build)

- **Marketplace/business angle** — revisit "is CM a product Bunty sells?" after the pipeline works internally (Q1 deferred this deliberately).
- **`cm-audit` necessity** — does the candidate stage 1 earn its own skill, or stay folded into `cm-analyze`'s data-read step? Decide when a client engagement exposes the seam.
- **One protocol vs three modalities (review J)** — does one Marketing Execution Protocol cleanly cover API ad-changes, email sends, AND Claude-in-Chrome UI control? Browser control has failure modes (wrong element, partial submit, no idempotency key) the three reused gates weren't built for. Mark as an assumption to test at the stage-5 build, not a locked conclusion.

> Note: the single-problem-vs-full-account contract was previously an open question; it is now a **pre-first-build gate** (see Stage definitions) because it is load-bearing for the deprecation's safety.

## Dependencies / assumptions

- **Mechanical compatibility of the 4 `cm-lens-*` agents is verified** (they take an inline artifact + verbatim-quote guard). But **review efficacy on the new doc type is NOT verified** (review G): if the lenses were tuned to critique a single-problem solution doc, a full-account sequenced plan has different failure modes (sequencing/dependency errors, cross-campaign budget allocation) the existing lenses may not probe. Plan to dogfood the lenses on one real `cm-plan` output and check whether a plan-specific lens is missing.
- **Depends on** your existing surfaces unchanged: your ad-platform data source (Google Ads, Meta, etc.), your web analytics (GA4, etc.), your CRM/email tools, Claude-in-Chrome; your channel's audit SOP / account-intelligence doc + account-economics as the methodology spine. If that methodology shifts, `cm-analyze`'s grounding shifts under the whole chain.
