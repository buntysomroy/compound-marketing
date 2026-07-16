---
name: cm-build-voice
description: "Use when setting up or updating a workspace's voice profile for the voice gate — 'build my voice profile', 'set up my voice', 'create a voice profile', 'update my voice profile', 'seed my voice from these samples', or '/cm-build-voice'. The companion setup skill to /cm-sound-like-me: it samples the user's real writing (an existing profile, pasted samples, or a connected source), interviews for hard rules, and WRITES the profile into the `Compound Marketing` Drive folder so /cm-sound-like-me has something to read. Generic and workspace-agnostic; no external backend, Drive-only."
---

# /cm-build-voice — build the workspace voice profile

Create or update the voice profile that `/cm-sound-like-me` reads. Interactive: gather real writing, agree on the hard rules, then write the profile to Drive. This is the setup half of the pair — run it once per workspace before the gate has a profile, and again any time the voice should be refined.

Generic: no personal or workspace hardcodes, no external backend. The profile lives in Drive as plain markdown.

## Step 1 — Resolve the Drive destination

Write to the shared **`Compound Marketing`** Drive folder — the same docs store `/cm-compound` writes to and `cm-learnings-researcher` reads. Resolve it once per run:

1. Search/list your Drive (or your workspace's docs store) for a folder named `Compound Marketing`.
2. If it does not exist, create it (top-level, flat).
3. The profile file is `Compound Marketing/voice/voice-profile.md`. Create the `voice/` subfolder if needed.
4. Never write to the repo or a local sandbox path — write through your Drive tooling. If the docs store is unreachable, stop and say so loudly (do not write a half-profile locally).

## Step 2 — Gather source material

Prefer the richest source available; you need enough real writing to characterize the voice, not invent one.

| Source               | Method                                                                                                                                                                                                                             | Min   |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| **Existing profile** | The user already has a voice doc or profile markdown — import it as the starting point (best case; skip cold interviewing). For a workspace with prior voice work, also fold in any accumulated "confirmed rules / learnings" doc. | 1 doc |
| **Pasted samples**   | Ask the user to paste 10+ real messages/emails they have written.                                                                                                                                                                  | 10    |
| **Connected source** | If a Slack/email tool is available, pull ~20 of the user's own sent messages.                                                                                                                                                      | 20    |

If material is thin, say so — a thin profile is fine as a v1, but note it so the gate's output is calibrated to that.

## Step 3 — Interview for the hard rules

Rules are the non-negotiables the gate enforces. Confirm each with the user (short, not a survey):

- **Punctuation** — em/en dashes, semicolons, Oxford comma, ellipsis, exclamation points.
- **Greetings & sign-offs** — how they open, whether they sign off, what they never write ("Hope this finds you well").
- **Banned language** — corporate filler and phrases to avoid (leverage, synergy, circle back, touch base).
- **Length & structure** — default message length, bullets vs prose, when bold is allowed.
- **Emoji** — none / occasional / free.
- **Register by audience** — DM vs public channel vs external; how formal each gets.
- **Strategic-message mode** — should the gate, on a thinking/brainstorm message, surface the thesis + keep evidence + invite critique rather than compress to logistics? On/off toggle.

## Step 4 — Synthesize the profile

Build the profile in the structured shape `/cm-sound-like-me` expects. Draw the rules from the interview and the patterns from the samples (real good/bad pairs beat abstract rules).

## Step 5 — Write `voice-profile.md`

Write this structure to `Compound Marketing/voice/voice-profile.md` (plain markdown, real bytes):

```
# Voice Profile — <profile-name>

## Style (prose)
<a paragraph describing how this person writes: sentence length, rhythm, tone, greetings/sign-offs, delay-acknowledgement style>

## Hard rules
- <the absolute rules from the interview>

## Absolutely banned
- <e.g. em dashes, en dashes>

## Avoided language
- <filler phrases, buzzwords>

## Anti-patterns (good / bad)
- bad: "<AI-default phrasing>"  →  good: "<their phrasing>"

## Register by audience
| Context | Register |
| --- | --- |
| DM | ... |
| Public channel | ... |
| External | ... |

## Toggles
- strategic-message-mode: on | off
- owner-self-channel: <a channel/DM id that skips the gate, or "none">

## Examples
- <2-4 real before/after or golden snippets>
```

Also write a one-line `Compound Marketing/voice/CLAUDE.md` breadcrumb: what lives here and that `/cm-sound-like-me` reads `voice-profile.md`.

## Step 6 — Present + hand off

Show a short summary of the built profile (style one-liner, the hard rules, register table, the toggles). Tell the user `/cm-sound-like-me` will now read this profile on any outward email/Slack message. Offer to refine any section.

## Seeding an existing workspace

When the workspace already has voice material (an existing profile doc plus any accumulated "confirmed rules / learnings" doc), seed from BOTH rather than interviewing cold: import the existing profile as the base, then fold the confirmed/graduated rules on top (they are the most current signal), then only interview to fill gaps. This is the fast path for a workspace that has been doing voice work by hand.

## Notes

- **Generic** — no personal names, workspace paths, or external backends hardcoded. Everything specific comes from the user's inputs and lands in their Drive.
- **Distinct from any workspace-internal voice tooling** — some workspaces have their own backend-based voice builder; this skill is the plugin's Drive-only path and does not depend on it.
- **Companion:** `/cm-sound-like-me` reads the profile this skill writes.
