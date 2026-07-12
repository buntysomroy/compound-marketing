---
name: cm-review
description: "Use when you say '/cm-review', 'review the marketing plan', 'adversarial review', 'stress-test the plan', 'check the plan before we execute', 'is this plan solid', 'pressure-test this plan', or after /cm-plan produces a plan doc. Compound Marketing — the REVIEW stage (Stage 4). Adversarial multi-lens review of an insights doc + marketing plan before execution. Dispatches 4 parallel lens agents (evidence, measurement, ownership, brand/client) and synthesizes findings."
---

# /cm-review — Compound Marketing: Review stage

> **Where this sits.**
> `/cm-audit` (Stage 1) → `/cm-analyze` (Stage 2) → `/cm-plan` (Stage 3) → **`/cm-review` (this)** → `/cm-execute` (Stage 5).
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the five contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging) are mandatory for this stage. This skill is the thin driver; do not improvise contract mechanics from memory.
>
> Full pipeline reference: `reference/sop-cm-pipeline.md`

This is the **review stage** — adversarially probe the plan before any execution resource is committed. Four independent lenses each review the same artifact for a different failure mode. Findings fold back into the plan or become Open questions for you. Nothing proceeds to Stage 5 without an approval gate here.

The 4 lens agents (`cm-lens-*`) are `/cm-review`'s lenses — generalized to be channel-agnostic and work on any CM analysis or plan artifact. (Single-problem work routes through `/cm-plan` single-problem mode → here.)

## Step 1 — Read the inputs

**Required inputs:**

1. **The plan doc** — the `<Client> — Plan — <Channel> — <date>` Google Doc in the flat `Compound Marketing` Drive folder (Stage 3 output; find by searching your marketing docs store — Google Drive, etc.)
2. **The insights doc** — the `<Client> — Analysis — <Channel> — <date>` Google Doc in the same folder (Stage 2 output) — the plan flows from it; reviewers need both.

Read both docs fully. Then compose a single merged artifact block combining the key sections (Success line, Action plan table, Budget impact, What this plan doesn't address) from the plan doc with the "What to change" table and Watch-outs from the insights doc.

## Step 2 — Dispatch all 4 lens agents IN PARALLEL

**CRITICAL: embed the FULL merged artifact text inline in each agent prompt between `<ARTIFACT>` and `</ARTIFACT>` markers.** Never pass only the file path — the agents are hard-gated to refuse a path-only task (they learned from the single-problem flow's first dogfood run where a path-only dispatch produced hallucinated reviews).

Dispatch these 4 agents simultaneously in a single message with 4 Agent tool calls:

1. **`cm-lens-evidence`** — Are all claims grounded in cited numbers from the actual account data? Does the plan's projected impact have a data basis?
2. **`cm-lens-measurement`** — Does every action have a named success signal with a measurable threshold and an observable source? Anything without "we'll see X metric move to Y in Z days" is flagged.
3. **`cm-lens-ownership`** — Is every action's owner accurate? Does the assigned owner (You / Copilot / Vendor / Auto) actually have the authority and access to execute it?
4. **`cm-lens-brand-client`** — Are there positioning conflicts, channel cannibalization risks, or client-framing issues? Is any client-facing language not ready to send?

Each agent returns a JSON array of findings: `[{"claim": "...", "verdict": "...", "severity": "P0|P1|P2|P3", "confidence": 0-100, "fix": "..."}]`.

## Step 3 — Synthesize findings

After all 4 agents return:

1. **Triage by severity:**
   - **P0** — plan is not executable as written; must be fixed before Stage 5
   - **P1** — significant issue; strongly recommend fixing; can proceed with explicit acknowledgment
   - **P2** — notable gap or risk; surface as Open question for you
   - **P3** — minor / informational; include in watch-outs

2. **De-duplicate** findings that multiple lenses raised (common: measurement and evidence both flag an ungrounded projection).

3. **Fill the Lens Review Summary block** (to be appended to the plan doc):

```markdown
## Lens Review Summary — <date>

| Finding | Lens        | Severity | Verdict     | Fix                                            |
| ------- | ----------- | -------- | ----------- | ---------------------------------------------- |
| ...     | Evidence    | P1       | unsupported | Cite the specific campaign data, not aggregate |
| ...     | Measurement | P0       | missing     | Add success signal to Action #3                |

### Confirmed P0/P1 fixes applied

- [list of changes made to the plan doc]

### Open questions for you

- [P1/P2 items that need a human decision rather than a mechanical fix]
```

Apply confirmed fixes directly to the plan doc. List unresolved items as Open questions.

## Step 4 — Approval gate

Present the synthesis inline. Then:

- If there are **P0 findings**: do NOT offer to proceed. Show the blocking issues and offer to fix them now.
- If P1/P2 only: offer to proceed via `AskUserQuestion`:
  - **Proceed to /cm-execute** — plan looks good enough; take it to execution mapping
  - **Fix open questions first** — address the P1/P2 items before Stage 5
  - **Cancel** — plan needs a full rethink; go back to Stage 3

Never proceed to Stage 5 without an explicit Approve response.

## Self-update directive

When this run catches a finding class the lenses missed (e.g., a spend-cap miscalculation, a missing pre-flight step), note it here as a future lens improvement. The review stage compounds: each run improves the review criteria.
