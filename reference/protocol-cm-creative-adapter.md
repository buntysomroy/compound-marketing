# Protocol — Creative Loop Adapter Contract

> **Read by:** `/cm-creative-loop` at Step 0 of every run, and by anyone writing a new adapter.
> **Owns:** the boundary between the generic creative loop and everything specific to one asset type.
> **Does not own:** the loop's steps (the driver, `skills/cm-creative-loop/SKILL.md`), the discovery
> method (`reference/sop-cm-creative-discovery.md`), or the six stage-contract steps
> (`reference/protocol-cm-stage-contract.md`).

The driver runs one asset at a time through discovery, brief, draft, pre-check, approval,
pre-registration, ship, read-back and verdict. It knows nothing about any format, tool, platform or
measure. Everything that does lives in exactly two places:

1. **An adapter** — one file per asset type, `reference/adapter-<asset-type>.md`, filling the six
   slots below. It says what the asset IS and how it is made, checked, shipped, read and compared.
2. **The channel input** — the channel's own contract documents, read at run time: the success
   line, the creative KPI, the outcome KPI, the account guardrail, and the instance bindings (which
   targets are live, which identifiers the ship and read-back steps need). An asset is never ranked
   on another channel's measure. The adapter names WHERE the channel input lives; it never copies
   the values into its generic body. Account-specific bindings go in an instance file in the
   project's `CM Artifacts/` folder, `adapter-<type>-instance-<client>.md`, which the driver reads
   after the adapter; an adapter carries no account data.

A new asset type is a new adapter. It is never an edit to the driver. If filling the six slots
seems to need a driver change, the slot definition below is incomplete: fix this contract, not the
driver.

---

## Preconditions (checked before any draft)

Every adapter opens with a **Preconditions** list: conditions that must hold before the loop may
draft for this asset type (a platform capability that must exist, a stakeholder gate that must be
open, a tracking prerequisite the read-back depends on). The driver checks each one at Step 0.
An unmet precondition becomes an Open Item on the iteration artifact and the driver does not
draft. The channel input must also carry a success line and a measurement contract; if it does
not, run `/cm-channel-discovery` first.

---

## The six slots

Each slot is a level-2 heading in the adapter, `## Slot <n> — <name>`, in this order.

### Slot 1 — Format spec

What a valid candidate is: every format the asset type ships in, each with its dimensions, length,
character count, duration or file limits, and the token used in filenames (`<format>` in
`<run>-it<NN>-<format>-<hypothesis-slug>.<ext>`). **Cite the owning spec; do not copy it.** If the
spec lives in an installed lens or a project document, point at it by path and section.

### Slot 2 — Policy and quality checklist

A numbered list of pass/fail lines the pre-check runs against every draft, each line testable by
looking at the draft. It must include:

- a **render check at placement scale** (how the asset looks where it actually appears, not at
  design size), run with `visual-spot-check` where installed;
- an **intended-viewer fit line**: who the asset is for, and the test that fails a draft someone
  outside that audience could mistake as meant for them.

The checklist grows. Any rejection cause, once known, and any quality failure a verdict names,
becomes a new line (driver Step 11). Lines learned on one client's instance are appended to that
run's ledger under `## Checklist additions` and are read by every later pre-check in that run; a
line that holds for the asset type on any account is promoted into this slot by the driver's
self-update directive.

### Slot 3 — Production method options

The ways a candidate can be made, each with the installed lens or skill that owns its craft and
what it costs in time. The driver chooses one per brief, after discovery, and records the choice.
Production craft is never restated here; point at the lens.

### Slot 4 — Ship tool and approval-gate mechanism

How an approved candidate reaches the live channel. It must implement the **one-write-per-target
invariant**:

1. **Create once.** The asset is created in the platform exactly once, as its own write.
2. **Report the returned identity.** The create step records the identifier the platform returned
   and whether that identifier is new or an existing asset the platform matched. Any later write
   uses the returned identifier and never assumes it is new.
3. **One write per target.** Each target the asset attaches to gets its own write, approved on its
   own. No write covers two targets. No write is bundled with unrelated changes.
4. **Per-action approval.** Every write passes through the channel's approval gate (a staged queue
   with per-row approval, or a `/cm-agent-plan` → `/cm-execute` manifest). The adapter names which.
5. **Floors.** Name the minimum-count, drift and ownership guards the write tool enforces, and what
   the loop does when one refuses.

