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
Stage 1      Stage 2       Stage 3     Stage 4       Stage 5a          Stage 5b
/cm-audit    /cm-analyze   /cm-plan    /cm-review    /cm-agent-plan    /cm-execute
(Audit)      (Analyze)     (Plan)      (Review)      (Compile)         (Run)
    ↓            ↓             ↓            ↓             ↓                 ↓
audit.md     analysis.md   plan.md     plan.md       execution-        execution-log
                                     (with Lens      manifest.md       (append-only
                                   Review Summary)   + tracker.md       receipts)
```

**Stage 5 is two skills, not one.** `/cm-agent-plan` (5a) compiles the approved plan into Action
Cards + a gated Execution Manifest and stops — it never executes anything. `/cm-execute` (5b) runs
that already-approved manifest card-by-card. This split (2026-09-12) mirrors Compound Engineering's
`ce-plan` → `ce-work`: `/cm-execute` now works like `ce-work` — it can be invoked standalone, in a
fresh session, against nothing but the manifest doc, and it never re-plans.

Each arrow = a durable internal artifact. Before the first read or write, resolve the engagement's **artifact workspace profile** below and keep it fixed for the entire pipeline cycle. A project-local profile uses flat Markdown artifacts in `CM Artifacts`; the shared-Drive fallback retains the flat `.docx` convention. Storage format changes mechanics, not stage prerequisites, approval boundaries, or evidence requirements.

> **Validated core vs candidate stages.** `cm-analyze → cm-plan → cm-review` is the proven 3-stage strategy chain (each consumes the prior). `cm-audit` (Stage 1) and `cm-agent-plan` + `cm-execute` (Stage 5a/5b) are **candidate stages** — they're kept as working skills, but `cm-audit` is largely an extraction of `cm-analyze`'s own data-read. The Stage 5 pair's full spec (your marketing execution protocol, if your workspace has adopted one) — Compile (`cm-agent-plan`) + Run (`cm-execute`) with Action Cards, derived rungs, and the Effect Probe — earns validated-stage status after its first clean live run on a real account.

---

## Artifact workspace profiles

| Profile | Choose when | Root and format | Durable identity |
| --- | --- | --- | --- |
| **Project-local** (preferred for agent-native projects) | The user/project contract names it, or an established project root already contains `CM Artifacts` or prior `<project-slug>-<run-id>-...` artifacts | One flat `<project-root>/CM Artifacts` directory; internal pipeline artifacts are Markdown; the decision log is CSV | `<project-slug>-<run-id>-<YYYY-MM-DD>-<artifact-type>.md` and `<project-slug>-decisions.csv` |
| **Shared Drive** (portable fallback) | No project-local profile is established, or the team intentionally needs a cross-project human-facing corpus | One flat Drive folder named `Compound Marketing`; artifacts remain `.docx` files uploaded without Google-Doc conversion | `<Type> — <Channel / Topic> — <Client Display Name> — <YYYY-MM-DD>.docx` and `Learning — Decisions — <Client Display Name>.docx` |

### Resolve once, then fail closed

1. Honor an explicit user or project instruction first.
2. Otherwise continue the workspace used by the named upstream artifact or prior run. An ordinary working directory alone does **not** select project-local mode.
3. If an established project root contains `CM Artifacts`, use project-local mode. Otherwise use shared Drive.
4. Record the chosen profile, root, `project_slug`, and `run_id` in the first artifact or handoff. Reuse them through audit → analyze → plan → review → agent-plan → execute, even when the cycle spans dates or sessions.
5. If both profiles contain plausible continuation artifacts, or the selected workspace is unavailable/unwritable, stop and surface the candidates. Never silently redirect, duplicate, migrate, merge, or synchronize artifacts between profiles.

### Project-local identity and naming

- Keep `CM Artifacts` flat. Do not create stage subfolders.
- `project_slug` is the stable lowercase kebab-case project/channel identity (for example `google-ads`).
- Allocate `run_id` once per new pipeline cycle by scanning existing filenames and choosing the next unused zero-padded integer (`001` is minimum padding, not a maximum). Reuse it across dates and stages. A new date or session does not create a new run.
- Continue an existing run only when an upstream artifact, handoff, or explicit user choice identifies it. Detect filename collisions and stop rather than overwrite a different artifact.
- The filename date is the artifact's original creation date. Ordinary revisions keep the filename and record revision date/status inside the artifact.
- Naming shape: `<project-slug>-<run-id>-<YYYY-MM-DD>-<artifact-type>.md`. Examples: `google-ads-001-2026-09-18-audit.md`, `google-ads-001-2026-09-19-plan.md`, `google-ads-001-2026-09-20-review.md`, `google-ads-001-2026-09-21-execution-manifest.md`.
- The perpetual decision log is `<project-slug>-decisions.csv`; its schema and append rules live in the Stage Contract's Decision-Time Logging step.

### Shared-Drive identity and naming

Resolve exactly one `Compound Marketing` folder. If a name search returns more than one, stop and surface the candidate IDs; never auto-pick. Build `.docx` artifacts with the document-authoring skill and upload with content-type conversion disabled.

Flat title shape: `<Type> — <Channel / Topic> — <Client Display Name> — <YYYY-MM-DD>.docx` (for example `Plan — Google Ads — Acme Hardware — 2026-06-29.docx`). The one non-dated type, `Client Context`, has no date segment.

| Type                     | Stage | Produced by                                |
| ------------------------ | ----- | ------------------------------------------ |
| `Client Context`         | —     | `/cm-channel-discovery` (setup companion, non-dated, perpetual — updated in place) |
| `Audit`                  | 1     | `/cm-audit`                                |
| `Analysis`               | 2     | `/cm-analyze`                              |
| `Plan`                   | 3     | `/cm-plan`                                 |
| `Analytics Fix Document` | —     | `/cm-analytics-audit` (diagnostic sibling) |
| `Execution Manifest`     | 5a    | `/cm-agent-plan` (Compile)                 |
| `Execution Log`          | 5b    | `/cm-execute` (Run — append-only receipts) |
| `Learning`               | —     | `/cm-compound`                             |

In project-local mode, Stage 4 writes a separate `review.md` artifact that identifies the exact plan revision reviewed and preserves every finding/disposition; confirmed fixes also update the plan. In shared-Drive mode, Stage 4 may continue appending the Lens Review Summary to the Plan doc. A later plan edit is not reviewed merely because an earlier revision passed. Stage 5a also creates the client-facing Execution Tracker after the Manifest Gate; client-facing format is chosen separately from the internal artifact profile.

`Client Context` remains a non-dated current business contract. In project-local mode, use the existing project-designated context document (it may live at the project root and may be Markdown or `.docx`); do not copy it into `CM Artifacts` merely to satisfy the pipeline. In shared-Drive mode, retain `Client Context — <Channel> — <Client Display Name>`.

> **Shared-Drive storage tradeoff.** Keep its artifacts as real `.docx` files, not native Google Docs: a mounted `.gdoc` is only a JSON pointer, and generic Drive tools cannot edit Google-Doc content. On a local mount, read `.docx` via the document skill/pandoc; API-only deployments download, edit, and re-upload the bytes. Replace an existing `.docx` by trashing the old file and uploading the new version under the identical title. This constraint does not apply to project-local Markdown.
>
> **Cold-session breadcrumb.** Keep the selected profile and artifact-root contract in the project's real instruction/routing file. A shared-Drive `CLAUDE.md` remains a useful manual index, but it is not guaranteed harness context. Do not create symlinks to simulate instruction loading; Codex and Claude must each use their supported project instruction surface.

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

The selected artifact workspace is the cycle's compounding memory. In project-local mode, search the flat `CM Artifacts` directory by `project_slug` and `run_id`, reading `<project-slug>-decisions.csv` first. In shared-Drive mode, preserve title-based recall inside the canonical `Compound Marketing` folder. `cm-learnings-researcher` must resolve the same profile before recall; it may not silently fall back to the other profile.

- Stage 1 reads: prior analysis + plan docs (to know what was already found)
- Stage 2 reads: the Stage 1 audit doc + any prior analysis docs
- Stage 3 reads: the Stage 2 analysis doc + prior plan docs (to avoid re-planning what's in flight)
- Stage 4 reads: the Stage 2 analysis doc + Stage 3 plan doc
- Stage 5a (`/cm-agent-plan`) reads: the approved Stage 3/4 plan doc
- Stage 5b (`/cm-execute`) reads: the approved Execution Manifest from Stage 5a — never the plan doc directly

The `cm-learnings-researcher` agent does the structured recall of past insights and winning angles across cycles, keyed to channel + client — ideally auto-dispatched before every `/cm-*` run by an environment hook; otherwise dispatch it manually before the stage work. Its write-side counterpart is `/cm-compound`. The trigger half is `/cm-session-review` — the session-wrap stage that mines the session for marketing learnings and routes them through `/cm-compound`. This is the marketing mirror of an engineering compound-learnings loop (write insights forward, recall them automatically on the next relevant run).

---

## Relationship to adjacent skills/agents

| Skill/Agent                    | Relationship to CM                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `marketing-skills:*`           | Tactical lenses CM invokes for specific craft tasks (copywriting, CRO, email). CM orchestrates; `marketing-skills` executes.                                                                                                                                                                                                                                                                                                                                |
| `/sales-letter`                | CM-**style** asset-creation play for long-form sales letters/pages (`reference/sop-sales-letter.md`, if bundled in your setup). Follows the CM staged shape and FEEDS `/cm-compound`, but is NOT in the `/cm-*` pipeline and doesn't yet auto-recall via `cm-learnings-researcher` (future increment).                                                                                                                                                        |
| `/cm-experiment`               | CM companion play for running a **measured marketing/PPC experiment** (incrementality / brand-bid-down, geo holdout, budget-split lift, Google Ads native experiment, creative/LP A/B) before or instead of a direct change (`reference/sop-cm-experiment.md`). Invoked from `/cm-plan` (an action is a test), `/cm-agent-plan` (compiling the test as a card), or `/cm-execute` (running it under your marketing execution protocol). Reuses standard A/B-test statistical rigor; FEEDS `/cm-compound`. Not a numbered stage. |
| Single-problem mode            | The reactive "one problem + evidence → hardened solution+execution" capability lives in `/cm-plan` single-problem mode + `/cm-review` (the locked full-merge). One pipeline, not two.                                                                                                                                                                                                  |
| `cm-lens-*` agents             | The 4 `/cm-review` lenses (evidence, measurement, ownership, brand/client), channel-agnostic (ownership reads `reference/sop-cm-execution-owner-map.md`).                                                                                                                                                                                                                                                                                                             |
| `/cm-session-review`           | The session-wrap trigger half of the CM compound loop. Mines the session for marketing learnings, routes them through `/cm-compound`, runs a produced-vs-actioned effectiveness pass, and notices due success signals from prior Learning docs. Invoked at wrap or via close-offer from any `/cm-*` pipeline skill.                                                                                             |
| `/cm-channel-discovery`        | Setup companion to `/cm-audit`, the way `/cm-build-voice` is a setup companion to `/cm-sound-like-me`. Discovers and persists a channel's success line (target CAC/CPA, ROAS/CoS, CPL, revenue-per-send, etc.) as a `Client Context —` doc so `/cm-audit` never has to invent a generic benchmark or ask ad hoc and lose the answer at session end. Invoked from `/cm-audit` Step 1 when no `Client Context` doc exists yet, or standalone.                                                                                             |
| Your ad-platform MCP/data source | CM's paid-ads execution backend (e.g. a Google Ads / Meta Ads MCP). Stage 5 build plan names the specific tools for each paid action.                                                                                                                                                                                                                                                                                                                   |
| CRM / email-platform tooling    | Stage 5 execution surface for CRM, email platform, and contact management actions.                                                                                                                                                                                                                                                                                                                                                                          |
| Browser automation              | Stage 5 execution surface for platforms with no API (organic social, ad-platform creative-hub manual actions).                                                                                                                                                                                                                                                                                                                                   |

---

## Safety model

Stage 5 (`/cm-agent-plan` compiling + `/cm-execute` running) runs under your **marketing execution protocol** — a canonical spec you maintain (or adopt/adapt from this plugin's guidance) for how automated actions are gated and verified. The load-bearing points:

1. **Action Cards with derived rungs** — every action's automation-ladder rung is computed from a 3-axis classification (reversibility × money × audience), never accepted from the plan. The floor invariant is a function: irreversible or money-moving ops can never derive to fully-auto (pauses/status-flips at $0 included).
2. **Two-tier approval, co-pilot only** — one Manifest Gate (a blocking approval question) authorizes the run session-scoped; per-card gates fire on the risky subset (an explicit approval token for hard-irreversible/unbounded-money/comms actions). Fully-auto is behind a per-client graduation flag, default OFF.
3. **Effect Probe on every card** — baseline → act → cross-modality read-back → CONFIRMED / PENDING(t) / FAILED verdict; FAILED halts the run. Ensure-state semantics provide idempotency on all surfaces (incl. Chrome UI).
4. **Spend cap + pre-flight** — `MAX_SPEND_CHANGE` locked at the Manifest Gate; LP-audit-style pre-flight (freshness-checked) before any paid change.
5. **Artifacts** — Execution Manifest persisted before any act; append-only Execution Log receipts per card; provenance chains back through plan → review → analysis.

---

## Entry: `/cm` front-door dispatcher

**`/cm` is the documented default entry point.** Before invoking any stage directly, run `/cm`:

1. **Intake** — classify the signal source (Slack message / report / commitment / prior artifact / pasted handoff block) and trace how the symptom arose.
2. **Artifact check** — resolve the artifact workspace profile, list existing engagement artifacts there, mark completed stages, and route past them.
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
| "Make the changes / execute the plan" (no manifest compiled yet) | `/cm` → `/cm-agent-plan` (Stage 5a) |
| "Run/resume the approved manifest"            | `/cm` → `/cm-execute` (Stage 5b, direct invocation — works standalone, even in a fresh session) |
| "Tracking is broken / conversions look off"   | `/cm` → `/cm-analytics-audit` (diagnostic) |
| "Test this before we roll it out"             | `/cm` → `/cm-experiment` (companion)       |
| "Capture this learning / mark this decision"  | `/cm-compound` (no dispatcher needed)      |
| "What's our target CAC/ROAS/CPL for this channel" / no `Client Context` doc yet | `/cm-channel-discovery` (no dispatcher needed) |
| "Wrap the marketing session / what did we learn" | `/cm-session-review` (session-wrap trigger) |

## Running a full pipeline cycle

```
0. /cm (front door — intake → artifact check → decisions recall → recommend entry)
1. /cm-audit <client> <channel>  → produces audit doc
2. /cm-analyze                  → reads audit doc + pulls additional live data → analysis doc
3. /cm-plan                      → reads analysis doc → plan doc
4. /cm-review                    → reads analysis + plan docs, dispatches 4 lens agents → review artifact/summary + confirmed plan fixes + approval gate
5a. /cm-agent-plan                → Compile (plan → Action Cards → manifest + gate) — stops here
5b. /cm-execute                   → Run (gated, probed, receipted execution against the approved manifest)
```

### Stage contract

Every stage (including `/cm-audit`, `/cm-analytics-audit`, and `/cm-experiment`) follows the behavioral contract defined in `reference/protocol-cm-stage-contract.md`:

1. **Decisions recall** — dispatch `cm-learnings-researcher` and list findings visibly before any stage work.
2. **Findings confirmation** — before artifact write, render findings with provenance (claim → source → denominator/coverage → proxy-validity note), then block for user confirmation.
3. **Quantitative-claim rule** — every headline rate carries its denominator and coverage; "6.67% bounce" without "81 of 580 processed (14% coverage)" fails the gate.
4. **Handoff block** — emit inline after artifact write (What & why / Carried-over context / Don't-repeat / First step).
5. **Decision-time logging** — append decisions to the selected profile's decision log at the moment they're made (`<project-slug>-decisions.csv` locally; `Learning — Decisions — <Client>` in shared Drive).

This contract is the cross-cutting requirement for all twelve cm-\* skills. Read it before any stage run.

---

## What this plugin ships

This plugin packages the 5-stage `/cm-*` pipeline described above (Stage 5 split into `/cm-agent-plan` Compile + `/cm-execute` Run), its front-door `/cm` dispatcher, the `cm-lens-*` review agents, `cm-learnings-researcher` (the recall half of the compound loop), `/cm-compound` (the write half), `/cm-session-review` (the trigger half — the session-wrap stage that mines learnings and routes them through `/cm-compound`), and this reference doc set (`reference/`). Install it, point it at your project root or shared Drive (or equivalent docs store) and ad-platform MCP, and the pipeline runs against your accounts. Agents and skills are updated independently by the plugin maintainer as the pipeline evolves.

---

## Appendix — Red Pine reference implementation (optional)

This section documents how the pipeline maintainer (Red Pine Digital) wires the optional pieces in their own environment, as a concrete worked example — not a requirement.

- **Docs store:** the Shanti Drive MCP (`shanti_search_drive`, `shanti_read_drive_document`, `shanti_create_drive_document`, `shanti_create_drive_folder`, `shanti_list_drive_files`) reads/writes the flat `Compound Marketing` Google Drive folder — as of 2026-09-16, as `.docx` files built via the `docx` skill and uploaded with content-type conversion disabled, not through the internal `/format-gdoc` markdown-to-Doc skill, which is no longer this pipeline's authoring path (still usable for other things outside CM).
- **Ad-platform MCP:** an internal MCP nicknamed "Dharma" is the paid-ads execution backend (Google Ads + Meta Ads). Stage 5 build plans name its specific tools per paid action.
- **Channel specialist agents:** `google-ads-analyst` and `meta-ads-analyst` are built and live; `email-lifecycle-analyst` is queued (one dogfood cycle observed, one more needed before the build is justified per the growth-path threshold above); `seo-analyst` and `cro-analyst` are deferred.
- **cm-learnings-researcher auto-dispatch:** wired via an internal `pre-tool-skill-context-injector.sh` PreToolUse hook, so every `/cm-*` run gets prior-learnings recall for free without the operator remembering to invoke it.
- **Manifest/card approval token:** an internal EA convention (`# BUNTY-APPROVED`) is the literal string scanned for at the per-card approval gate.
- **A worked example client:** a hardware-retail account (internally "SSS") was the first account run end-to-end through Stage 5's Compile+Run flow (pre-split, single fused `cm-execute` skill — the mechanics transfer unchanged onto the `cm-agent-plan` + `cm-execute` pair), validating the Action Card / Effect Probe mechanics described in the Safety model section above.
