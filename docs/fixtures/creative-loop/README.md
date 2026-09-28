# Creative-loop fixture dry runs

`/cm-creative-loop` is prose, so its tests are dry runs: a fresh, read-only agent runs the skill
against these fixtures and the output is checked for a fixed refusal line (or its absence). The
fixtures use a made-up client (Acme Laundry), platform (Placard Network) and asset type (station
poster), so no case leans on any real channel, and every case doubles as a rehearsal that the
driver runs an asset type it has never seen with no edit (R29).

**Re-run all of them after every revision of** `skills/cm-creative-loop/SKILL.md`,
`reference/protocol-cm-creative-adapter.md` or `reference/sop-cm-creative-discovery.md`, and
record each case's pass or fail in the iteration artifact that prompted the revision (the driver's
self-update directive).

```bash
docs/fixtures/creative-loop/run-dry-runs.sh /tmp/cm-dry            # all cases
docs/fixtures/creative-loop/run-dry-runs.sh /tmp/cm-dry control-04  # one case
```

Exit codes: `0` every case passed · `1` at least one case failed its assertion · `2` the harness
broke (no `claude` CLI, or a run produced no `## Dry-run result` section). The agent under test is denied `Read` on this README and on `run-dry-runs.sh`, because they hold the expected outcomes. A `2` is never a verdict
on the skill. `CM_DRYRUN_MODEL` overrides the model (default `sonnet`).

## Files

| File | Role |
| --- | --- |
| `adapter-minimal.md` | A complete six-slot adapter for the made-up asset type |
| `acme-laundry-channel-contract.md` | Channel input, creative gate open |
| `acme-laundry-channel-contract-gate-closed.md` | Same, creative gate closed |
| `acme-laundry-001-creative-asset-ledger.md` | Run ledger: 01 and 02 closed, 03 in read-back, 04 at brief |
| `iteration-03-resume.md` | In read-back, early read due |
| `iteration-04-missing-constraint.md` | Brief omits iteration 02's constraint line |
| `iteration-04-control.md` | Identical, but cites both constraint lines |
| `iteration-05-slot-in-readback.md` | Targets tall / line-b, which iteration 03 holds |
| `iteration-05-control.md` | Targets wide / line-a, which is free |

## Cases and expected outcomes

| Case | Covers | Expected | Kind |
| --- | --- | --- | --- |
| `resume-03` | R23, AE8 | Continues at the 7-day early read; does not re-run discovery or the brief; no `REFUSED (` line | positive |
| `missing-constraint-04` | F3, R2, R22 | `REFUSED (missing constraint): brief 04 … iteration 02 …` | negative control |
| `control-04` | F3 | `NO REFUSAL` and no missing-constraint line (proves the guard is not unconditional) | positive twin |
| `slot-in-readback-05` | R43, AE12 | `REFUSED (slot in read-back): tall / line-b holds iteration 03 in read-back until 2026-02-05 …` (the full-read date), open slots offered | negative control |
| `control-05` | R43 | `NO REFUSAL` and no slot-in-read-back line | positive twin |
| `gate-closed` | R12, F4, AE7 | `REFUSED (precondition)`; no draft | negative control |
| `batched-interview` | Discovery SOP (a) | Asked to send every interview question at once: `REFUSED (batched interview)`, and exactly one question is asked | negative control |
| `r29-new-instance` | R29, F4 | New iteration on the made-up adapter proceeds to discovery with `NO REFUSAL` and no driver edit | positive |

The assertions are regular expressions in `run-dry-runs.sh`. Each negative control has a positive
twin that differs in one field, so a guard that refused everything would fail the twin
(`batched-interview`'s twin is `r29-new-instance`: same invocation, no batching request).
