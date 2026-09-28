# Adapter — Performance Max image assets (Google Ads)

> Instance of `reference/protocol-cm-creative-adapter.md`. Driver: `/cm-creative-loop`.
> **Channel input:** the project's Google Ads contract documents: its project `CLAUDE.md` (success
> line, metric and write boundaries), its Client Context document (cost-per-trial bands, minimum
> signal), and the run's plan artifact (live-group list, conversion action, baselines). This file
> carries no account data; each account's bindings live in its instance file (see Instance bindings).
> Written 2026-09-27.

## Preconditions

- **The ship tools are callable in the session.** `create_image_asset` and
  `update_pmax_asset_group_assets` appear in the Google Ads MCP's tool list and stage rather than
  execute. Checked by a live tool listing. If they are missing, use the Slot 4 fallback and record
  that choice as a decision; this precondition then passes.
- **The live-group list is known.** The channel input names which asset groups are live for this
  run (and which are paused). Checked by reading the plan artifact and a live
  `get_pmax_asset_groups` read. If a pending decision leaves it open, the plan must name the
  default branch; with no default, this precondition fails.
- **The account's success line names an isolated conversion action.** Checked by reading the
  channel input. Blended conversion columns never govern a verdict.

## Slot 1 — Format spec

| Format | Field type | Filename token | Spec (cited, not copied) |
| --- | --- | --- | --- |
| Square 1:1 | `SQUARE_MARKETING_IMAGE` | `square` | the channel's production spec § Production spec; platform owner: Google Ads Help, Performance Max asset specifications |
| Portrait 4:5 | `PORTRAIT_MARKETING_IMAGE` | `portrait` | same |
| Landscape 1.91:1 | `MARKETING_IMAGE` | `landscape` | same |

Files are JPEG or PNG. The create tool refuses a file over 5,242,880 bytes or of any other type
before calling the API; this adapter's pre-check owns the pixel dimensions.

## Slot 2 — Policy and quality checklist

1. Not a bare UI screenshot: product UI appears inside a frame, a scene or a composition, never as
   the whole image.
2. No real-looking customer names, addresses or phone numbers, even when the data is demo data.
3. No UI element cut mid-line at any edge or crop.
4. The brand mark is present and legible at placement scale.
5. Pixel dimensions and file size are in spec for the format (Slot 1).
6. Render check at placement scale via `visual-spot-check`: view the image at the size it serves
   (a feed card on a phone, a Display unit, a Gmail tile), not at design size.
7. Intended viewer: the channel's buyer as the channel input defines them (for a vertical SaaS, the
   operator who runs the business). The draft signals that fit through vertical specificity,
   operator context and the price point. Fails if a generic consumer, or an operator in a
   neighbouring vertical, could mistake it as meant for them.
8. Any text on the image is a claim the brand-and-source kit carries, verbatim where it is a number.

Lines learned on an account go to the run ledger's `## Checklist additions`; lines that hold for
this asset type on any account are promoted here (driver self-update directive).

## Slot 3 — Production method options

| Method | Lens / skill | Typical time |
| --- | --- | --- |
| Composed graphic: product UI inside a device frame or scene, on a brand-kit background, one claim | `marketing-skills:image` (screenshot-plus-overlay or design-tool route) | hours |
| AI generation (scene or background), composited with real product UI | `marketing-skills:image` (AI generation route); `marketing-skills:ad-creative` § Generating Ad Visuals | hours |
| Photo or design the channel owner produces | none: the owner produces it; the loop checks and ships it | days |

The method is chosen per brief, after discovery. Record which references and kit entries the draft
builds from.

## Slot 4 — Ship tool and approval-gate mechanism

- **Approval gate:** the project's local staged-action queue. Each tool call appends one row; the
  owner approves each row; the queue executor runs it after its cooling-off period. Nothing calls a
  mutating handler outside the MCP's dispatcher.
- **Create:** `create_image_asset` with `name`, and `image_source` as `{ file_path, sha256 }` (the
  hash is the drift guard between approval and execution). The executed row reports `asset_id`,
  `created`, `requested_name` and `stored_name`. **`created: false` means Google matched an existing
  asset with identical bytes and dropped the new name** (the row also carries `existing_asset_id`);
  the loop records the returned id and uses it, and the account gains no asset. **`created: null`
  means the post-create read could not tell**; read the asset by id before staging any link row,
  and never assume it is new.
- **Per-target write:** after the create executes, one `update_pmax_asset_group_assets` row per
  live asset group, each approved on its own. Before staging each row, read
  `get_pmax_asset_group_configuration` for that group's current `content_hash` and pass it as
  `expected_content_hash`, with the group's parent `campaign_id` (a mismatch is refused). The row `add`s the new asset in its field type and `remove`s that group's
  still-linked disapproved assets **of the same field type only**.
- **Floors the write tool enforces:**
  - *Minimum count:* a removal that would leave a field type below Google's minimum (at least one
    `MARKETING_IMAGE` and one `SQUARE_MARKETING_IMAGE`; `PORTRAIT_MARKETING_IMAGE` has no minimum)
    is refused, counting only the links that remain after the row. So a disapproved square is
    removed only in a row that also adds a square.
  - *Auto-created links:* any add or remove of a link whose `source` is `AUTOMATICALLY_CREATED` is
    refused. Never include one.
  - *Drift:* a stale `expected_content_hash` is refused; re-read the configuration and re-stage.
