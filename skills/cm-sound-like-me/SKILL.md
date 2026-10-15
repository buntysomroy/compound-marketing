---
name: cm-sound-like-me
description: "Use when writing, drafting, replying to, or revising an email or a Slack message — any outward message sent AS the user — or when the user says 'sound like me', 'voice gate this', 'make it sound like me', 'gate this draft', 'did you gate this'. A BLOCKING pre-step: match the draft to the current user's voice profile BEFORE it is shown or sent. Reads that user's profile from their connected `Compound Marketing` Drive folder (Drive-driven — no GitHub or local files needed). Generic and workspace-agnostic; the profile is written by /cm-build-voice. Draft-only — never sends."
---

# /cm-sound-like-me — Voice Gate

Match any outward message to the current user's voice BEFORE it is shown or sent. This is a **blocking pre-step**: run it the moment the task is to write, draft, reply to, or revise an email or a Slack message that goes out as the user. A draft produced without this gate (no footer) is ungated by definition — do not produce one.

Generic and workspace-agnostic: it reads the voice profile from Drive, applies that profile's rules, and hands back a gated draft. It never sends.

## Where the profile lives (resolve at runtime)

The current user's voice profile lives at `Compound Marketing/voice/voice-profile.md` in that user's connected Drive. Resolve the path by walking its parents, not by searching the entire Drive for a filename that might occur elsewhere. With Shanti Drive tools, search for the root using `shanti_search_drive({rawQuery:"name = 'Compound Marketing' and mimeType = 'application/vnd.google-apps.folder' and trashed = false", fileType:"folder", pageSize:100})`; use `rawQuery` for Drive query syntax, not the free-text `query` argument. Continue with `pageToken` until the complete result has no next page. For folder listings, use `shanti_list_drive_files({folderId, pageSize:1000})` and continue with each returned `pageToken` until exhausted. After resolving the unique root, call `shanti_get_drive_permissions({fileId: rootFolderId})` and confirm its owner matches the identity of the connected account. A unique path or successful read does not prove profile ownership. Do not use a team-shared Drive profile for an individual user's voice. If permissions are unavailable, the connected account identity is unknown, or the owner does not match, use **Profile status unknown** and stop.

1. Complete the exact root-folder search, then resolve one unique, non-trashed match. Do not read the profile or draft while any search page remains unread.
2. List every page of that folder's direct children and resolve one unique, non-trashed `voice` folder.
3. List every page of the `voice` folder's direct children and resolve one unique, non-trashed `voice-profile.md` file.
4. Call `shanti_get_drive_permissions({fileId: profileFileId})` and confirm the file owner matches the connected account too. If the root or file owner cannot be confirmed, use **Profile status unknown**; do not read or apply another user's profile.
5. For **Profile present**, read that exact file as plain markdown bytes. For a cloud doc, use the docs-store read tool; never read a `.gdoc` stub from disk.
6. Resolve exactly one of these states before drafting:
   - **Profile present** — the exact file at the resolved path was read successfully.
   - **No profile** — a successful, complete search/list confirms the root folder, `voice` folder, or profile file is absent.
   - **Profile status unknown** — a lookup/read/permissions check failed, timed out, was denied, was incomplete, returned duplicate/ambiguous path matches, or could not establish that the root folder owner is the connected account. Stop without drafting and explain the observed reason (see Degradation).

If a Shanti search/list result says more pages are available, pass its `pageToken` to the same tool and continue until no next page remains. If the tool exposes only full-text search, if a token cannot be followed, or if completeness cannot otherwise be confirmed, use **Profile status unknown** and stop before reading the profile or drafting. Never establish uniqueness by checking a partial first page or by revisiting the search after drafting. If the read tool paginates or reports truncation, retrieve all content before treating the profile as present. If completeness cannot be confirmed, use **Profile status unknown**. A no-profile result skips the profile read and proceeds to the generic branch; an unknown result stops the run.

The named Drive file is the source of truth. Do not substitute another profile API, service-backed voice endpoint, memory, or cached local file when this search/read fails.

## Run this, in order

### 1. Content-truth gate (proportional — judgment, not always-on)

Before wording anything, decide how much truth-checking the message needs:

- **Full check** — when the message asserts something happened or will happen that is NOT already established this session (a claim about live state, a deliverable, a sent action, a metric). Verify each claim against the real system (live UI, file, API result — not memory), and hand the user a visual check of the actual deliverable to approve before the message goes anywhere.
- **Lite check** — a one-line "here's what I'm asserting, confirm it's true" when the claim is minor or partially established.
- **Skip** — when the message is an acknowledgement, a thanks, a scheduling reply, or the facts are already loaded in this session's context.

Only once the content is verified true (to the level the message needs) do you run the voice pass.

### 2. Load the profile

When status is **Profile present**, read the complete Drive `voice-profile.md` resolved above. It carries: a prose voice description, hard rules (including absolute bans like em/en dashes), avoided language, good/bad anti-pattern pairs, register-by-audience, **signature phrases** (the vocabulary and hedges to reach for), and any per-profile toggles (e.g. strategic-message mode). Load it every time — do not draft from memory of the voice. If the read fails or is incomplete, use the **Profile status unknown** branch; do not try a different profile backend. When status is **No profile**, skip this step and follow the generic branch. When status is **Profile status unknown**, stop without drafting.

### 3. Draft against the rules

When status is **Profile present**, write the message, check it against the loaded profile's hard rules, and apply exactly what the profile says; do not invent rules. Common ones profiles carry:

- No em/en dashes — restructure with a period or comma, or split the sentence.
- First person, never third ("ping me", not "ping <name>").
- Short is default — a few sentences per message; break long thoughts into separate lines.
- No preamble before the ask; the first word does work.
- No hype, no decorative emoji, no corporate filler (leverage, synergy, circle back, touch base).
- No bold in casual/DM messages (bold section labels only in longer structured messages).
- End on the substance, not a trailing offer to do more.
- Register match: casual for DMs, clean and plain for public channels.

Then, only when **Profile present**, reach for the profile's **signature phrases** where they fit naturally — the voice is not just the absence of anti-patterns, it is the presence of the person's real vocabulary and hedges. Don't force them; don't strip them when they belong.

When status is **No profile**, use only the generic rules below. Do not apply profile-specific hard rules, signature phrases, strategic-message settings, or personal style inferred from memory. When status is **Profile status unknown**, stop without drafting.

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

A profile that defines its own footer line (a `Footer` step, or a `[voice gate …]` line in its procedure) wins: use that format instead.

The footer is metadata for the user — strip it when the message is actually sent. Only emit it if the gate actually ran.

### 6. Draft-only + calibration

Present the gated draft **inline**. Never send, never call a send/draft tool on the user's behalf — they edit it or send it themselves. Ask once (not a debrief): "did this land as your voice, or should I update the profile?" If they edit it, offer to fold the change into the Drive profile.

## When the profile carries its own procedure

A profile may include a gate procedure of its own (what to ground first, how to deliver, how to calibrate after a send) next to the voice rules. Where that procedure differs from the defaults above (staging the message with the platform's draft tool instead of draft-inline-only, the footer, where a correction is saved), follow the profile. The profile is the user's own ruling; these defaults only cover a profile that says nothing.

## Degradation

- **No profile found** — only after a successful Drive search/list confirms the folder or file is absent, apply sane generic copy rules (short, direct, no hype, no em dashes, first person) and tell the user to run `/cm-build-voice` to create their profile. Do not infer the sender's name, signature, or personal voice from model memory or unrelated context; omit the signature or use a placeholder unless the user supplied it in this request. Footer reads `no profile — generic rules`.
- **Profile status unknown** — if search, read, or permissions lookup is denied, errors, times out, or returns an ambiguous result, or if the connected account identity or matching owner cannot be established, do not draft the requested message and do not emit either success footer. Tell the user the profile could not be verified and give the observed reason. A permission or tool failure is never evidence that no profile exists.

## Generic — no personal or workspace hardcodes

This skill ships with zero personal config. Each run resolves the current user's Drive profile:

- Profile source = the Drive convention path, resolved at runtime — never a fixed personal filename.
- "Owner's own channel" exemption (a self-DM that skips the gate) = a value in the profile config, not a hardcoded ID.
- Sender name and signature = values provided in the current request or loaded profile. When no profile exists and the user did not provide them, omit the signature or use a neutral placeholder.
- No references to any specific person, workspace path, or an external voice-profile backend.

## Companion skill

`/cm-build-voice` creates and updates the current user's Drive `voice-profile.md` (samples that user's writing, interviews for hard rules, writes the profile into the user's `Compound Marketing` folder). Run it once per user before this gate has a profile to read.
