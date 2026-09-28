# SOP — Creative Discovery (`/cm-creative-loop` Step 3)

> **Read by:** `/cm-creative-loop` before every brief.
> **Owns:** how an iteration finds its material: the owner interview, the gut-check of what already
> exists, the inspiration sweep with reference-and-beat, and the brand-and-source kit.
> **Output:** section `## 1. Discovery` and `## 2. Reference-and-beat` of the iteration artifact
> (template in the driver), plus the kit file on first run.

Making an asset is its own discovery loop, not a production call. A brief written from generic
knowledge produces generic creative. Every brief therefore cites material this SOP gathered: the
owner's own words, what already exists and why it lived or died, a concrete reference to beat, and
the brand's own source material.

## When each part runs

| Part | First iteration of a direction | Later iterations |
| --- | --- | --- |
| (a) Owner interview | Full | Only when the previous verdict changed the direction (kill, or a revise that changes the hypothesis) |
| (b) Gut-check of existing assets | Full | Re-run, scoped to what changed since the last iteration |
| (c) Inspiration sweep + reference-and-beat | Full | Re-run; each draft names its own reference |
| Brand-and-source kit | Build it before the first draft | Refresh on the triggers below |

When a part is skipped, the artifact says so and why, in one line. A skipped part with no line is
a gap, not a pass.

---

## (a) Owner interview

**One question per turn.** Ask the channel owner ONE question, wait for the answer, then choose
the next question in light of it. Never send the list as a batch, never put two questions in one
message, and never put several questions in one multiple-choice call. A batched interview gets
shallow answers to questions the owner has not been primed for, and the brief is built on them.
The rule is the owner's, verbatim (2026-09-27): _"whenever there are interview, requirements,
discovery questions, etc you need to ask me this 1 by 1. this needs to be a global rule."_ If
asked to batch, the driver prints `REFUSED (batched interview)` and asks only the next question.

The list below is the ordered question set the agent walks one question at a time. It may skip a
question an earlier answer already settled, or move one earlier when an answer points at it; it
records every skip or move in one line with the reason. Record each answer **verbatim** with the
date, under `### (a) Interview`. Do not paraphrase; a paraphrase can invert the meaning, and the
brief is built on it.

Each item is ONE question. A follow-up ("why?", "which part?") is its own next turn.

1. **Viewer.** Who exactly is this asset for?
2. **Moment.** What is that person doing when they see it?
3. **Claim.** What is the one thing the asset must make them believe?
4. **Proof.** What can we show or cite that makes that claim true?
5. **References, liked.** Which of these references do you like most?
6. **References, disliked.** Which of these references do you like least?
7. **Never appear.** What must never appear in this asset?

Show the references from (c) before questions 5 and 6, so the owner is reacting to something real.
If the owner is not present, record `Interview pending — owner not present` as an Open Item marked
blocking for the brief; do not answer for the owner.

---

## (b) Gut-check of existing assets

Invoke the `gut-check` skill where installed (otherwise do its method inline: reframe, sweep,
reconcile) scoped to the assets already on this channel for this asset type:

- **Open every file.** Look at each existing asset, live and rejected. A filename or a status field
  is not a look. Record one line per asset: what it shows, its current status, and why it lived or
  died if known.
- **Reconcile against the platform.** Status comes from a live read of the platform, not from a
  prior document.
- **Name the pattern.** One or two lines: what the rejected ones share, what the surviving ones
  share, and whether the survivors carry the same risk as the rejected ones.

Record under `### (b) Gut-check`.

---

## (c) Inspiration sweep and reference-and-beat

Name every source searched (a competitor reference folder, a public ad library, the brand's own
site, customer language) under `### (c) Inspiration sweep`, each with its path or URL. Then, for
each draft, write the **reference-and-beat record** under `## 2. Reference-and-beat`:

| Field | Content |
| --- | --- |
| Reference | Path or URL of the concrete reference asset |
| Viewed | How and when it was looked at (for example: opened with the image reader, 2026-01-12). A reference that was not opened cannot be cited. |
| Keep | What the draft keeps from it |
| Better | What the draft does better, and why that should win |

At least one reference per draft. The reference is an input to beat, never a template to copy.

---

## Brand-and-source kit

Before the first draft of a run, crawl the brand's public marketing site and write the kit to the
project's `assets/brand-kit/brand-kit.md`, with downloaded files beside it.

**Seed the crawl from where the asset will send people.** Start from the landing URLs the targets
already use (the adapter's instance bindings name how to read them), then follow the site's own
navigation. Do not depend on a sitemap: it may be missing, broken or incomplete. An API route the
site exposes is a bonus if it answers, never the only source.

**Kit sections**, each entry carrying the source URL it came from:

1. Logo files (downloaded, with format and size)
2. Palette (hex values and where each is used)
3. Typography (families and weights, and where seen)
4. Photography and illustration style
5. Product imagery (captures, with what each shows)
6. Headline claims (verbatim)
7. Pricing (verbatim, with the date read)
8. Testimonials and social proof (verbatim, with attribution as shown)

**Source check.** Every source URL in the kit must answer when re-fetched. Run the check after
writing the kit, and prove the check can fail by pointing it once at a deliberately wrong URL:

```bash
grep -oE 'https?://[^ )>|]+' assets/brand-kit/brand-kit.md | sort -u | while read -r u; do
  printf '%s %s\n' "$(curl -s -o /dev/null -w '%{http_code}' -L "$u")" "$u"
done
```

**Refresh triggers.** Re-check the kit's source URLs (a) at the start of each new asset-type
instance, and (b) before any iteration whose brief cites pricing, a testimonial or a user count. A
changed source page updates the kit before the brief is approved.

Every brief cites the kit by path. A brief that uses a brand claim not in the kit adds it to the
kit first, with its source.
