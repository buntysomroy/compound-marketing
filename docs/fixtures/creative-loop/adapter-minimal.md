# Adapter — station poster (Placard Network)

> **FIXTURE.** A made-up asset type on a made-up platform, used by the creative-loop dry runs. It
> is also the R29 rehearsal: a complete six-slot adapter for an asset type the driver has never
> seen, which must run with no edit to `skills/cm-creative-loop/SKILL.md`.
> Instance of `reference/protocol-cm-creative-adapter.md`. Driver: `/cm-creative-loop`.
> **Channel input:** `docs/fixtures/creative-loop/acme-laundry-channel-contract.md` (success line,
> creative KPI, outcome KPI, guardrail, live targets). The dry-run prompt may point at a different
> channel-contract fixture; use the one the prompt names.

## Preconditions
- The channel contract's `Creative gate:` line reads `open` — checked by reading the channel input.

## Slot 1 — Format spec
| Format | Spec (cited) | Filename token |
| --- | --- | --- |
| Tall poster | Placard Network spec sheet § Tall (1080×1920, 4 MB max) | `tall` |
| Wide poster | Placard Network spec sheet § Wide (1920×1080, 4 MB max) | `wide` |

## Slot 2 — Policy and quality checklist
1. No price claim that the brand-and-source kit does not carry.
2. Brand mark present and legible at 3 metres.
3. QR code present, at least 300×300 px, resolving to the target's landing URL.
4. Render check at placement scale via `visual-spot-check` (poster at 3 metres on a platform wall).
5. Intended viewer: a commuter who runs a small laundry business. Fails if a consumer could read it
   as an offer to wash their own clothes.

## Slot 3 — Production method options
| Method | Lens / skill | Typical time |
| --- | --- | --- |
| Composed graphic | `marketing-skills:image` | hours |
| Photo the owner supplies | none (owner produces) | days |

## Slot 4 — Ship tool and approval-gate mechanism
- Create: `placard upload` via a staged queue row; reports the returned `poster_id` and whether the
  network matched an existing poster with identical bytes (`created: false`).
- Per-target write: `placard assign` one row per line (`line-a`, `line-b`), each approved on its own.
- Floors: the network refuses to leave a line with zero posters of a format; the loop then assigns
  the new poster in the same row as any removal.
- Quiet-window check: read the line's change log; structural means a schedule change or a line pause.
- Fallback: the owner uploads in the network portal and the loop records the returned `poster_id`.

## Slot 5 — Read-back query and verdict thresholds
| Checkpoint | Offset | Query / tool | Interim method |
| --- | --- | --- | --- |
| Review gate | 72 hours | `placard status <poster_id>` | portal screenshot via `visual-spot-check` |
| Early read | 7 days | `placard stats --by poster --line <line>` (scans, passes) | none |
| Full read | 14 days | the same, plus slot share won and cost per signup | none |
- Reminder mechanism: a calendar entry per checkpoint naming the iteration artifact.
- Asset kill floor: scan rate below 10% of the sibling mean when the sibling set has at least 1,000
  passes in the window. Minimum volume: 500 passes on the new poster for any scan-rate claim; below
  it the read is `underpowered` and extends to 21 days. Direction retirement: 2 consecutive
  rejections on one hypothesis. Guardrail: cost per signup worse than 20% over the 30-day baseline.

## Slot 6 — Sibling set and slot inventory
- Sibling set: the same format on the same line.
- Slot inventory, in order: `tall / line-a`, `tall / line-b`, `wide / line-a`, `wide / line-b`.
- Loop done: every line holds at least one approved poster in each format, and no rejected poster
  remains assigned.
