---
name: cm-sound-like-me
description: "Use when writing, drafting, replying to, or revising an email or a Slack message — any outward message sent AS the user — or when the user says 'sound like me', 'voice gate this', 'make it sound like me', 'gate this draft', 'did you gate this'. A BLOCKING pre-step: match the draft to the workspace's voice profile BEFORE it is shown or sent. Reads the profile from the `Compound Marketing` Drive folder (Drive-driven — no GitHub or local files needed). Generic and workspace-agnostic; the profile is written by /cm-build-voice. Draft-only — never sends."
---

# /cm-sound-like-me — Voice Gate

Match any outward message to the workspace's voice BEFORE it is shown or sent. This is a **blocking pre-step**: run it the moment the task is to write, draft, reply to, or revise an email or a Slack message that goes out as the user. A draft produced without this gate (no footer) is ungated by definition — do not produce one.

Generic and workspace-agnostic: it reads the voice profile from Drive, applies that profile's rules, and hands back a gated draft. It never sends.

## Where the profile lives (resolve at runtime)

The voice profile lives in the shared **`Compound Marketing`** Drive folder — the same docs store `/cm-compound` writes to and `cm-learnings-researcher` reads. Resolve it once per run, the same way the other CM skills resolve the folder:

1. Search/list your Drive (or your workspace's docs store) for a folder named `Compound Marketing`.
2. Read `Compound Marketing/voice/voice-profile.md` — plain markdown, real bytes. If it is a cloud doc, read via the docs-store tools; never a `.gdoc` stub off disk.
3. If the folder or file is absent, that is the "no profile" branch (see Degradation) — distinct from "could not read the docs store."

## Run this, in order

### 1. Content-truth gate (proportional — judgment, not always-on)

Before wording anything, decide how much truth-checking the message needs:

- **Full check** — when the message asserts something happened or will happen that is NOT already established this session (a claim about live state, a deliverable, a sent action, a metric). Verify each claim against the real system (live UI, file, API result — not memory), and hand the user a visual check of the actual deliverable to approve before the message goes anywhere.
- **Lite check** — a one-line "here's what I'm asserting, confirm it's true" when the claim is minor or partially established.
- **Skip** — when the message is an acknowledgement, a thanks, a scheduling reply, or the facts are already loaded in this session's context.

Only once the content is verified true (to the level the message needs) do you run the voice pass.

### 2. Load the profile

Read the Drive `voice-profile.md` resolved above. It carries: a prose voice description, hard rules (including absolute bans like em/en dashes), avoided language, good/bad anti-pattern pairs, register-by-audience, **signature phrases** (the vocabulary and hedges to reach for), and any per-profile toggles (e.g. strategic-message mode). Load it every time — do not draft from memory of the voice.

### 3. Draft against the rules

Write the message, then check it against the profile's hard rules. Apply exactly what the profile says; do not invent rules. Common ones profiles carry:

- No em/en dashes — restructure with a period or comma, or split the sentence.
- First person, never third ("ping me", not "ping <name>").
- Short is default — a few sentences per message; break long thoughts into separate lines.
- No preamble before the ask; the first word does work.
- No hype, no decorative emoji, no corporate filler (leverage, synergy, circle back, touch base).
- No bold in casual/DM messages (bold section labels only in longer structured messages).
- End on the substance, not a trailing offer to do more.
- Register match: casual for DMs, clean and plain for public channels.

Then reach for the profile's **signature phrases** where they fit naturally — the voice is not just the absence of anti-patterns, it is the presence of the person's real vocabulary and hedges. Don't force them; don't strip them when they belong.

### 4. Strategic / thinking-message mode (if the profile enables it)

If the profile turns this on AND the message is a strategic ask or brainstorm kickoff (not a quick coordination line), do NOT compress the author's reasoning to logistics:

- Surface the thesis explicitly ("My hypothesis is…") and state the mechanism.
- Keep concrete evidence and named examples — do not strip proof points for brevity.
- Lead the ask by inviting critique of the premise.
- Use a bulleted ask for 3+ items, with inline emphasis on load-bearing phrases.
- Close on a priority signal, not a CTA.

This mode is longer and more structured than a normal message — that is correct here; "short is default" yields to it.

### 5. Emit the footer

End the draft with exactly one line so a skipped gate is visible:

`[voice gate: <profile-name> applied]` — profile loaded and applied
`[voice gate: no profile — generic rules]` — no profile found, generic copy rules applied

The footer is metadata for the user — strip it when the message is actually sent. Only emit it if the gate actually ran.

### 6. Draft-only + calibration

Present the gated draft **inline**. Never send, never call a send/draft tool on the user's behalf — they edit it or send it themselves. Ask once (not a debrief): "did this land as your voice, or should I update the profile?" If they edit it, offer to fold the change into the Drive profile.

## Degradation

- **No profile found** — apply sane generic copy rules (short, direct, no hype, no em dashes, first person) and tell the user to run `/cm-build-voice` to create their profile. Footer reads `no profile — generic rules`.
- **Could not read the docs store** (tool error) — this is a LOUD caveat, not a clean "no profile." Say the profile could not be read and why; do not silently fall back as if none exists.

## Generic — no personal or workspace hardcodes

This skill ships with zero personal config. Everything workspace-specific comes from the Drive profile:

- Profile source = the Drive convention path, resolved at runtime — never a fixed personal filename.
- "Owner's own channel" exemption (a self-DM that skips the gate) = a value in the profile config, not a hardcoded ID.
- Footer name = the profile's own name field.
- No references to any specific person, workspace path, or an external voice-profile backend.

## Companion skill

`/cm-build-voice` creates and updates the Drive `voice-profile.md` (samples the user's writing, interviews for hard rules, writes the profile into the `Compound Marketing` folder). Run it once per workspace before this gate has a profile to read.
