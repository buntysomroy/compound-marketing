# SOP: Compound Marketing (CM) Pipeline

> **Reference doc for all CM skills and agents.** Each stage's SKILL.md points here for architecture and routing decisions. Read this when building new CM stages or when a stage needs to hand off to the next.
>
> **Requirements / north-star:** `protocol-compound-marketing.md`

---

## What is Compound Marketing?

A staged, data-grounded pipeline of marketing skills + agents that does for _marketing fulfillment_ what Compound Engineering does for software. Each stage produces a durable artifact the next stage consumes. Learnings compound back into the system over time.

**Not a flat library of prompts.** Corey Haines' `marketing-skills:*` (the installed plugin) = tactical lenses. CM orchestrates those as sub-tools. CM is the pipeline; `marketing-skills` is a component.

---

## The 5-stage pipeline

```
Stage 1      Stage 2       Stage 3     Stage 4       Stage 5
/cm-audit    /cm-analyze   /cm-plan    /cm-review    /cm-execute
(Audit)      (Analyze)     (Plan)      (Review)      (Execute)
    ↓            ↓             ↓            ↓             ↓
audit.md     analysis.md   plan.md     plan.md       build-plan.md
                                     (with Lens      (execution
                                   Review Summary)     ready)
```

Each arrow = a durable doc artifact: a **user-friendly doc** in a single parent folder **`Compound Marketing`** (flat — no subfolders) in your marketing docs store (Google Drive, etc.). Everything the `/cm*` suite writes (audit, analysis, plan, build-plan, and `/cm-compound` learnings) lands there, named so the client/type/channel/date are legible in a flat list. (One `Compound Marketing` parent, flat, user-friendly docs — not per-client repo markdown.)

> **Validated core vs candidate stages.** `cm-analyze → cm-plan → cm-review` is the proven 3-stage strategy chain (each consumes the prior). `cm-audit` (Stage 1) and `cm-execute` (Stage 5) are **candidate stages** per the requirements doc — kept as working skills, but `cm-audit` is largely an extraction of `cm-analyze`'s own data-read and `cm-execute` is the framework-only execution bridge. They earn their full pipeline weight as a real engagement proves the seam.

---

## Artifact naming convention

All CM artifacts are **docs in the single flat folder `Compound Marketing`** in your marketing docs store (Google Drive, etc.) — resolve it once by searching your marketing docs store; create the folder if absent. Create the docs via your docs-store tool (or markdown → a doc-formatter) — NOT as repo files.

**Flat doc title format** — ordered **broad → detailed, left to right** (Type → Channel/Topic → Client → Date), so a flat alphabetical list groups by Type then Channel:

```
<Type> — <Channel / Topic> — <Client Display Name> — <YYYY-MM-DD>
```

e.g. `Plan — Google Ads — <Client Display Name> — 2026-06-29`
e.g. `Learning — Channel Prioritization — <Client Display Name> — 2026-06-29`

| Type         | Stage | Produced by    |
| ------------ | ----- | -------------- |
| `Audit`      | 1     | `/cm-audit`    |
| `Analysis`   | 2     | `/cm-analyze`  |
| `Plan`       | 3     | `/cm-plan`     |
| `Build Plan` | 5     | `/cm-execute`  |
| `Learning`   | —     | `/cm-compound` |

Stage 4 (`/cm-review`) appends a `## Lens Review Summary` section to the Stage 3 `Plan` doc rather than producing a separate doc.

> **Authoring check:** When writing or updating a CM skill's artifact location, it MUST be a doc in the flat `Compound Marketing` folder (in your marketing docs store) with the title format above — **Type first (broadest), then Channel/Topic, then Client, then ISO date** (broad → detailed, left to right). Per-client subfolders and per-client repo `*.md` paths are **retired** — the read-back (and `cm-learnings-researcher`) search the flat folder, filtering by `<Type>` + `<Client Display Name>` in the title.

