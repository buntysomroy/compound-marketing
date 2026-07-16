# Compound Marketing

A staged, **report-at-each-gate** marketing workflow — the marketing adaptation of Compound Engineering. Each stage produces a reviewable artifact and stops at an approval gate before the next stage runs, so you always validate the work before it compounds.

```
audit → analyze → plan → review → execute
```

## Front door

`/cm` — symptom intake, decisions recall, and an artifact check across your engagement docs, then a one-line recommendation for which stage to enter (with an alternative and a direct-bypass option). Run this before any numbered stage when you're not sure where to start; direct invocation of a stage skill is always still available.

## Pipeline

| Stage | Skill | What it does |
| --- | --- | --- |
| Audit | `/cm-audit` | Gather the real current state — pull the actual numbers from your analytics/dashboard/ad-platform sources and ground in your channel SOPs + account context. No analysis yet, just verified state. |
| Analyze | `/cm-analyze` | Turn audited state into scored insights — what's working, what's not, what to change and why. |
| Plan | `/cm-plan` | Sequence a marketing plan from an analysis (full-account mode) **or** from a single problem + evidence (single-problem mode). |
| Review | `/cm-review` | Adversarial multi-lens review of any plan/analysis doc — four independent lenses (evidence, measurement, ownership, brand/client) inline-quote the artifact and challenge it before it ships. |
| Execute | `/cm-execute` | Gated execution of an approved plan. |

Plus supporting skills:

- `/cm-experiment` — design and track a marketing experiment against the execution owner-map.
- `/cm-compound` — capture a solved marketing problem or durable decision so the next run inherits it.
- `/cm-analytics-audit` — deep analytics/measurement audit (web analytics + ad-platform data quality).
- `/cm-handoff` — generate a session-close handoff prompt pointing at a real artifact (not the closing session's own proposed solution), for a fresh session to resume from.
- `/cm-sound-like-me` — voice gate: match any outward email/Slack message to your workspace voice profile (read from your `Compound Marketing` Drive folder) before it's shown or sent. Draft-only, never sends.

## Stage contract

Every stage skill above (plus `/cm` and `/cm-handoff`) binds to one shared behavioral contract — `reference/protocol-cm-stage-contract.md` — so decisions recall, findings confirmation with denominator/coverage, a handoff block, and decision-time logging fire consistently on every run instead of depending on any one skill remembering to do it.

## Agents

Bundled review + recall agents the skills dispatch:

- `cm-learnings-researcher` — recalls prior marketing learnings from your docs store before a run, so a new audit/analysis/plan inherits past decisions and evidence gaps.
- `cm-lens-evidence` — challenges every quantitative claim (full pull vs sample? does the math hold?).
- `cm-lens-measurement` — every recommended action must name a success signal and where it's observed.
- `cm-lens-ownership` — every execution step must have an owner who can actually do it (resolved against the owner-map).
- `cm-lens-brand-client` — catches positioning conflicts, channel cannibalization, and not-client-ready framing.

## Reference

The methodology docs the skills point to live in `reference/`:

- `protocol-compound-marketing.md` — the north-star vision.
- `sop-cm-pipeline.md` — stage order, artifact naming, and the report-at-each-gate discipline.
- `protocol-cm-stage-contract.md` — the shared per-stage behavioral contract (recall, findings confirmation, quantitative-claim rule, handoff block, decision-time logging).
- `sop-cm-experiment.md` — experiment design + tracking.
- `sop-cm-execution-owner-map.md` — the channel→owner map (a fillable template; a Red Pine example mapping is included as an appendix).

## Install

```
/plugin marketplace add buntysomroy/compound-marketing
/plugin install compound-marketing@compound-marketing
```

Or run `/plugin` for the interactive menu, add the `buntysomroy/compound-marketing` marketplace, and install from the list.

## Notes

- **Channel-agnostic.** The skills were authored in the Red Pine Digital agency workspace and generalized for any workspace — data-source references (spreadsheet/analytics/ad-platform tools) are examples; the pipeline runs against whatever tools and data sources your workspace has. Concrete Red Pine setups, where kept, are labelled as optional reference examples.
- **⚠️ Published derivative — do not edit these files directly.** This plugin is a genericized *published copy*; the source of truth lives in the Red Pine Digital repo, and edits here are overwritten on the next publish. To change a skill, edit it in the source repo and re-run the genericize-and-publish step (`protocols-and-sops/sop-cm-plugin-publish.md` there).
- **Roadmap.** A future version folds in a *thinking layer* — a doctrine + judgment substrate that lets the pipeline reason toward your priorities and frameworks before the voice gate applies tone. Ships as part of this same plugin.