The slot also names the **quiet-window check**: how to read the target's recent structural changes,
and what counts as structural. The driver refuses to ship within 48 hours of one unless the
artifact names the confound. And it names the **fallback** if the ship tool is unavailable.

### Slot 5 — Read-back query and verdict thresholds

How the shipped asset is read, at three checkpoints the driver schedules:

| Checkpoint | Default offset from the target writes executing | Reads |
| --- | --- | --- |
| Review gate | 72 hours | whether the platform accepted the asset, and why not |
| Early read | 7 days | serving share and the creative KPI against siblings |
| Full read | 14 days | the same, plus the outcome KPI and the guardrail |

The slot names the query or tool for each checkpoint, the interim method if the preferred tool is
not live yet, the reminder mechanism that surfaces each checkpoint when due, and the numeric
thresholds the verdict step applies:

- the **asset kill floor** (below what serving share, over what volume, the asset is killed);
- the **minimum volume** for any creative-KPI claim, and what the read says below it
  (`underpowered`, extend, or pool);
- the **direction retirement count** (how many consecutive rejections retire a hypothesis);
- how the **guardrail** is read and what band counts as worsened.

Offsets may be overridden here; the driver uses the defaults when the slot is silent.

### Slot 6 — Sibling set and slot inventory

What the asset is compared against, and what slots exist:

- **Sibling set:** the set a new asset's measures are compared within (for example, same format in
  the same target). Comparisons never cross sets, and asset-attributed measures are never summed
  into a total.
- **Slot inventory and order:** every `(format, target)` slot the loop must fill, in the order it
  fills them.
- **Loop done:** the condition under which the loop for this asset type is finished.

---

## Fill-in template

Copy this into `reference/adapter-<asset-type>.md` and fill every `<...>`.

```markdown
# Adapter — <asset type> (<channel>)

> Instance of `reference/protocol-cm-creative-adapter.md`. Driver: `/cm-creative-loop`.
> **Channel input:** <where the success line, KPIs, guardrail and instance bindings are read from>.

## Preconditions
- <condition> — checked by <how>

## Slot 1 — Format spec
| Format | Spec (cited) | Filename token |
| --- | --- | --- |
| <format> | <path § section> | <token> |

## Slot 2 — Policy and quality checklist
1. <testable line>
2. Render check at placement scale via `visual-spot-check`.
3. Intended viewer: <who>. Fails if <test>.

## Slot 3 — Production method options
| Method | Lens / skill | Typical time |
| --- | --- | --- |
| <method> | <lens> | <time> |

## Slot 4 — Ship tool and approval-gate mechanism
- Create: <tool>, reports <returned identity + new-or-existing>.
- Per-target write: <tool>, one per target, approved via <gate>.
- Floors: <guards and what happens when one refuses>.
- Quiet-window check: <how>; structural means <list>.
- Fallback: <if the ship tool is unavailable>.

## Slot 5 — Read-back query and verdict thresholds
| Checkpoint | Offset | Query / tool | Interim method |
| --- | --- | --- | --- |
| Review gate | <offset> | <query> | <interim> |
| Early read | <offset> | <query> | <interim> |
| Full read | <offset> | <query> | <interim> |
- Reminder mechanism: <how each checkpoint surfaces when due>.
- Asset kill floor: <rule>. Minimum volume: <rule>. Direction retirement: <count>. Guardrail: <rule>.

## Slot 6 — Sibling set and slot inventory
- Sibling set: <definition>.
- Slot inventory, in order: <(format, target) list or rule>.
- Loop done: <condition>.
```

---

## Completeness check

An adapter is runnable when all of these hold. Check them before the driver uses a new adapter:

1. A `## Preconditions` section exists (it may say `None.`).
2. Exactly six `## Slot <n> —` headings exist, numbered 1 to 6 in order:
   `grep -c '^## Slot [1-6] —' reference/adapter-<asset-type>.md` prints `6`.
3. Slot 2 contains a render-check line and an intended-viewer fit line.
4. Slot 4 names a create step that reports the returned identity, a per-target write, the approval
   gate, and a fallback.
5. Slot 5 names a query for all three checkpoints and all four thresholds.
6. Slot 6 names the sibling set, the slot order, and the loop-done condition.
7. No template placeholder is left unfilled. Filename shapes such as `<run>-it<NN>-...` are
   patterns, not placeholders, and may stay.