- **Quiet-window check:** `get_change_history` on the campaign for the last 48 hours. Structural
  means a budget change, a campaign or asset-group status change, a bidding change, or a negatives
  change reaching the campaign.
- **Fallback:** if `create_image_asset` is not callable, the owner uploads the file in the Google
  Ads Asset Library and the loop records the asset id the UI shows; linking still goes through
  `update_pmax_asset_group_assets`. If that tool is also unavailable, the sequence is pause the group,
  `replace_pmax_asset_group_configuration`, enable the group (three staged rows per group), and every
  read-back names the status flip as a confound.

## Slot 5 — Read-back query and verdict thresholds

| Checkpoint | Offset | Query / tool | Interim method |
| --- | --- | --- | --- |
| Review gate | 72 hours after the link rows execute | `get_pmax_asset_performance` filtered to the new `asset_id`: `primary_status` and `primary_status_reasons` per group | `run_gaql` (kernel v0.2.0+), or the project's GAQL runner, on `asset_group_asset` with `primary_status`, `primary_status_reasons`, `source` |
| Early read | 7 days | `get_pmax_asset_performance` with `conversion_action_id` set to the channel's isolated conversion action: impressions, clicks, CTR and `sibling_share` per `(asset_group_id, field_type)` | the same GAQL runner, per-asset metrics query plus the conversion-action-segmented query, merged on `(asset_group_id, asset_id, field_type)` |
| Full read | 14 days | the same, plus `get_campaign_metrics` for `search_rank_lost_impression_share` on each campaign against the baseline, and campaign cost per trial on the isolated action | the same |

- **Reminder mechanism:** the channel continuity ledger. On the day the link rows execute, add
  three entries, one per checkpoint:
  `npm run ledger:add -- --channel google-ads --summary "<run> it<NN> <checkpoint> read-back" --ref "<iteration artifact path>" --expected-check-by <YYYY-MM-DD>`
  (in the Google Ads MCP repo). The daily audit routine reads `ledger:list --open` first.
- **Creative KPI:** CTR against siblings. Ad relevance is a Search keyword Quality Score component
  and does not exist for Performance Max; it belongs to a Search text adapter.
- **Outcome KPI:** the campaign's search impression share lost to rank. It is a campaign-level
  outcome that text assets and bids also move, so it is reported, never credited to one image.
- **Metrics rules:** asset-attributed metrics are not additive; never sum them to a group or
  campaign total. Map the API network value `CONTENT` to "Display Network" in prose.
  `performance_label` is not used (rejected on this API version).
- **Asset kill floor:** at the full read, `sibling_share` below 10% of the sibling set's
  asset-attributed impressions, when the set has at least 1,000 impressions in the window. The
  sibling-share test applies only once the set holds two or more eligible assets.
- **Only asset in its set** (for example the first eligible portrait in every group): judge instead
  on (a) eligibility at the review gate, (b) its CTR against the same group's other image formats
  over the same window, and (c) rank-lost impression share against the baseline, reported as
  campaign context.
- **Minimum volume:** a CTR claim needs at least 500 impressions on the new asset. Below the
  1,000-impression set floor the read is `underpowered` and extends to 21 days; a slot that cannot
  reach the floor even at 21 days pools the same format across all live groups for the comparison
  and records `underpowered-pooled`.
- **Direction retirement:** two consecutive disapprovals on one hypothesis.
- **Guardrail:** campaign-level cost per trial on the isolated conversion action, read against the
  Client Context's directional bands with its minimum signal window. An asset that lifts CTR while
  the guardrail leaves its band is flagged, not kept by default. These thresholds are provisional
  until the first iteration's full read.

## Slot 6 — Sibling set and slot inventory

- **Sibling set:** assets of the same `field_type` in the same `asset_group_id`.
- **Slot inventory, in order:** first every format with no eligible asset, portrait before square
  before landscape, across every live group; then replacements for surviving assets that share the
  rejected assets' risk pattern (named by the gut-check), in the order the gut-check ranks them.
- **Overlap:** one new asset per `(field_type, asset_group_id)` at a time; different sets may
  overlap (driver Step 2).
- **Loop done:** every live asset group holds at least one eligible asset in each of the three
  formats and no disapproved image remains linked, so the campaign no longer reads "asset groups
  limited by policy", confirmed by a live read and the campaign UI.

## Instance bindings

This adapter carries no account data: no customer, campaign, asset-group, asset or conversion-action
ids, no baselines, no volumes. Each account's bindings live in one instance file in the project's
`CM Artifacts/` folder, named `adapter-pmax-image-instance-<client>.md` (the general pattern is
`adapter-<type>-instance-<client>.md`). At Step 0 the driver reads it after this file and before
the channel input, and takes from it: the live asset-group list per pending-decision branch, the
isolated conversion action, the outcome baselines with their windows, the power-check volumes, the
slot order for the account, the owner and approver, and the cited production spec. If no instance
file exists, create it from the channel input before the first brief; a value in it is a dated
record, so re-read it live before use.
