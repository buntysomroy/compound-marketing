---
name: cm-analytics-audit
description: >-
  Compound Marketing — the ANALYTICS-DEBUGGING audit. Verify a client's conversion-tracking end-to-end in the live systems (storefront tags → GTM container → ad-platform/web-analytics conversion actions), diagnose double-counts / dead actions / gclid-capture gaps, and package the exact fix. Use when the user says '/cm-analytics-audit', 'audit the tracking', 'is the purchase tag firing', 'verify the conversion tracking', 'why is All-Conv way higher than Conv', 'check gclid/utm capture', 'GTM audit', 'conversion double-count', or when a plan action is hard-blocked behind an LP/conversion-tracking gate before any pause/restructure.
---

# /cm-analytics-audit — Compound Marketing: analytics-debugging audit

> **Where this sits.**
> A diagnostic sibling of the CM pipeline (`/cm-audit` → `/cm-analyze` → `/cm-plan` → `/cm-review` → `/cm-execute`). It runs when a `/cm-plan` action is **hard-blocked behind a conversion-tracking gate** ("verify the canonical purchase action / gclid capture before pausing anything"). Its output feeds the blocked plan action, and its artifact is a `<!-- cm:solution -->` doc — the same shape `/cm-plan` single-problem mode emits.
>
> Full CM pipeline reference: `reference/sop-cm-pipeline.md`

This is the **audit stage for measurement itself** — turn "is the tracking right?" into a verified, sourced diagnosis and a packaged fix. **Verify every finding in the live system; never infer a tag/action state from the storefront alone or from memory.**

## Core principle

A tracking claim you did not see in the live GTM container + the live ad-platform conversion-actions screen (Google Ads, Meta, etc.) is a guess. The storefront tells you what _loads_; only the container + the ad-platform goals screen tell you what _counts_. Trace each purchase from `dataLayer`/pixel → GTM tag (ID + label + trigger) → ad-platform conversion action (Primary/Secondary + count) before concluding anything.

## Global rules (read first)

- **Confirm access before driving.** Client browser work runs in a **dedicated browser profile** for the account; confirm the logged-in Google account first (wrong profile reads as a false "no access").
- **Verify each finding live.** Storefront inspection is necessary but NOT sufficient — the double-count, dead actions, and Primary/Secondary status only exist in GTM admin + the ad platform. Flag any un-verified inference with "⚠️ INFERENCE".
- **Prefer reversible + observable over irreversible.** Pause a tag and **publish a documented GTM version** (revertible via version history) rather than hard-delete. Do NOT remove a _live_ ad-platform conversion action until you've **observed the fix held** (All-Conv drops while the Primary holds) over ~1 week — removing it now erases the confirmation signal and is less reversible. Optimize for the next debugger.
- **Never place a real purchase.** The final end-to-end "one conversion with gclid" proof needs a real/test order — that is a **site-owner** action, not something the agent executes. Everything short of the order is verifiable by us.
- **Resolve IDs to names.** Name conversion actions, tags, and containers; keep the raw IDs (label, `AW-…`, `GTM-…`) alongside as copy-paste anchors.
- **Recommend the root-cause option:** fix the duplicate _fire_ at source, not just the symptom number.

## The phase flow (0 → 1 → 2 → 3 → 4 → **4.5 review gate** → 5 → 6)

### Phase 0 — Intake

Capture: client slug, the tracking question, the blocked plan action (if any), and the platforms (Shopify? GHL? WordPress? custom?). Confirm admin access + the dedicated browser profile.

### Phase 1 — Storefront tag-layer audit (what LOADS)

Load the storefront with a **test gclid + utm** (`?gclid=TEST_AUDIT_123&utm_source=google&utm_medium=cpc&utm_campaign=tracking_audit`). In one JS pass extract:

- Platform (`window.Shopify` etc.); GTM container IDs (`gtm.js?id=GTM-…`); gtag IDs (`AW-…`, `G-…`, `GT-…`); inline `gtag('config',…)` + `AW-…/label` refs.
- `dataLayer` events; **gclid capture** — does `_gcl_aw` / `_gcl_au` / `_gcl_ls` get written? (proves the conversion linker fires on ad-click).
- Other pixels (Meta `_fbp`, Klaviyo, TikTok) and whether GHL is present at all.
- Flag **multiple web-analytics (GA4, etc.) streams** (more than one `_ga_*` cookie = more than one property firing).

### Phase 2 — GTM container audit (what is CONFIGURED)

