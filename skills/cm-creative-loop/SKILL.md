---
name: cm-creative-loop
description: >-
  I invoke this when the next piece of work is to produce ONE creative asset for a live channel and
  learn from it before choosing the next one: a /cm-plan action whose type is "produce creative", a
  previous creative verdict of keep-and-extend or revise, a slot in a creative asset ledger that still
  needs filling, or a creative-iteration artifact to resume at its next checkpoint. Compound Marketing
  — the CREATIVE LOOP companion play. Runs one iteration (discovery, brief, draft, pre-check, owner
  approval, pre-registration, staged ship, read-back, verdict) against a per-asset-type adapter and
  the channel's own contract, and writes a resumable iteration artifact plus an asset ledger. Not for
  a batch of variations with no read-back, and not for a measured A/B test (that is /cm-experiment).
---

# /cm-creative-loop — Compound Marketing: Creative Loop companion play

> **Where this sits.**
> NOT a numbered pipeline stage. A **companion play**, like `/cm-experiment`, entered from a
> `/cm-plan` (Stage 3) action whose type is "produce creative", from `/cm-agent-plan` (Stage 5a) or
> `/cm-execute` (Stage 5b) for the ship step, from a `/cm` routing row, or standalone. It produces
> one **iteration artifact** per asset, keeps one **asset ledger** per run, and feeds `/cm-compound`.
>
> **Stage contract (read FIRST, every run):** `reference/protocol-cm-stage-contract.md` — the six
> contract steps (decisions recall, findings confirmation, quantitative-claim rule, handoff block,
> decision-time logging, open items) are mandatory for this play. This skill is the thin driver; do
> not improvise contract mechanics from memory.
>
> Adapter contract (the six slots, the one-write-per-target invariant): `reference/protocol-cm-creative-adapter.md`
> Discovery method (interview, gut-check, reference-and-beat, brand-and-source kit): `reference/sop-cm-creative-discovery.md`
> Adapters, one per asset type: `reference/adapter-<asset-type>.md`
> Fixture dry runs (re-run after every revision of this file): `docs/fixtures/creative-loop/README.md`

One iteration makes exactly one asset and closes only when its verdict is written. This file names
no format, tool, platform or measure. Everything specific to an asset type comes from its
**adapter**; everything specific to a channel (success line, creative KPI, outcome KPI, guardrail,
live targets and identifiers) comes from the **channel input**, read from the channel's own
contract documents at run time. If a step below seems to need a channel detail, read it from one of
those two; never supply it from memory.

## Lenses this driver reuses (never restated here)

- `marketing-skills:ad-creative` **Mode 4** (creative strategy loop) for the brief and the verdict:
  concept shape, the six-tier evidence scale in its `references/creative-roadmap.md`, and the retro.
  **Mode 2** (iterate from performance data) when a brief extends or revises a read-back.
- `visual-spot-check` for the render check at placement scale and for reading back what the
  platform kept.
- `gut-check` for the discovery gut-check (method in the discovery SOP).
- `/cm-experiment`'s **pre-registration discipline** (hypothesis, checkpoints and kill rule written
  before anything goes live). Its A/B mechanics are not used.
- Production lenses are named by the adapter's Slot 3, not here.

## Fixed refusal lines

When a guard below fires, print the line exactly as shown, with the brackets filled, on its own
line, then stop that step. Never soften a refusal into prose.

- `REFUSED (missing constraint): brief <NN> does not cite the constraint line from iteration <MM>: "<line>"`
- `REFUSED (slot in read-back): <format> / <target> holds iteration <MM> in read-back until <date>; open slots: <list>`
- `REFUSED (precondition): <precondition> is not met; recorded as <OI-id>; no draft`
- `REFUSED (pre-check failed): <checklist line> failed; returning to draft`
- `REFUSED (not pre-registered): no pre-registration block; nothing is staged`
- `REFUSED (quiet window): <structural change> on <date> is inside 48 hours; wait until <date> or name the confound`
- `REFUSED (batched interview): discovery questions go to the owner one per turn; asking only: "<next question>"`

