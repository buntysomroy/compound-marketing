# SOP: Compound Marketing (CM) Pipeline

> **Reference doc for all CM skills and agents.** Each stage's SKILL.md points here for architecture and routing decisions. Read this when building new CM stages or when a stage needs to hand off to the next.
>
> **Requirements / north-star:** `reference/protocol-compound-marketing.md`

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

Each arrow = a durable doc artifact: a **user-friendly Google Doc** in a single Drive parent folder named **`Compound Marketing`** (flat — no subfolders). Everything the `/cm*` suite writes (audit, analysis, plan, build-plan, and `/cm-compound` learnings) lands there, named so the client/type/channel/date are legible in a flat list. By convention: one `Compound Marketing` parent, flat, user-friendly Drive docs — not per-client repo markdown.

> **Validated core vs candidate stages.** `cm-analyze → cm-plan → cm-review` is the proven 3-stage strategy chain (each consumes the prior). `cm-audit` (Stage 1) and `cm-execute` (Stage 5) are **candidate stages** — they're kept as working skills, but `cm-audit` is largely an extraction of `cm-analyze`'s own data-read. `cm-execute`'s full spec (your marketing execution protocol, if your workspace has adopted one) — Compile+Run with Action Cards, derived rungs, and the Effect Probe — earns validated-stage status after its first clean live run on a real account.

---

## Artifact naming convention

All CM artifacts are **Google Docs in a single flat Drive folder `Compound Marketing`** (resolve it once by searching/listing your Drive; create the folder if absent). Create the docs via your marketing docs store's write tools (create-document, or markdown → a markdown-to-Doc converter) — NOT as repo files.

**Flat doc title format** — ordered **broad → detailed, left to right** (Type → Channel/Topic → Client → Date), so a flat alphabetical list groups by Type then Channel:

```
<Type> — <Channel / Topic> — <Client Display Name> — <YYYY-MM-DD>
```

e.g. `Plan — Google Ads — Acme Hardware — 2026-06-29`
e.g. `Learning — Channel Prioritization — Acme Hardware — 2026-06-29`

| Type                     | Stage | Produced by                                |
| ------------------------ | ----- | ------------------------------------------ |
| `Audit`                  | 1     | `/cm-audit`                                |
| `Analysis`               | 2     | `/cm-analyze`                              |
| `Plan`                   | 3     | `/cm-plan`                                 |
| `Analytics Fix Document` | —     | `/cm-analytics-audit` (diagnostic sibling) |
| `Execution Manifest`     | 5     | `/cm-execute` (Compile)                    |
| `Execution Log`          | 5     | `/cm-execute` (Run — append-only receipts) |
| `Learning`               | —     | `/cm-compound`                             |

Stage 4 (`/cm-review`) appends a `## Lens Review Summary` section to the Stage 3 `Plan` doc rather than producing a separate doc.

> **Authoring check:** When writing or updating a CM skill's artifact location, it MUST be a Google Doc in the flat `Compound Marketing` Drive folder with the title format above — **Type first (broadest), then Channel/Topic, then Client, then ISO date** (broad → detailed, left to right). Per-client subfolders and repo-committed `documents/clients/<slug>/marketing/*.md` paths are **not the pattern here** — the read-back (and `cm-learnings-researcher`) search the flat folder, filtering by `<Type>` + `<Client Display Name>` in the title.