> **Storage tradeoff & access (docs-store-only, hardened).** These are docs in your marketing docs store (user-friendly for you + clients), NOT repo markdown. The tradeoff: a cloud doc (e.g. a Google Doc) may have **no readable bytes on disk** — a local Drive mount holds only a `.gdoc` JSON pointer, so `Read`/`grep`/`cat` on it returns a stub and silently "succeeds" with zero content. Content is then reachable **only via your docs-store tool** (search → read document). This is **less robust than a plain repo `.md`** (which any session just `Read`s) — it depends on the docs-store connector being available, so it is fragile in headless/cron runs. The docs-store choice trades robustness for human-friendliness; the cost is mitigated by `cm-learnings-researcher`'s two guards: **(1)** content access is strictly via the docs-store tool, never a filesystem `.gdoc` read; **(2)** a connector failure surfaces as a loud "could not reach — learnings may exist, don't assume a clean slate" caveat, never a silent "no learnings." If headless recall ever becomes load-bearing, revisit dual-write (repo `.md` mirror) then.
>
> **Cold-session breadcrumb — `CLAUDE.md` in the folder.** The folder also holds a plain-text **`CLAUDE.md`** (real bytes — readable on a plain `ls`/`Read`, unlike a `.gdoc` pointer) that documents the read-recipe + title convention + a live index of Learning docs. A fresh agent orienting in the folder reads the in-folder guide first, on its own (it quotes the marker and follows the "`.gdoc` is a pointer → read via the docs-store tool" recipe). **Location matters (in-folder is read, a parent-dir guide is skipped), not the filename**; nothing auto-loads from a docs-store path outside the repo tree, so this is read by agent instinct, not the harness. It is the filesystem safety net for a cold session that lands in the folder WITHOUT the `cm-learnings-researcher` agent; `/cm-compound` keeps its `## Index of Learning docs` current (Step 5). **Do NOT symlink the folder into the repo to try to auto-load this `CLAUDE.md`** — reading a file through a repo symlink that points OUTSIDE the repo does NOT trigger the directory-CLAUDE.md auto-load. The breadcrumb is read by agent instinct on `ls`/orientation, not by auto-load.

---

## Channel specialist agents

Stage 2 delegates the deep channel read to a channel-specialist agent **if your workspace provides one** — otherwise it does the channel read inline. These specialist agents are **not bundled with this plugin**; provide your own per channel over time (the compounding move). The shape to aim for, by channel:

| Channel           | Specialist agent (provide your own) |
| ----------------- | ----------------------------------- |
| Google Ads        | e.g. a Google Ads analyst agent     |
| Meta Ads          | e.g. a Meta Ads analyst agent       |
| Email / lifecycle | e.g. an email/lifecycle analyst     |
| SEO               | e.g. an SEO analyst                 |
| CRO               | e.g. a CRO analyst                  |

When no specialist exists for the channel, Stage 2 runs the analysis inline without delegation.

**Specialist growth path (advisory — no automated gate):** Specialists are grown from live client work, not pre-built speculatively. The trigger is a session observation: when a CM cycle ends and the channel had no specialist, note it in your learning/compounding log with the client + channel + "specialist needed?" tag. The threshold for building a new specialist: the same channel produced ≥2 CM cycles across ≥2 clients where inline analysis was a meaningful constraint. You decide at the next pipeline review — not a hook, not an automatic gate. The 🔜 status on `email-lifecycle-analyst` reflects exactly this: one dogfood cycle observed, one more needed before the build is justified.

---

## Compounding mechanism

The flat **`Compound Marketing`** folder IS the compounding memory. Every stage searches it for this client's prior docs (by `<Client Display Name>` in the title) before producing its output. Stages 1-5 read the prior artifacts directly; in addition, the `cm-learnings-researcher` agent (auto-dispatched before every `/cm-*` run) surfaces prior `Learning` docs written by `/cm-compound`:

- Stage 1 reads: prior analysis + plan docs (to know what was already found)
- Stage 2 reads: the Stage 1 audit doc + any prior analysis docs
- Stage 3 reads: the Stage 2 analysis doc + prior plan docs (to avoid re-planning what's in flight)
- Stage 4 reads: the Stage 2 analysis doc + Stage 3 plan doc
- Stage 5 reads: the approved Stage 3/4 plan doc

The `cm-learnings-researcher` agent does the structured recall of past insights and winning angles across cycles, keyed to channel + client — auto-dispatched before every `/cm-*` run. Its write-side counterpart is `/cm-compound`. (The marketing mirror of the engineering `ce-compound` → `ce-learnings-researcher` loop.)

---

## Relationship to adjacent skills/agents

| Skill/Agent                    | Relationship to CM                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `marketing-skills:*`           | Tactical lenses CM invokes for specific craft tasks (copywriting, CRO, email). CM orchestrates; `marketing-skills` executes.                                                                                                                                                                                                                                                                                                                                |
| `/sales-letter`                | CM-**style** asset-creation play for long-form sales letters/pages. Follows the CM staged shape and FEEDS `/cm-compound`, but is NOT in the `/cm-*` pipeline and doesn't yet auto-recall via `cm-learnings-researcher` (future increment).                                                                                                                                                                                          |
| `/cm-experiment`               | CM companion play for running a **measured marketing/PPC experiment** (incrementality / brand-bid-down, geo holdout, budget-split lift, Google Ads native experiment, creative/LP A/B) before or instead of a direct change (`sop-cm-experiment.md`). Invoked from `/cm-plan` (an action is a test) or `/cm-execute` (run it under the Marketing Execution Protocol). Reuses `ab-test-setup` statistical rigor; FEEDS `/cm-compound`. Not a numbered stage. |
| Single-problem mode            | The reactive "one problem + evidence → hardened solution+execution" capability lives in `/cm-plan` single-problem mode + `/cm-review` (the locked Q2 full-merge). One pipeline, not two.                                                                                                                                                                                                                                                                    |
| `cm-lens-*` agents             | The 4 `/cm-review` lenses (evidence, measurement, ownership, brand/client), channel-agnostic (ownership reads `sop-cm-execution-owner-map.md`).                                                                                                                                                                                                                                                                                                             |
| Ad-platform data source        | CM's paid-ads execution backend — your ad-platform data source (Google Ads, Meta, etc.). Stage 5 build plan names the specific tools for each paid action.                                                                                                                                                                                                                                                                                                  |
| CRM / email tools              | Stage 5 execution surface for CRM, email platform, and contact management actions.                                                                                                                                                                                                                                                                                                                                                                          |
| Claude-in-Chrome               | Stage 5 execution surface for platforms with no API (LinkedIn organic, Meta Creative Hub manual actions).                                                                                                                                                                                                                                                                                                                                                   |

---

## Safety model

Stage 5 (`/cm-execute`) enforces a client-comms approval model:

1. **No auto-execution** — build plan ends at `AskUserQuestion` approval gate.
2. **Spend cap required** — `MAX_SPEND_CHANGE` declared in every build plan; actions above it route to the owner for approval.
3. **Pre-flight checklist** — LP audit + tracking verify before any paid campaign change.
4. **Audit trail** — build plan doc written and persisted before execution begins.
5. **Irreversible-op floor (overrides spend gate)** — pause, delete, budget-zero, and status-flip ops on campaigns, ad groups, or ads are never `Copilot auto`, even at $0 spend delta. Per-action `AskUserQuestion` approval is always required. See `cm-execute/SKILL.md` safety rule 5 for the credential/auth note.

---

## Running a full pipeline cycle

```
1. /cm-audit <client> <channel>  → produces audit doc
2. /cm-analyze                  → reads audit doc + pulls additional live data → analysis doc
3. /cm-plan                      → reads analysis doc → plan doc
4. /cm-review                         → reads analysis + plan docs, dispatches 4 lens agents → lens review summary appended to plan doc + approval gate
5. /cm-execute                          → reads approved plan → execution sequence + approval gate → execute
```

**Shortcutting stages:** Start from Stage 2 when fresh data is already in hand (e.g., after an ad-platform daily brief). Start from Stage 3 when a solid insight doc already exists. Start from Stage 4 to pressure-test a plan that was drafted ad-hoc. The pipeline is a sequence, not a ceremony — enter at the right stage for the situation.

---

## Marketplace vs internal status

**Internal only** (`.claude/skills/`) initially. Revisit for plugin packaging after the pipeline is dogfooded on 3+ clients across 2+ channels. Requirements doc § 1 has the rationale.
