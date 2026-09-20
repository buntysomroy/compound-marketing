# CM Stage Contract

> **Cross-cutting behavioral contract for all cm-\* skills.** Every stage skill reads this FIRST, every run. The skill is the thin driver; this doc is the canonical spec for the six contract steps. Do not improvise contract mechanics from memory.
>
> Pipeline reference (stage order, artifact naming, Drive mechanics): `reference/sop-cm-pipeline.md`. This doc does not restate pipeline mechanics — it defines the per-stage behavioral gates.

---

## Scope

This contract applies to every cm-\* stage skill: `/cm-audit`, `/cm-analyze`, `/cm-plan`, `/cm-review`, `/cm-agent-plan`, `/cm-execute`, `/cm-experiment`, `/cm-compound`, `/cm-analytics-audit`. The front-door dispatcher (`/cm`) and the standalone handoff skill (`/cm-handoff`) bind via their own Step 0, which loads this contract and runs its recall step once before routing. The session-wrap trigger (`/cm-session-review`) references this contract but is not itself a pipeline stage (it does not produce a pipeline artifact; it invokes `/cm-compound` for the actual write).

**Legitimate bypass.** A stage may skip a contract step only when the step's own bypass note permits it. No other reason qualifies. If a step cannot fire (tool unavailable, data missing), the stage surfaces the failure loudly and carries the gap in its handoff block — it does not silently skip.

**Live-platform execution routes through `/cm-agent-plan` → `/cm-execute`, never ad hoc.** Any action that changes state on a live client platform (a bid, a page edit, a status flip, a browser-driven click) routes through the Manifest-Gate model — Action Cards → Manifest Gate (`/cm-agent-plan`, Compile) → baseline → gate → act → read-back → receipt (`/cm-execute`, Run) — regardless of which stage is running or whether the plan is already approved. `/cm-plan` (Step 7) hands off to tactical skills and to your message-drafting skill for comms only; it never drives the live platform itself, even post-approval. This closes the gap that let a campaign build run ad hoc browser automation with no Manifest, no Action Cards, and no Effect Probe.

---

## Contract Step 1 — Decisions Recall (R4)

**When:** Before any stage work begins. This is the first action after loading the contract.

**What:** Dispatch the `cm-learnings-researcher` agent with a `<work-context>` block (Client slug + display name / Stage / Channels/topics). List the returned carry-forward items visibly in chat before proceeding.

**Output shape:**

```
## Prior CM Learnings — <Client Display Name>

**Decisions (settled):**
- <date> · <stage> · <decision> — <why>
- ...

**Topic-specific learnings:**
- <learning summary> (Source: <doc title>)
- ...

**Recall status:** <"X decisions + Y learnings recalled" | "No prior learnings for this client" | "⚠️ Recall unreachable — <error>; prior learnings may exist but are unread">
```

**Distinguish "genuinely none" from "recall unreachable."** An empty result from the search = genuinely no learnings (early-adoption normal). MCP tool failure or unavailability = loud caveat, not a clean "none." Never conflate them.

**Bypass:** None. This step always fires. If the environment auto-dispatches recall before the stage loads, the stage still lists the results visibly — the step is mandatory regardless of how the recall was triggered.

---

## Contract Step 2 — Findings Confirmation (R5)

**When:** Before writing the stage's artifact (Drive doc). After the stage has gathered evidence and formed findings, but before any artifact write.

**What:** Render a findings block with the fixed machine-checkable shape below. Ask the user to confirm the findings and supply any context the stage could not find. Do not write the artifact until the user confirms.

**Output shape — one block per finding:**

```
### Finding <N>: <claim>

- **Source:** <what produced this — tool name, doc title, live system read>
- **Denominator + coverage:** <what the rate/number is out of; what fraction of the full population was sampled>
- **Proxy validity:** <is this metric a valid proxy for the claim, or an indirect measure? note if the metric measures something adjacent but not identical>
- **Live-platform verified:** <yes/no + how — REQUIRED for any current-state claim (live/not-live, built/not-built, launched/not-launched); "N/A" for findings that assert no current-state fact>
```