> **Storage tradeoff & access — Drive-only, by design.** These are Google Docs in Drive (user-friendly for you and your clients), NOT repo markdown. The tradeoff, proven empirically with a cold-session subagent test: a Google Doc has **no readable bytes on disk** — a local Drive mount typically holds only a `.gdoc` JSON pointer, so a plain file read on it returns a stub and silently "succeeds" with zero content. Content is reachable **only via your marketing docs store's read tools** (search → read-document). This is **less robust than repo-committed engineering solution docs** (which any session can just read directly) — it depends on the Drive/Docs connector being available, so it is fragile in headless/cron runs. Choose Drive-only anyway when human-friendliness wins; mitigate the robustness cost with two guards in your recall agent: **(1)** content access is strictly through the connector, never a filesystem `.gdoc` read; **(2)** a connector failure surfaces as a loud "could not reach — learnings may exist, don't assume a clean slate" caveat, never a silent "no learnings." If headless recall ever becomes load-bearing, revisit dual-write (a repo markdown mirror) then.
>
> **Cold-session breadcrumb — `CLAUDE.md` in the folder.** The folder also holds a plain-text **`CLAUDE.md`** (real bytes — readable on a plain file listing/read, unlike the `.gdoc` learnings) that documents the read-recipe + title convention + a live index of Learning docs. A fresh agent orienting in the folder reliably **reads the in-folder guide first, on its own** — it quotes the marker and follows the "`.gdoc` is a pointer → read it via your Drive read tool" recipe. Placement matters: a `CLAUDE.md` in the **parent** Drive directory is skipped; only the one placed **directly in the working folder** gets picked up — **location matters (in-folder is read, parent is skipped), not the filename**. Nothing auto-loads from a Drive path outside the repo tree, so this is read by agent instinct, not the harness. `CLAUDE.md` is the chosen convention (matches this repo's CLAUDE.md-everywhere pattern). It is the filesystem safety net for a cold session that lands in the folder WITHOUT a dedicated learnings-recall agent; `/cm-compound` keeps its `## Index of Learning docs` current (Step 5). **Do NOT symlink the folder into the repo to try to auto-load this `CLAUDE.md`** — reading a file through a repo symlink that points OUTSIDE the repo does NOT trigger directory-CLAUDE.md auto-load in most harnesses (it isn't treated as a repo-tree instruction file). The breadcrumb is read by agent instinct on orientation, not by auto-load — a symlink adds only bare discoverability at the cost of gitignore + setup-script maintenance, so it's usually not worth doing.

---

## Channel specialist agents

Stage 2 dispatches the appropriate specialist based on the channel framing:

| Channel           | Specialist agent | Status                                        |
| ----------------- | ----------------- | ---------------------------------------------- |
| Google Ads        | your Google Ads specialist agent      | optional — provide if your workspace has one |
| Meta Ads          | your Meta Ads specialist agent        | optional — provide if your workspace has one |
| Email / lifecycle | your email/lifecycle specialist agent | optional — provide if your workspace has one |
| SEO               | your SEO specialist agent             | optional — provide if your workspace has one |
| CRO               | your CRO specialist agent             | optional — provide if your workspace has one |

If your workspace provides a channel specialist agent for the relevant channel, Stage 2 dispatches it. Otherwise the stage runs the analysis inline, without delegation.

**Specialist growth path (advisory — no automated gate):** Specialists are grown from live client work, not pre-built speculatively. The trigger is a session observation: when a CM cycle ends and the channel had no specialist, note it in your learnings capture with the client + channel + "specialist needed?" tag. A reasonable threshold for building a new specialist: the same channel produced ≥2 CM cycles across ≥2 clients where inline analysis was a meaningful constraint. Decide at your next pipeline review — not a hook, not an automatic gate.

---

## Compounding mechanism

The flat **`Compound Marketing`** Drive folder IS the compounding memory. Every stage searches it for this client's prior docs (by `<Client Display Name>` in the title) before producing its output. Stages 1-5 read the prior artifacts directly; in addition, the `cm-learnings-researcher` agent surfaces prior `Learning` docs written by `/cm-compound`. Your environment may auto-dispatch this agent before every `/cm-*` run (e.g. via a pre-tool hook) — if it doesn't, dispatch it manually as Step 0 of any stage:

- Stage 1 reads: prior analysis + plan docs (to know what was already found)
- Stage 2 reads: the Stage 1 audit doc + any prior analysis docs
- Stage 3 reads: the Stage 2 analysis doc + prior plan docs (to avoid re-planning what's in flight)
- Stage 4 reads: the Stage 2 analysis doc + Stage 3 plan doc
- Stage 5 reads: the approved Stage 3/4 plan doc

The `cm-learnings-researcher` agent does the structured recall of past insights and winning angles across cycles, keyed to channel + client — ideally auto-dispatched before every `/cm-*` run by an environment hook; otherwise dispatch it manually before the stage work. Its write-side counterpart is `/cm-compound`. This is the marketing mirror of an engineering compound-learnings loop (write insights forward, recall them automatically on the next relevant run).

---

## Relationship to adjacent skills/agents

| Skill/Agent                    | Relationship to CM                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `marketing-skills:*`           | Tactical lenses CM invokes for specific craft tasks (copywriting, CRO, email). CM orchestrates; `marketing-skills` executes.                                                                                                                                                                                                                                                                                                                                |
| `/sales-letter`                | CM-**style** asset-creation play for long-form sales letters/pages (`reference/sop-sales-letter.md`, if bundled in your setup). Follows the CM staged shape and FEEDS `/cm-compound`, but is NOT in the `/cm-*` pipeline and doesn't yet auto-recall via `cm-learnings-researcher` (future increment).                                                                                                                                                        |
| `/cm-experiment`               | CM companion play for running a **measured marketing/PPC experiment** (incrementality / brand-bid-down, geo holdout, budget-split lift, Google Ads native experiment, creative/LP A/B) before or instead of a direct change (`reference/sop-cm-experiment.md`). Invoked from `/cm-plan` (an action is a test) or `/cm-execute` (run it under your marketing execution protocol). Reuses standard A/B-test statistical rigor; FEEDS `/cm-compound`. Not a numbered stage. |
| Single-problem mode            | The reactive "one problem + evidence → hardened solution+execution" capability lives in `/cm-plan` single-problem mode + `/cm-review` (the locked full-merge). One pipeline, not two.                                                                                                                                                                                                  |
| `cm-lens-*` agents             | The 4 `/cm-review` lenses (evidence, measurement, ownership, brand/client), channel-agnostic (ownership reads `reference/sop-cm-execution-owner-map.md`).                                                                                                                                                                                                                                                                                                             |
| Your ad-platform MCP/data source | CM's paid-ads execution backend (e.g. a Google Ads / Meta Ads MCP). Stage 5 build plan names the specific tools for each paid action.                                                                                                                                                                                                                                                                                                                   |
| CRM / email-platform tooling    | Stage 5 execution surface for CRM, email platform, and contact management actions.                                                                                                                                                                                                                                                                                                                                                                          |
| Browser automation              | Stage 5 execution surface for platforms with no API (organic social, ad-platform creative-hub manual actions).                                                                                                                                                                                                                                                                                                                                   |

---

## Safety model

Stage 5 (`/cm-execute`) runs under your **marketing execution protocol** — a canonical spec you maintain (or adopt/adapt from this plugin's guidance) for how automated actions are gated and verified. The load-bearing points:

1. **Action Cards with derived rungs** — every action's automation-ladder rung is computed from a 3-axis classification (reversibility × money × audience), never accepted from the plan. The floor invariant is a function: irreversible or money-moving ops can never derive to fully-auto (pauses/status-flips at $0 included).
2. **Two-tier approval, co-pilot only** — one Manifest Gate (a blocking approval question) authorizes the run session-scoped; per-card gates fire on the risky subset (an explicit approval token for hard-irreversible/unbounded-money/comms actions). Fully-auto is behind a per-client graduation flag, default OFF.
3. **Effect Probe on every card** — baseline → act → cross-modality read-back → CONFIRMED / PENDING(t) / FAILED verdict; FAILED halts the run. Ensure-state semantics provide idempotency on all surfaces (incl. Chrome UI).
4. **Spend cap + pre-flight** — `MAX_SPEND_CHANGE` locked at the Manifest Gate; LP-audit-style pre-flight (freshness-checked) before any paid change.
5. **Artifacts** — Execution Manifest persisted before any act; append-only Execution Log receipts per card; provenance chains back through plan → review → analysis.

---

## Entry: `/cm` front-door dispatcher

**`/cm` is the documented default entry point.** Before invoking any stage directly, run `/cm`:

1. **Intake** — classify the signal source (Slack message / report / commitment / prior artifact / pasted handoff block) and trace how the symptom arose.
2. **Artifact check** — list existing engagement docs in the Compound Marketing folder, mark completed stages, route past them.
3. **Decisions recall** — dispatch `cm-learnings-researcher` for prior learnings.
4. **Recommend** — recommend ONE entry stage with a one-line reason; user confirms before routing.

**Direct `/cm-<stage>` invocation remains a valid bypass** — when you already know which stage to start from, skip the dispatcher. This is the same pattern as the plan router's direct-skill bypass.

### Stage routing table

| Signal / symptom                              | Recommended entry                          |
| --------------------------------------------- | ------------------------------------------ |
| "What's happening with their marketing"       | `/cm` → `/cm-audit` (Stage 1)              |
| "What should we change / which lever"         | `/cm` → `/cm-analyze` (Stage 2)            |
| "Build a marketing plan" / "fix this problem" | `/cm` → `/cm-plan` (Stage 3)               |
| "Review/pressure-test this plan"              | `/cm` → `/cm-review` (Stage 4)             |
| "Make the changes / execute the plan"         | `/cm` → `/cm-execute` (Stage 5)            |
| "Tracking is broken / conversions look off"   | `/cm` → `/cm-analytics-audit` (diagnostic) |
| "Test this before we roll it out"             | `/cm` → `/cm-experiment` (companion)       |
| "Capture this learning / mark this decision"  | `/cm-compound` (no dispatcher needed)      |

## Running a full pipeline cycle

```
0. /cm (front door — intake → artifact check → decisions recall → recommend entry)
1. /cm-audit <client> <channel>  → produces audit doc
2. /cm-analyze                  → reads audit doc + pulls additional live data → analysis doc
3. /cm-plan                      → reads analysis doc → plan doc
4. /cm-review                    → reads analysis + plan docs, dispatches 4 lens agents → lens review summary appended to plan doc + approval gate
5. /cm-execute                   → Compile (plan → Action Cards → manifest + gate) → Run (gated, probed, receipted execution)
```

### Stage contract

Every stage (including `/cm-audit`, `/cm-analytics-audit`, and `/cm-experiment`) follows the behavioral contract defined in `reference/protocol-cm-stage-contract.md`:

1. **Decisions recall** — dispatch `cm-learnings-researcher` and list findings visibly before any stage work.
2. **Findings confirmation** — before artifact write, render findings with provenance (claim → source → denominator/coverage → proxy-validity note), then block for user confirmation.
3. **Quantitative-claim rule** — every headline rate carries its denominator and coverage; "6.67% bounce" without "81 of 580 processed (14% coverage)" fails the gate.
4. **Handoff block** — emit inline after artifact write (What & why / Carried-over context / Don't-repeat / First step).
5. **Decision-time logging** — append decisions to the per-engagement `Learning — Decisions — <Client>` Drive doc at the moment they're made.

This contract is the cross-cutting requirement for all ten cm-\* skills. Read it before any stage run.

---

## What this plugin ships

This plugin packages the 5-stage `/cm-*` pipeline described above, its front-door `/cm` dispatcher, the `cm-lens-*` review agents, `cm-learnings-researcher`, and this reference doc set (`reference/`). Install it, point it at your own Drive (or equivalent docs store) and ad-platform MCP, and the pipeline runs against your accounts. Agents and skills are updated independently by the plugin maintainer as the pipeline evolves.

---

## Appendix — Red Pine reference implementation (optional)

This section documents how the pipeline maintainer (Red Pine Digital) wires the optional pieces in their own environment, as a concrete worked example — not a requirement.

- **Docs store:** the Shanti Drive MCP (`shanti_search_drive`, `shanti_read_drive_document`, `shanti_create_drive_document`, `shanti_create_drive_folder`, `shanti_list_drive_files`) reads/writes the flat `Compound Marketing` Google Drive folder. Markdown-to-Doc conversion goes through an internal `/format-gdoc` skill.
- **Ad-platform MCP:** an internal MCP nicknamed "Dharma" is the paid-ads execution backend (Google Ads + Meta Ads). Stage 5 build plans name its specific tools per paid action.
- **Channel specialist agents:** `google-ads-analyst` and `meta-ads-analyst` are built and live; `email-lifecycle-analyst` is queued (one dogfood cycle observed, one more needed before the build is justified per the growth-path threshold above); `seo-analyst` and `cro-analyst` are deferred.
- **cm-learnings-researcher auto-dispatch:** wired via an internal `pre-tool-skill-context-injector.sh` PreToolUse hook, so every `/cm-*` run gets prior-learnings recall for free without the operator remembering to invoke it.
- **Manifest/card approval token:** an internal EA convention (`# BUNTY-APPROVED`) is the literal string scanned for at the per-card approval gate.
- **A worked example client:** a hardware-retail account (internally "SSS") was the first account run end-to-end through Stage 5's Compile+Run flow, validating the Action Card / Effect Probe mechanics described in the Safety model section above.