In GTM admin for the container found in Phase 1, enumerate every tag. For each **conversion/purchase** tag read: Tag type, **Conversion ID + Label**, Value / **Transaction ID** (dedup key) / Currency variables, **Conversion Linking**, and **firing trigger**. Note duplicates (two purchase tags, two Conversion Linkers) and each tag's age/enhanced-conversions setting.

### Phase 3 — Ad-platform (+ web-analytics) conversion-actions audit (what COUNTS)

In your ad platform (Google Ads → Goals → Conversions, Meta, etc.), enumerate all actions. Per action: **source** (Website / web-analytics import / UA), **"Included in account-level goals" (= Primary vs Secondary)**, **count + All-conv**, **last seen** (dead vs live), attribution/window. Identify: the single Primary purchase action (canonical), redundant Secondary purchase actions, and dead/legacy actions.

### Phase 4 — Diagnose

Map GTM tags ↔ ad-platform actions **by conversion label**. Determine:

- **Canonical action** = the single Primary purchase action, and which GTM tag/pixel feeds it.
- **Double-count** = 2+ actions counting the same order (usually a GTM tag + a web-analytics import, or two GTM purchase tags with different labels). This is the "All-Conv ≫ Conv" gap.
- **Dead weight** = legacy-source or last-seen-months-ago actions; redundant Conversion Linkers; multiple web-analytics streams.
- **gclid/utm health** = confirmed by Phase 1's `_gcl_aw` write + tag Conversion Linking.

### Phase 4.5 — Adversarial review (HARD GATE — do NOT skip before any live change)

The diagnosis is a set of **claims**, and a first-pass reading is routinely wrong (e.g. "the double-count is in the reported Conversions" — often it is _only_ in All-Conversions). Route the diagnosis through **`/cm-review`**'s lenses **before** Phase 5 touches anything live — this is the same Stage-4 gate `/cm-plan` runs, and it is what makes "verify every finding" a mechanical step rather than something the operator has to remember to ask for:

- **`cm-lens-evidence` (the critical one here):** for every finding, was it verified against the **authoritative live source** (GTM admin tag config + the ad-platform conversion-actions screen), or is it inferred from the storefront alone / from memory? Default to **"assumption until proven in the live system."** A finding that can't cite the live screen it came from does not pass.
- **`cm-lens-measurement`:** every proposed fix names a success signal + where it's observed (All-Conv drop, Primary hold, test-order confirmation).
- **`cm-lens-ownership`:** every change has the right owner (admin vs site-owner test order) and a rollback.
- **`cm-lens-brand-client`:** any number that could reach the client is framed correctly (internal-only until reconciled).

Fold confirmed findings in; unresolved ones become Open questions. **No live GTM/ad-platform change in Phase 5 until the evidence lens has cleared each finding it touches.** (Origin: a real audit run — the operator had to manually request "verify each finding," which _is_ this lens; baking it in as a gate removes that dependency on memory.)

### Phase 5 — Package + apply the fix

- **Apply now (reversible):** pause the duplicate purchase tag(s) in GTM; **publish a documented version** (name + full description: what/why/reversibility/follow-ups).
- **Defer (irreversible / signal-destroying):** removal of the live redundant ad-platform action → hold ~1 week to observe All-Conv drop; dead-action archiving; web-analytics-stream consolidation; the **site-owner test order**.
- State exactly what each owner does, and the gate impact on the blocked plan action(s).

### Phase 6 — Write the artifact + gate + hand off

Write the `<!-- cm:solution -->` doc (template below). Render the verified findings + fix inline in chat first (Report-Findings-Before-Output). Present the apply/defer decision via `AskUserQuestion` (Apply / Document-only), recommending the reversible root-cause fix. Hand off deferred items as tracked tasks.

### Artifact template

```
<!-- cm:solution -->
# CM Solution — <Client> — <Tracking topic> (<blocked gate ref>)
## 1. Problem            <the gate + the symptom number>
## 2. Evidence base      <one row per VERIFIED fact: storefront / GTM / ad-platform — source named>
## 3. Root cause         <the double-count / dead-weight, + any first-pass correction>
## 4. Fix                <applied now (reversible) vs deferred (with why); owner each>
## 5. Measurement plan   <signal · where · when — incl. the ~1-week observation + test order>
## 6. Gate impact        <how this unblocks each downstream plan action>
## 7. Open questions
## Lens Review Summary
```

## Self-update directive

When a run surfaces a recurring tracking failure mode (Shopify checkout-pixel vs theme-dataLayer double-fire, web-analytics-import-over-gtag double count, multi-stream web analytics, a new platform's capture quirk) or a better verification step, update this file or propose the improvement before finishing.