**Live-platform verified — why this field exists.** A CM Solution doc's Problem section asserted that a client's sales channel "hasn't launched yet" — it had, and was already selling thousands of products. Not caught by drafting, by any of the 4 adversarial review lenses, or by the approval gate — only found once live browser automation began, after approval closed. A current-state claim is not a quantitative claim (Step 3 doesn't cover it) and reads as settled fact unless something forces the stage to say how it knows. This field forces that: "yes — read the live channel admin, 2026-09-04" passes; "no — inferred from the last audit doc" fails and must be re-verified against the live platform before the finding stands.

**Client estimates are hypotheses.** Treat a client's qualitative or numeric estimate as an unverified hypothesis until checked against the live platform over a comparable scope and time window. Before it enters a plan as confirmed evidence, record the original estimate, observed result, scope/window, and verification method/date in the finding. Record a material discrepancy as a signal to investigate; a greater-than-2x difference between comparable numeric values qualifies. Do not assign a numeric multiplier to vague language or mismatched scopes/windows, or infer the client's motive from the discrepancy. If verification is unavailable, retain the hypothesis tag under the bypass below.

**Worked example (passes the gate):**

```
### Finding 1: 4 hard bounces persist across reads

- **Source:** email-processing log (inbox pipeline record), 2026-07-09
- **Denominator + coverage:** 4 bounces on 81 of 580 processed emails (14% coverage); full-segment bounce rate unknown
- **Proxy validity:** Direct measure — hard bounces are observed, not inferred
- **Live-platform verified:** N/A — not a current-state claim
```

```
### Finding 2: The new sales channel has not launched yet

- **Source:** live channel storefront, read via browser automation, 2026-09-04
- **Denominator + coverage:** N/A — binary state claim
- **Proxy validity:** N/A — binary state claim
- **Live-platform verified:** yes — read the live storefront directly, 2026-09-04; thousands of products listed and purchasable
```

**Worked example (fails the gate):**

```
### Finding 1: 6.67% bounce rate

- **Source:** ??? (no denominator stated)
- **Denominator + coverage:** NOT STATED — headline rate without coverage
- **Proxy validity:** Cannot assess without knowing what was measured
- **Live-platform verified:** N/A
```

```
### Finding 2: The new sales channel has not launched yet

- **Source:** last audit doc, 2026-06-01
- **Denominator + coverage:** N/A — binary state claim
- **Proxy validity:** N/A — binary state claim
- **Live-platform verified:** NOT STATED — current-state claim with no verification method
```

The first example fails because the headline rate has no denominator, no coverage, and no source. The stage must restate it as "4 bounces on 81 of 580 processed (14% coverage)" before the gate passes. The second fails because it is a current-state claim (live/not-live) carrying no live-platform verification — the stage must read the live platform before the finding stands, not assert from a stale doc.

**Bypass:** Hypothesis-stage findings (explicitly marked as such by the stage — e.g., cm-audit data-gathering that flags items as "unverified hypothesis") may render the findings block with a `⚠️ HYPOTHESIS — not yet verified` tag and proceed without blocking. The tag must be present; untagged unverified claims fail the gate. The Live-platform-verified field has no separate bypass — an untagged hypothesis-stage current-state claim still needs the field, answered `no — hypothesis, not yet verified` rather than omitted.

---

## Contract Step 3 — Quantitative-Claim Rule (R6)

**When:** Every time a quantitative claim appears in stage output — findings, artifacts, handoff blocks, chat summaries.

**Rule:** Every quantitative claim states its denominator and coverage. A headline rate without coverage fails the gate and must be restated with its full denominator before it propagates.

**Two questions the gate asks:**

1. **What is the denominator/coverage?** — "6.67% bounce" fails; "4 bounces on 81 of 580 processed (14% coverage)" passes.
2. **Is the metric a valid proxy for the claim?** — A quality-blind metric (e.g., word count as a proxy for draft quality) fails even if the denominator is stated. Verify against the live artifact, never a doc summary.

**Enforcement:** The findings block (Step 2) carries the denominator/coverage and proxy-validity fields explicitly. The `/cm-review` evidence lens cross-checks the provenance block shape during its adversarial review.

---

## Contract Step 4 — Handoff Block (R7)

**When:** After the stage writes its artifact. Every stage ends by emitting a handoff block inline in chat.

**Be thin. Point at the document; do not restate it.** The handoff block is a pointer, not a second copy of the artifact. If the artifact carries a Step 6 Open Items section, the handoff block's Evidence field is a one-line pointer to the doc, not a restatement of every finding — findings live in the doc; open items live in the doc's Open Items section and are pulled into the block verbatim (same IDs, same wording), never re-derived or re-summarized into new prose. Re-typing what the doc already says is the failure mode this rule exists to stop — it's how a handoff drifts out of sync with the artifact it's supposed to point at.

**Output shape:**

```
## Handoff — <Stage> complete

**What was done:**
- <1-2 lines summarizing the stage's work>

**Artifacts:**
- <artifact type> — <doc title> (Drive link or path)
- ...

**Evidence:**
- See <doc title> for full findings with provenance. <0-1 lines max of framing, only if the doc's scope needs a pointer sentence — no restated findings.>

**Open items (from <doc title>):**
- <OI-id> (blocking: yes/no) — <short description, verbatim from the doc>
- ... (or "No open items — this artifact carries no unresolved gaps.")

**Decisions made:**
- <date> · <stage> · <decision> — <why>
- ...

**Carried-over context (for the next stage):**
- <what the next stage needs to know without re-deriving>

**Don't repeat (confirmed findings, closed questions):**
- <what's settled and should not be re-opened>

**First step:**
- `<literal, pastable command>` — <one-line reason>
```

**The "First step" field is a command, not a description.** It must be something the user can paste as-is to continue — never a sentence describing what should happen next. Two cases:

1. **Blocking open items remain on this stage's own artifact.** The first step is THIS stage's own resume invocation, addressed at the specific open items — never the next pipeline stage. Shape: `` `/cm-<stage> — resume open items: "<doc title>"` ``. This routes back into the same stage (see the stage's own Resume Mode, most stages should define one alongside their Step 4/5 artifact-writing step) to close the gaps, not forward into analysis/planning built on an artifact that admits it isn't finished.
2. **No blocking open items (or none at all).** The first step is the next pipeline stage's normal invocation, as before.

Never mix the two: if any Open Item is tagged blocking, the first step is the resume command, full stop — do not simultaneously suggest advancing to the next stage as an alternative in the same field. If the user wants to advance anyway despite open items, that's their call to make explicitly, not a default the handoff offers.

**Rendering:** Inline in chat, always, wrapped in a single fenced code block (triple backticks around the whole block, from `## Handoff —` through the last `First step` line) — never bare chat markdown. This is so the block is copyable in one click and pasteable in a second, which is the entire point of a literal, pastable "First step" command (see above): a command that can't be one-click-copied isn't actually thin, it's just short. A file copy is optional and never a replacement. The handoff block is internal scaffolding — strip it from any client-shared artifact (see Client-Facing Stripping Rule below).

**Bypass:** None. Every stage emits a handoff block, even if the stage produced no artifact (e.g., cm-compound invoked with nothing to capture → handoff block says "no learning captured this run").

---

## Contract Step 5 — Decision-Time Logging (R8)

**When:** At the moment a decision is made — during AskUserQuestion answers, chat confirmations, or any explicit choice the user makes.

**What:** Append the accepted decision to the decision log in the artifact workspace profile resolved under `reference/sop-cm-pipeline.md`. A proposal, recommendation, or draft does not become a decision merely because it appears in the log format.

**Project-local profile:**

- Find or create `<project-slug>-decisions.csv` in the flat `CM Artifacts` directory.
- Use this exact header: `decision_id,project,run_id,stage,decided_on,decision,rationale,status,source`.
- Allocate a stable, unique decision ID; quote CSV fields correctly; append exactly one row at decision time; then parse the complete CSV to verify column count and round-trip safety for commas, quotes, and multiline text.
- `run_id` identifies the pipeline cycle; `source` points to the artifact, live receipt, or URL that carries the decision's evidence. Use `active`, `superseded`, or `reversed` status rather than deleting history.

**Shared-Drive profile:**

- Find or create `Learning — Decisions — <Client Display Name>.docx` in the canonical `Compound Marketing` folder. Append one row as `| <YYYY-MM-DD> | <Stage> | <Decision> | <Why / rationale> |`.
- Update by download → local edit → trash old → re-upload under the identical title. Update the folder's manual index when creating the doc.

**Error path:** If the selected log is unavailable, unwritable, ambiguous, or fails validation, surface the failure loudly and carry the unlogged decision verbatim in the session's handoff block. Never redirect to the other profile:

```
**PENDING DECISION LOG:** <date> · <stage> · <decision> · <why>
```

**Bypass:** None. Decisions are logged at decision time, not at session wrap. The selected decision log is the first recall surface Step 1 reads on the next run.

---

## Contract Step 6 — Open Items (R9)

**When:** Whenever a stage's artifact carries an unresolved gap — a live tooling defect, a missing data source, an unreconciled discrepancy between two readings, a capability the stage needed and didn't have. This is the same material that used to get buried as freeform prose in a "Gaps" or "Open questions" section; Step 6 makes it a fixed, addressable, machine-checkable list instead.

**Why this exists.** A `/cm-audit` run once wrote 5 flagged gaps as prose, then the handoff block (Step 4) restated them in its own words, and the next session's `/cm-handoff` invocation restated them again in a third form — three descriptions of the same 5 things, drifting slightly each time, with no single place that said which ones were actually closed. Step 6 makes the artifact itself the one place open items live; everything downstream (handoff blocks, resume invocations, the next stage) points at it instead of re-describing it.

**What:** Any stage artifact with unresolved gaps ends with a fixed-shape `## Open Items` section:

```
## Open Items

- **OI-1** — <one-line description of the gap>
  - *Blocking:* yes/no — does this gap invalidate or cap the confidence of a finding elsewhere in this doc, or is it a parallel note that doesn't block downstream use of the rest of the doc?
  - *Owner:* <what closes this — a tool/code fix, a user decision, a live-platform re-read, another team's action>
  - *Closes when:* <the concrete condition that resolves it — not "investigate further," a testable condition>
  - *Status:* open | closed (<date closed, one-line resolution>)

- **OI-2** — ...
```

IDs are stable and local to the artifact (`OI-1`, `OI-2`, ...) — they do not need to be globally unique across documents, only unique within the doc that owns them. Every quantitative finding elsewhere in the doc that Step 2/3 tagged `⚠️ HYPOTHESIS` because of one of these gaps should reference the Open Item by ID (e.g., "see OI-1") rather than repeating the caveat inline — one statement of the caveat, referenced, not restated.

**Resume mode.** A stage that produces a dated artifact (Audit, Analysis, Plan, etc.) should support being re-invoked specifically to close open items from its own prior artifact, without redoing the stage's full scope of work. This is the "resume" half of Step 4's resume-command rule: the stage reads the prior doc's Open Items list, does only the work needed to close the referenced items (verify a tool fix landed, pull the one missing data point, reconcile the one discrepancy), and writes a new dated artifact that explicitly states which Open Items it closes (updating their `Status` to closed with a one-line resolution), which it carries forward still open, and any new ones it found. It does not silently re-run the entire stage from scratch. Each stage skill defines its own Resume Mode step (see `/cm-audit`'s as the reference implementation); a stage with no Resume Mode yet should say so rather than silently lacking the capability.

**Bypass:** A stage whose artifact has no unresolved gaps omits the Open Items section entirely, or states `## Open Items` — `None.` explicitly. Do not write an empty or placeholder Open Items section "just in case" — its presence is itself a signal that something is unresolved.

---

## Client-Facing Stripping Rule

The following are internal scaffolding — strip them from any client-shared artifact:

- Handoff blocks (Step 4)
- Provenance blocks (Step 2 findings)
- Recall digests (Step 1)

The one deliberately client-facing artifact is the **Execution Tracker** (created by `/cm-agent-plan` after the Manifest Gate, kept updated by `/cm-execute` as cards run, per the Marketing Execution Protocol). It has its own format and is shared with client approval.

**Why this rule exists:** Internal QA scaffolding leaking into a client-shared doc is a known failure mode. The rule is explicit: if it's a contract step's output shape, it's internal unless the artifact's spec says otherwise.

---

## Verification

This doc reads standalone. A skill author can implement a compliant stage from it without reading any cm-\* skill. The contract's enforcement is layered:

1. **L1 — Blocking-and-visible instructions** in this doc (every skill loads it).
2. **L2 — Mechanical injection (optional, environment-dependent)** — if your environment supports pre-tool hooks, one can inject a recall reminder automatically before the skill loads (coverage would extend to all eleven cm-\* skills); otherwise the skill's own Step 1 satisfies this layer manually.
3. **L3 — Machine-checkable provenance shape** (the findings block's fixed shape is cross-checked by `/cm-review`'s evidence lens during adversarial review).
4. **L4 — Open Items as the single source of truth** (Step 6's fixed shape is what `/cm-handoff` and every stage's own handoff block read from — a handoff that lists an open item not present in the artifact's Open Items section, or restates findings instead of pointing at the doc, is out of compliance with Step 4).

No runtime hard block mid-run: the gated property is judgment, and a hard block would false-fire on legitimately-unverified hypothesis-stage claims.
