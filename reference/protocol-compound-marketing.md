# Compound Marketing (CM) — North-Star / Requirements

> **Status:** Durable north-star + requirements doc for the CM pipeline (originally shaped as a brainstorm output, then hardened through a structured doc review). Live operational reference: `reference/sop-cm-pipeline.md`.
>
> **Note.** The pipeline's five stages exist as skills under these locked names: `/cm-audit`, `/cm-analyze`, `/cm-plan`, `/cm-review`, `/cm-execute`. `cm-plan` supports both scope modes described below. The four review lenses are generalized and repointed to `/cm-review`. An earlier flat, single-problem workflow was folded into this pipeline as a deprecated alias, fully merged into the staged pipeline described here. `cm-audit` and `cm-execute` began as candidate stages but are kept as working skills rather than dropped — the validated core remains `cm-analyze → cm-plan → cm-review`. Authoritative pipeline reference: `reference/sop-cm-pipeline.md`.

---

## Problem / Why

Most marketing fulfillment runs on a flat library of lenses (e.g. Corey Haines' `marketing-skills`) and one-shot prompts. There is no staged, data-grounded, compounding pipeline — the marketing analogue of Compound Engineering (`compound-engineering:ce-*`). The result: analysis lives in chat and evaporates, recommendations aren't scored by who-can-execute, and there's no durable artifact trail that compounds across clients and sessions.

**Compound Marketing = CE's rigor + staged pipeline, applied to marketing channels.** Read the client's real data first → produce durable deliverable docs → score every action by ownership/automation ladder → bridge into safe, observable execution. The analysis stage (`cm-analyze`) is the proof point: it reads a client's live account data (optionally via a channel specialist agent, e.g. a Google Ads analyst) and produces a durable, scored insight doc.

> **Premise to keep honest.** The pipeline shape is borrowed from CE by analogy — it is not yet proven for marketing. The strongest available evidence is the `cm-analyze` stage itself: a _single_ skill producing a durable, scored doc already discharges "analysis evaporates" and "score by owner" without any downstream stage. So the open question the build must answer is **"why a staged pipeline rather than richer flat skills?"** The bet is that _plan sequencing_ and _adversarial review_ add value a single analysis skill can't — but until `cm-plan → cm-review` demonstrably beats `cm-analyze` alone on a real client, treat the downstream stages as a hypothesis under test, not a settled architecture. The premise-test success criterion below makes this measurable.

## What we're building

A marketing pipeline that is a **validated 3-stage chain** plus **2 candidate stages** not yet fully earned:

```
cm-audit → cm-analyze → cm-plan → cm-review → cm-execute
[candidate]  (insight)   (plan)    (review)   [candidate]
            └──────── validated 3-stage chain ────────┘
```

- **cm-analyze → cm-plan → cm-review** is the real, in-build chain — each stage produces a durable artifact the next consumes.
- **cm-audit** (explore) and **cm-execute** (live ops) are _candidate_ stages, named for the eventual shape but not locked pipeline members: `cm-audit` is currently an extraction of `cm-analyze`'s own data-read (changes nothing today); `cm-execute`'s detailed spec is described in a dedicated marketing-execution protocol doc and the skill is built as Compile+Run; it graduates to validated-stage status after its first clean live run.

Stages 1–4 are strategy (the "80% before doing"). Stage 5 is the bridge into actually running marketing operations — often via browser automation (e.g. Claude in Chrome) against no-API platforms — under a reused safety model. Built as portable skills + agents, authored to be marketplace-clean so it stays cheap to package as a standalone plugin.

## The 6 locked decisions

| #   | Decision                                  | Resolution                                                                                                                                                                                                                                                                                                                                                                         |
| --- | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Q1  | Marketplace vs internal                   | **Internal-first, marketplace-clean.** Build as skills + agents in your Claude Code config; keep the orchestration↔specialist seam clean. Defer the marketplace manifest + "is this a product we sell?" business call until the pipeline proves out internally.                                                                                                                   |
| Q2  | Relationship to an earlier flat solver + ad-platform tooling | **Full merge** (end state: the earlier flat single-problem workflow no longer has its own entry point). Its lens agents become `cm-review`'s lenses; its problem→solution methodology folds into `cm-plan` (single-problem mode). Your ad-platform data source stays an execution backend, never a competing pipeline. **Deprecation is staged, not same-PR — see Q6 + the migration table.**                 |
| Q3  | Stage names                               | **cm-audit / cm-analyze / cm-plan / cm-review / cm-execute.** "execute" reads honestly for live ops. The initial analysis skill is **renamed to `cm-analyze` as part of the first build**.                                                                                                                                                   |
| Q4  | Channel specialists                       | **One channel first (e.g. Google Ads); specialists grown from live client work** with a forcing function (see Core principle). Standing rule: any session where a client channel lacks a specialist builds + dogfoods one as a byproduct. No speculative roster.                                                                                                                     |
| Q5  | `cm-execute` guardrail model              | **Reuse + extend your existing approval/safety gates** into one "Marketing Execution Protocol": automation-ladder rung per action, each rung carrying the matching existing gate, **with a hard floor invariant** (gates compose per-action — irreversible/money-moving ops are never fully-auto without pre-flight + approval). Framework locked now; detailed spec deferred to the stage-5 build. |
| Q6  | First build                               | **Merge + build `cm-plan` & `cm-review` together**, with the earlier flat workflow's deprecation **staged** (route → bake-in on one real engagement → delete entry points only after proven parity). Unblocks the analyze→plan→review chain.                                                                                                                                                              |

## Stage definitions

1. **`cm-audit`** (explore) — _candidate stage._ Gather the real state: pull account/channel data, client context, SOPs, recent meetings. Marketing analogue of `/explore`. Currently folded into `cm-analyze`'s own data-read (skill Step 2); earns its own skill only when an engagement proves the seam. **Not built; not a locked pipeline member.**
2. **`cm-analyze`** (insight) — ✅ **built.** Turns audit + data into a small set of high-confidence, scored strategic insights (what's working/not/change/why) → deliverable doc. If your workspace provides a channel specialist agent (e.g. a Google Ads analyst), `cm-analyze` delegates the deep channel read to it; otherwise the stage analyzes inline.
3. **`cm-plan`** (plan) — turns the analysis doc into a sequenced marketing plan (campaigns, tests, deliverables, owners, success signals). **Accepts two scope modes:** _full-account_ (consumes a `cm-analyze` doc) and _single-problem_ (the absorbed single-problem intake, which has **no** upstream `cm-analyze` doc — see the contract gate below). Analogue of `/ce-plan`. **First build.**
4. **`cm-review`** (review) — adversarial multi-lens review of the analysis/plan docs. **Runs 4 repointed lens agents:** evidence rigor, measurement, ownership/feasibility, and brand/channel-fit, behind an approval gate. Analogue of `/ce-doc-review`. **First build.**
5. **`cm-execute`** (live ops) — _candidate stage._ The marketing→execution bridge. Names HOW the pipeline executes (via your ad-platform APIs — Google Ads / Meta / your CRM — via MCP tools, or via browser automation for no-API platforms), the auth, the guardrails (the Marketing Execution Protocol below), and the verification. **Spec adopted + skill built; live-run validation pending on a real account.**

Corey Haines' `marketing-skills` stay available as _lenses CM can call_ (e.g. `cm-analyze` pulling `marketing-skills:cro` for a landing-page angle). CM is the orchestration layer, not a replacement.

### Pre-first-build gate: resolve the single-problem contract

`cm-plan`'s **single-problem mode has no upstream `cm-analyze` doc to consume**, which breaks the pipeline's "each stage consumes the prior" invariant. This is load-bearing: it determines whether the single-problem path (the earlier flat workflow's capability) can be safely served by `cm-plan` at all, and therefore whether deprecating the old entry point is safe. **Resolve this in your planning stage before the first build ships** — either (a) one skill with a mode switch where single-problem mode declares an explicit exception to the consume-the-prior invariant, or (b) a thin reactive entry that calls the same plan machinery with a synthetic/empty analysis input. Do not punt it into implementation.

## Core principle — specialists are grown, not built (with a forcing function)

CM's compounding loop (its `/ce-compound` analogue): **specialist analyst agents are born from real client work, never pre-built speculatively.** When a session works a client channel that has no specialist, that session builds + dogfoods the specialist as a byproduct of the engagement. The roster (e.g. Google Ads ✅ → Meta → email → SEO → CRO → …) accrues organically, gated by live engagements. This is also where winning angles, channel playbooks, and client patterns accrue and get recalled.

> **Forcing function.** This rule is CM's _defining_ claim, and an aspirational convention a deadline-pressured session will skip — leaving the roster stalled at one channel and "Compound" Marketing quietly reduced to a renamed single-problem solver. So it needs a mechanical trigger, not just a stated norm. **Requirement:** a session-wrap-time hook/gate (modeled on your existing learn-gate + behavioral-invariant patterns, if you have them) that detects "a client channel was worked with no matching specialist" and nudges/blocks until a specialist is built or the omission is consciously declined. The detector's design is deferred to the stage that first builds a second specialist; until then this is the explicitly-named gap, not a silent assumption.

## Marketing Execution Protocol (the `cm-execute` guardrail framework)

Reuses your existing safety primitives — one model, no parallel spec to drift:

| Risk surface                 | Existing gate reused                                                           | Applies to                                               |
| ----------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------- |
| Client-facing / irreversible | **Approval-token protocol** — an explicit human-approval token + never-auto-send                   | Any client comms, irreversible account change            |
| Destructive ad-account op    | **Pre-flight-audit-style checks** — required checks before the action              | Pauses, restructuring, budget kills                      |
| Autonomous action            | **Guarded-dispatch primitives** — spend cap + allowlist + idempotency + audit trail | Reversible, non-financial actions on the fully-auto rung |

Every `cm-execute` action declares its **automation-ladder rung** (human-approved / copilot-w-approval / fully-auto / vendor); the rung determines which gate(s) fire.

> **Floor invariant (gates compose per-action, not one-per-rung).** A campaign pause / restructure / budget-kill is irreversible but costs $0, so a spend-cap gate alone never trips on it. Therefore: **irreversible OR money-moving actions are NEVER eligible for the fully-auto rung** without BOTH the pre-flight-audit-style check AND a human approval token. The fully-auto rung is reserved for reversible, non-financial actions unless the per-action spec explicitly grants an exception. Gates stack on a single action; they are not mutually exclusive per rung.

> **Credential / trust-boundary posture.** Stage 5 crosses into client ad-account credentials and authenticated sessions (API keys, CRM/email auth, the live browser session your browser-automation tool drives). The stage-5 spec must commit to: least-privilege, per-engagement-scoped access (no standing Owner-level keys); audit-trail + idempotency for **every** rung (not only fully-auto); and browser automation acting only inside an already-authenticated client session, never capturing or persisting raw credentials. Detail deferred to the build; the posture is named here.

Detailed spec lives in `reference/protocol-marketing-execution.md`: Action Cards with derived (never declared) rungs; the **Effect Probe** as the fourth primitive (baseline → act → cross-modality read-back → CONFIRMED/PENDING/FAILED, ensure-state idempotency — the verification-of-effect answer: yes, browser control needed it, and every modality got it); one protocol with three surface adapters (api / browser-ui / feed-cms); two-tier approval with a per-client fully-auto graduation flag (default OFF). Design rationale + a real-account validation walk live alongside that doc.

## The single-problem-solver → CM merge (migration scope for the first build)

**Deprecation is staged, not same-PR.** Sequence: (1) build `cm-plan` + `cm-review`; (2) route the old single-problem entry point into `cm-plan` single-problem mode but keep the old skill as a thin deprecated alias/fallback; (3) bake-in on **one real single-problem engagement** and verify parity (the 4 lenses + single-problem intake + approval gate all reachable, no lost function); (4) delete the old entry points **only after** parity is demonstrated. This preserves the full-merge end state while making the irreversible deletion contingent on evidence, not on the first PR landing — reversal cost drops from "resurrect a deleted skill" to "flip a pointer back."

| Artifact                                                                    | Action                                                                                                                                                                                                                                                                                                                                                                |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Old single-problem lens agents (evidence, measurement, ownership, brand/client-fit) | Repoint as `cm-review` lenses (rename to `cm-lens-*` or keep names + repoint — a mechanical call your planning stage makes). Keep the inline-artifact + verbatim-quote guards. **Note:** the prompt bodies often hardcode section numbers and channel-specific owner/failure mappings from the old solver, so repointing includes light prompt-body generalization — it is not a pure filename swap. |
| Old single-problem-solver skill                                             | Stage-deprecate (alias → bake-in → delete); fold its intake flow into `cm-plan` (single-problem mode) + `cm-review`.                                                                                                                                                                                                                                                  |
| Old single-problem-solver SOP                                               | Fold methodology into the CM plan/review SOP(s).                                                                                                                                                                                                                                                                                                                      |
| Any case-study/reference doc pointing at the old solver                     | Update the pointer to CM.                                                                                                                                                                                                                                                                                                                                             |
| Initial analysis skill → `cm-analyze/`                                      | Rename dir + SKILL.md frontmatter + self-references; sweep the referencing files (the skill, the vision doc, this requirements doc — a doc-only sweep if there are no code/hook/settings references).                                                                                                                                                    |
| Historical planning docs for the old solver                                 | Historical — leave as archive.                                                                                                                                                                                                                                                                                                                                        |

Sweep all references to the old solver in the same PR per your skill-deprecation convention (if you have one, e.g. "Deprecating / deleting a skill" in a skills `CLAUDE.md`). Verify no hook injector branch or context-injector entry still points at the old solver or the old analysis-skill name.

## Scope boundaries

**In scope (now / first build):** the 5 stage names; the staged merge of the old single-problem workflow into CM; `cm-plan` + `cm-review` built; `cm-analyze` renamed; the single-problem-contract resolution; the Marketing Execution Protocol _framework_ (incl. the floor invariant + credential posture as stated requirements); naming the specialist-growth forcing function as a requirement.

**Deferred for later:** `cm-audit` (candidate stage 1) and `cm-execute` (candidate stage 5) builds; the marketing-execution protocol _detailed spec_ + the forcing-function _detector implementation_; new channel specialists (grown on demand); the marketplace manifest + plugin packaging.

**Outside this product's identity:** CM is not a replacement for `marketing-skills` (those are callable lenses); not a real-time campaign manager; not a client-facing self-serve tool (it's an internal fulfillment pipeline until you decide otherwise).

## Success criteria

**First-build criteria (evaluable when cm-plan + cm-review ship):**

- A client analysis (`cm-analyze` doc) flows into `cm-plan` → a sequenced plan doc → `cm-review` hardening → approval, each stage producing a durable artifact the next consumes — demonstrated end-to-end on one real client.
- **Premise test:** on that client, the staged analyze→plan→review chain produces a materially better, more actionable outcome than `cm-analyze` alone did — i.e. the pipeline earned its added stages, not just "we migrated correctly."
- After the staged deprecation completes, zero old-solver entry points remain and every prior capability (single-problem intake, 4 lenses, approval gate) is reachable through CM with no lost function — **verified on a real single-problem engagement before the entry points are deleted.**

**Future-build / standing-rule criteria (not evaluable at first-build time):**

- `cm-execute` actions, once built, never fire a client-facing, irreversible, or money-moving op without the matching gate(s) from the Marketing Execution Protocol — and never run such an op on the fully-auto rung.
- A new channel specialist gets built + dogfooded the first time a session works that channel — enforced by the forcing function, confirmed by the roster growing from real engagements, not speculative batches.

## Outstanding questions (do not block the first build)

- **Marketplace/business angle** — revisit "is CM a product we sell?" after the pipeline works internally (Q1 deferred this deliberately).
- **`cm-audit` necessity** — does the candidate stage 1 earn its own skill, or stay folded into `cm-analyze`'s data-read step? Decide when a client engagement exposes the seam.
- **Lens agent naming** — keep the old solver's lens filenames (repoint only) or rename to `cm-lens-*`? Mechanical; your planning stage's call.
- **One protocol vs three modalities — RESOLVED at the stage-5 design:** one protocol, three surface adapters. The UI failure modes needed post-act verification (the Effect Probe), not branched protocols; the invariants never branch, only the adapter contract does. Tested against a tri-surface feed action on a real account. See `reference/protocol-marketing-execution.md` §5.

> Note: the single-problem-vs-full-account contract was previously an open question; it is now a **pre-first-build gate** (see Stage definitions) because it is load-bearing for the deprecation's safety.

## Dependencies / assumptions

- **Mechanical compatibility of the 4 old-solver lens agents is verified** (they take an inline artifact + verbatim-quote guard). But **review efficacy on the new doc type is NOT verified**: the lenses were tuned to critique a single-problem solution doc; a full-account sequenced plan has different failure modes (sequencing/dependency errors, cross-campaign budget allocation) the existing lenses may not probe. Plan to dogfood the repointed lenses on one real `cm-plan` output and check whether a plan-specific lens is missing.
- **`cm-analyze` rename is a doc-only sweep** (verify: the skill, the vision doc, and this requirements doc — and confirm there are no code/hook/settings references).
- **Depends on** existing surfaces unchanged: your ad-platform data source (Google + Meta Ads, via MCP or API), GA4 (web analytics) tools, your CRM's MCP/API, your marketing-docs store, your browser-automation tool; your ad-platform daily-analysis methodology + account-economics as the methodology spine. If that methodology shifts, `cm-analyze`'s grounding shifts under the whole chain.

## Appendix — Red Pine reference implementation (optional)

The design decisions above were developed and validated inside Red Pine Digital's internal build of this pipeline. For illustration:

- The first `cm-analyze` output was validated against a real Google Ads account for a client referred to internally as "SSS" (Sprinkler Supply Store), backed by a Google Ads specialist agent, producing a scored insight doc similar in shape to what `cm-analyze` produces today.
- The `cm-execute` stage's tri-surface Effect Probe design was tested against a real feed-management action on that same account, exercising all three surface adapters (api / browser-ui / feed-cms) in one validation pass.
- The earlier flat single-problem workflow that CM absorbed was an internal skill (`fcmo-solution`) with four review lenses; its methodology and lenses were folded into `cm-plan` (single-problem mode) and `cm-review` respectively, following the staged-deprecation sequence described above.