---

## The flow

### Step 0 — Resolve the run, the adapter and the mode

1. Resolve the artifact workspace profile per `reference/sop-cm-pipeline.md` (project-local
   `CM Artifacts/` is the normal case). Record `project_slug` and `run_id`.
2. **Mode.** If invoked on an existing iteration artifact, or the ledger shows an open iteration
   the user is continuing, go to **Resume Mode** below. Otherwise this is a new iteration.
3. **Adapter.** Read the adapter the artifact's `Adapter:` field names, or the one for the asset
   type the plan action names. If the field is absent, infer it from the asset type and write the
   field into the artifact. If no adapter exists for the asset type, create one from the template
   in `reference/protocol-cm-creative-adapter.md` and pass its completeness check first; do not
   edit this file to make room for it.
   Then read the account's instance file, `CM Artifacts/adapter-<type>-instance-<client>.md`, if
   the adapter names one; account-specific values come from there, never from the adapter.
4. **Channel input.** Read the channel contract documents the adapter's header names. Confirm they
   carry a success line and a measurement contract; if not, run `/cm-channel-discovery` first.
5. **Preconditions.** Check every line in the adapter's `## Preconditions`. Any unmet → print
   `REFUSED (precondition)`, record an Open Item on the artifact, and stop before drafting.

### Step 1 — Decisions recall (contract Step 1)

Run contract Step 1. Then read, in this order: the run's asset ledger
(`<project-slug>-<run-id>-creative-asset-ledger.md`), every prior iteration artifact of this run,
and `<project-slug>-decisions.csv`. List the constraint lines of every **closed** iteration, each
with its iteration number. These are the lines the brief must cite.

### Step 2 — Choose the slot and apply the overlap guard

Take the next open slot from the adapter's Slot 6 order, or the slot the plan action names. A slot
is one `(format, target)` pair; its sibling set is the adapter's definition.

**Overlap guard.** Iterations may overlap only across different sibling sets. If the ledger shows
any iteration on this slot whose status is not `CLOSED` (it is drafting, staged or in read-back),
print `REFUSED (slot in read-back)`, list the open slots in Slot 6 order that hold no unclosed
iteration, and offer them. The `<date>` is the held iteration's full-read date from its
`## 7. Pre-registration` (the slot stays held until that verdict); if its artifact cannot be found,
use the date in its ledger status and say so. Do not write a brief for the refused slot.

### Step 3 — Discovery

Run `reference/sop-cm-creative-discovery.md`: the owner interview, the gut-check, the inspiration
sweep with its reference-and-beat record, and the brand-and-source kit on the first run. Write
sections `## 1. Discovery` and `## 2. Reference-and-beat` of the iteration artifact.

**The interview is one question per turn**, each chosen in light of the previous answer: never a
numbered batch, never two questions in one message or one multiple-choice call. If anyone asks for
the questions all at once, print `REFUSED (batched interview)` and ask only the next question.

### Step 4 — Brief (findings confirmation)

Use `marketing-skills:ad-creative` Mode 4 to shape the concept (Mode 2 when extending or revising
a read-back). Write `## 3. Brief` with every field:

| Field | Content |
| --- | --- |
| Slot | format and target set, from Step 2 |
| Hypothesis | one line: what this asset tests |
| Evidence tier | 1–6 on the `ad-creative` roadmap scale, with the evidence named |
| Intended viewer and fit | who it is for, and how the asset signals that fit (the adapter's fit line) |
| Inherited constraints | every constraint line from Step 1, verbatim, each tagged with its iteration; on the first iteration, `None yet — first iteration` |
| Success line and creative KPI | from the channel input, with the document it came from |
| Reference to beat | from `## 2. Reference-and-beat` |
| Production method | from the adapter's Slot 3, chosen after discovery, with the reason |
| Kit citations | the brand-and-source kit entries the brief uses |

**Brief check (this is the findings-confirmation gate, contract Step 2).** Before showing the
brief, compare its inherited constraints against the Step 1 list. If any closed iteration's line is
absent, print `REFUSED (missing constraint)` for each one and fix the brief before going on. Then
render the brief for the owner and wait for confirmation.

### Step 5 — Draft

Produce the candidate in the adapter's Slot 1 format spec, by the chosen method, using the lens
Slot 3 names. Save it to the project's `assets/` folder as
`<run>-it<NN>-<format>-<hypothesis-slug>.<ext>`. Write `## 4. Draft record`: file path, method,
lens used, and what was changed on each attempt.

### Step 6 — Pre-check

Run every line of the adapter's Slot 2 checklist **plus** every line under the ledger's
`## Checklist additions`, one by one, each with pass or fail and the evidence (what was looked at).
The render check runs at placement scale via `visual-spot-check`. Any fail → print
`REFUSED (pre-check failed)`, record the attempt in `## 5. Pre-check`, and return to Step 5. A
failed pre-check never goes to ship.

### Step 7 — Owner approval

The channel owner approves brand, policy and creative. Record under `## 6. Approval` the date, the
file approved, and the owner's words verbatim. Nothing is staged before this line exists.

### Step 8 — Pre-registration

Before any ship write, write `## 7. Pre-registration`: the hypothesis, the three checkpoint dates
(from the adapter's Slot 5 offsets, dated from the expected execution of the target writes), the
kill rule with the adapter's thresholds filled in, the guardrail and the band that counts as
worsened. If this block is missing when Step 9 starts, print `REFUSED (not pre-registered)`.

### Step 9 — Ship

1. **Quiet window.** Run the adapter's quiet-window check on every target. A structural change
   inside 48 hours → print `REFUSED (quiet window)` and either wait or, if the owner decides to
   ship anyway, name the confound in the pre-registration block and every read-back.
2. **Create once.** Stage the adapter's create write through its approval gate. After it executes,
   record the identifier the platform returned and whether it is new or an existing match. Every
   later write uses that identifier.
3. **One write per target.** For each target, stage one write through the approval gate, each
   approved on its own. Never bundle targets or unrelated changes.
4. Record every write's identifier and status under `## 8. Ship`. When the target writes execute,
   register the three checkpoints with the adapter's reminder mechanism and set the artifact's
   `Status:` to `IN READ-BACK — next checkpoint: <name> <date>`.

### Step 10 — Read-back

At each checkpoint, run the adapter's Slot 5 query and record the rows under `## 9. Read-back`,
one row per checkpoint: date, window, the raw values with their denominators (contract Step 3),
the comparison against the sibling set, and the adapter's power verdict (`ok`, `underpowered`,
`underpowered-pooled`). Compare only within the sibling set; never add asset-attributed values into
a total. Update the `Status:` line to the next checkpoint.

### Step 11 — Verdict

Write `## 10. Verdict` with exactly one of four verdicts, the evidence, and a constraint line:

| Verdict | When |
| --- | --- |
| **keep and extend** | the asset passes and its concept earns a sibling |
| **keep and stop** | the asset passes and the slot is filled |
| **revise** | same hypothesis, new execution; always the verdict for a first rejection with a readable cause |
| **kill** | the hypothesis is retired: a second rejection on the same cause, a kill-floor miss at the full read, or the adapter's direction-retirement count reached |

- **Constraint line (mandatory).** One line starting `Constrains next brief:` that the next brief
  must cite. A verdict without one is not written.
- **Checklist growth.** A rejection cause, once known, or a named quality failure, is appended to
  the ledger's `## Checklist additions` with its iteration number.
- **Guardrail.** An asset that improves the creative KPI while the guardrail worsens past its band
  is flagged in the verdict and is not kept by default.
- **Kill** also marks the hypothesis `retired` in the ledger.

Set `Status:` to `CLOSED — <verdict>`.

### Step 12 — Close

1. Update the ledger row: status, platform identifier, verdict, constraint line.
2. Log every decision the owner made to `<project-slug>-decisions.csv` at decision time (contract
   Step 5), not in a batch at the end.
3. Hand a pattern-level learning to `/cm-compound`.
4. Write `## Open Items` (contract Step 6); IDs are `OI-<NN>-<n>`, local to the iteration.
5. Emit the handoff block (contract Step 4). A blocking Open Item makes the first step this play's
   resume command: `/cm-creative-loop — resume "<artifact filename>"`.

---

## Resume Mode

Invoked on an iteration artifact, with no transcript. The artifact alone is enough.

1. Read the `Status:` line, then every numbered section, and find the last one that is complete.
2. Continue from the next step. Never re-run discovery or the brief once `## 3. Brief` is approved;
   never re-stage a write the `## 8. Ship` section records as staged or executed.
3. If the status is `IN READ-BACK`, run only the named next checkpoint (Step 10), and only if its
   date has arrived; if it has not, report the date and stop.
4. Close any Open Item the resumed work resolves (status `closed (<date>, <resolution>)`), carry the
   rest forward unchanged, and add any new ones.

## Artifacts

### Iteration artifact

`CM Artifacts/<project-slug>-<run-id>-<YYYY-MM-DD>-creative-iteration-<NN>.md`. The date is the
creation date; later edits keep the filename.

```markdown
<!-- cm:creative-iteration -->
# Creative Iteration <NN> — <slot> — <client> — <YYYY-MM-DD>

- **Run:** `<project-slug>-<run-id>` · **Iteration:** <NN>
- **Adapter:** `reference/adapter-<asset-type>.md`
- **Slot:** <format> in <target set>
- **Target groups:** <targets, from the channel input>
- **Owner and approver:** <name>
- **KPIs:** creative KPI, outcome KPI, guardrail, each with its source document and baseline window
- **Status:** <one of the status values below>

## 1. Discovery
### (a) Interview
### (b) Gut-check
### (c) Inspiration sweep
## 2. Reference-and-beat
## 3. Brief
## 4. Draft record
## 5. Pre-check
## 6. Approval
## 7. Pre-registration
## 8. Ship
## 9. Read-back
| Checkpoint | Due | Read on | Window | Values (with denominators) | Sibling comparison | Power |
| --- | --- | --- | --- | --- | --- | --- |
## 10. Verdict
## Open Items
```

Status values, in order: `DISCOVERY IN PROGRESS` · `BRIEF PENDING APPROVAL` · `DRAFTING` ·
`PRE-CHECK` · `AWAITING APPROVAL` · `PRE-REGISTERED` · `SHIP STAGED` ·
`IN READ-BACK — next checkpoint: <name> <date>` · `CLOSED — <verdict>`.

Extra header fields a run adds (plan unit, plan path) are kept; Resume Mode ignores fields it does
not know. A section a run has not reached may hold `_Pending._`.

### Asset ledger

`CM Artifacts/<project-slug>-<run-id>-creative-asset-ledger.md`, updated in place.

```markdown
# Creative Asset Ledger — <project-slug>-<run-id>

| Iteration | Asset file | Slot | Platform id | Status | Verdict | Hypothesis | Hypothesis status | Constraint line |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

## Checklist additions
- (iteration <NN>) <line>
```

Asset files live in the project's `assets/` folder; the ledger row carries the platform identifier
once the create executes.

## Close — session-wrap offer (R10)

If this session settled a durable creative decision, produced an asset the owner reworked before
approving, or surfaced a pattern worth carrying forward, offer `/cm-session-review` as the wrap
step: "This session settled something worth capturing — run `/cm-session-review` to mine the
learnings and close the CM loop."

## Self-update directive

After each of the first three iterations of any instance, revise this file (or the adapter, or
the discovery SOP) with what the iteration taught, before the next iteration runs. After every
revision, re-run the fixture dry runs in `docs/fixtures/creative-loop/README.md` and record each
one's pass or fail in the iteration artifact that prompted the revision. A revision that makes any
dry run fail is not used until it passes. A checklist line that holds for the asset type on any
account moves from the ledger's `## Checklist additions` into the adapter's Slot 2.
