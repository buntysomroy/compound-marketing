# CM Stage Contract

> **Cross-cutting behavioral contract for all cm-\* skills.** Every stage skill reads this FIRST, every run. The skill is the thin driver; this doc is the canonical spec for the five contract steps. Do not improvise contract mechanics from memory.
>
> Pipeline reference (stage order, artifact naming, Drive mechanics): `reference/sop-cm-pipeline.md`. This doc does not restate pipeline mechanics — it defines the per-stage behavioral gates.

---

## Scope

This contract applies to every cm-\* stage skill: `/cm-audit`, `/cm-analyze`, `/cm-plan`, `/cm-review`, `/cm-execute`, `/cm-experiment`, `/cm-compound`, `/cm-analytics-audit`. The front-door dispatcher (`/cm`) and the standalone handoff skill (`/cm-handoff`) bind via their own Step 0, which loads this contract and runs its recall step once before routing. The session-wrap trigger (`/cm-session-review`) references this contract but is not itself a pipeline stage (it does not produce a Drive artifact; it invokes `/cm-compound` for the actual write).

**Legitimate bypass.** A stage may skip a contract step only when the step's own bypass note permits it. No other reason qualifies. If a step cannot fire (tool unavailable, data missing), the stage surfaces the failure loudly and carries the gap in its handoff block — it does not silently skip.

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
```

**Worked example (passes the gate):**

```
### Finding 1: 4 hard bounces persist across reads

- **Source:** email-processing log (inbox pipeline record), 2026-07-09
- **Denominator + coverage:** 4 bounces on 81 of 580 processed emails (14% coverage); full-segment bounce rate unknown
- **Proxy validity:** Direct measure — hard bounces are observed, not inferred
```

**Worked example (fails the gate):**

```
### Finding 1: 6.67% bounce rate

- **Source:** ??? (no denominator stated)
- **Denominator + coverage:** NOT STATED — headline rate without coverage
- **Proxy validity:** Cannot assess without knowing what was measured
```

The second example fails because the headline rate has no denominator, no coverage, and no source. The stage must restate it as "4 bounces on 81 of 580 processed (14% coverage)" before the gate passes.

**Bypass:** Hypothesis-stage findings (explicitly marked as such by the stage — e.g., cm-audit data-gathering that flags items as "unverified hypothesis") may render the findings block with a `⚠️ HYPOTHESIS — not yet verified` tag and proceed without blocking. The tag must be present; untagged unverified claims fail the gate.

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

**Output shape:**

```
## Handoff — <Stage> complete

**What was done:**
- <1-2 lines summarizing the stage's work>

**Artifacts:**
- <artifact type> — <doc title> (Drive link or path)
- ...

**Evidence (with provenance):**
- <finding> (Source: <source>; Denominator: <coverage>)
- ...

**Decisions made:**
- <date> · <stage> · <decision> — <why>
- ...

**Carried-over context (for the next stage):**
- <what the next stage needs to know without re-deriving>

**Don't repeat (confirmed findings, closed questions):**
- <what's settled and should not be re-opened>

**First step (next stage entry prompt):**
- `<next-stage-invocation>` — <one-line reason>
```

**Rendering:** Inline in chat, always. A file copy is optional and never a replacement. The handoff block is internal scaffolding — strip it from any client-shared artifact (see Client-Facing Stripping Rule below).

**Bypass:** None. Every stage emits a handoff block, even if the stage produced no artifact (e.g., cm-compound invoked with nothing to capture → handoff block says "no learning captured this run").

---

## Contract Step 5 — Decision-Time Logging (R8)

**When:** At the moment a decision is made — during AskUserQuestion answers, chat confirmations, or any explicit choice the user makes.

**What:** Append the decision to the per-engagement `Learning — Decisions — <Client Display Name>` Google Doc in the Compound Marketing folder. One line per decision:

```
| <YYYY-MM-DD> | <Stage> | <Decision> | <Why / rationale> |
```

**Format:**

- Find or create the `Learning — Decisions — <Client Display Name>` doc. If it exists, append a new row; if not, create it (no date in the title — this doc is perpetual, one per client).
- After appending, update the folder's `CLAUDE.md` index if this is a new doc.

**Error path:** If the Drive tools are unreachable or the append fails, surface the failure loudly (never skip silently) and carry the unlogged decision verbatim in the session's handoff block as a pending-log item:

```
**PENDING DECISION LOG:** <date> · <stage> · <decision> · <why>
```

**Bypass:** None. Decisions are logged at decision time, not at session wrap. The decisions doc is inside the recall surface (Step 1 reads it first), closing the loop for the next stage.

---

## Client-Facing Stripping Rule

The following are internal scaffolding — strip them from any client-shared artifact:

- Handoff blocks (Step 4)
- Provenance blocks (Step 2 findings)
- Recall digests (Step 1)

The one deliberately client-facing artifact is the **Execution Tracker** (produced by `/cm-execute` per the Marketing Execution Protocol). It has its own format and is shared with client approval.

**Why this rule exists:** Internal QA scaffolding leaking into a client-shared doc is a known failure mode. The rule is explicit: if it's a contract step's output shape, it's internal unless the artifact's spec says otherwise.

---

## Verification

This doc reads standalone. A skill author can implement a compliant stage from it without reading any cm-\* skill. The contract's enforcement is layered:

1. **L1 — Blocking-and-visible instructions** in this doc (every skill loads it).
2. **L2 — Mechanical injection (optional, environment-dependent)** — if your environment supports pre-tool hooks, one can inject a recall reminder automatically before the skill loads (coverage would extend to all eleven cm-\* skills); otherwise the skill's own Step 1 satisfies this layer manually.
3. **L3 — Machine-checkable provenance shape** (the findings block's fixed shape is cross-checked by `/cm-review`'s evidence lens during adversarial review).

No runtime hard block mid-run: the gated property is judgment, and a hard block would false-fire on legitimately-unverified hypothesis-stage claims.
