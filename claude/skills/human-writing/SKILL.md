---
name: human-writing
description: Use when drafting text read by another human as peer-to-peer communication — PR review comments, replies to reviewer feedback, GitHub/GitLab issue comments, Slack messages, code-review thread responses. Focuses on voice and tone so the text sounds like a colleague, not an AI. Differs from clear-writing (which handles structural prose quality across all contexts including docs); use both for peer comms — clear-writing for sentence-level edit, human-writing for voice.
---

# Human Writing

Drafts that sound like a developer talking to a peer. Contractions, fragments, direct verdicts. Reject phrasings that mark text as machine-generated.

## Forbidden LLM tells

Reject and rewrite if the draft contains:

- "It would be advisable to..."
- "I would suggest..."
- "This appears to..."
- "Consider..." as an opener
- "It might be worth..."
- "Please ensure..."
- "Let me know if you have questions"
- Sophisticated vocabulary when plain works: utilize → use, implement → build/add/fix, demonstrate → show, facilitate → help, ascertain → check, subsequent → next, prior to → before, commence → start, terminate → stop, instantiate → create, invoke → call, execute → run, perform → do. Fancy words read machine-generated; plain words read peer.
- Corporate deflection — "the team", "stakeholders", or other abstractions standing in for the person who made the call. Write as the dev: "we" or a subjectless imperative ("Revisit when Rails retires the feature"). "The team will revisit..." reads like a press release.

## Permitted human voice

- Contractions (`doesn't`, `won't`, `you're`, `I'd`)
- Fragments where they read tight ("Off-by-one. Use `<` here.")
- First-person when natural ("I'd reach for `Enum.find`", "I think this...")
- Direct verdicts ("blocker", "nit", "ship it", "lgtm")
- Casual openers when appropriate ("Hmm, intentional?", "Wait, what if...", "Yeah, you're right")
- Backticked code references inline (`func/2` reads more peer than "the func function")
- GitHub auto-links short SHAs (`a3f8b7d`) and `#1234`; file paths don't — append `#L42` or `#L42-L50`, and SHA-pin the URL for stability (`.../blob/<sha>/file.ex#L42-L50`).
- Caption by what the link points to (`[the nil guard]`, `[the failing test]`), not the bare path; bare path only when the location itself is the point.
- Better still: post it as an inline review comment on the line, so the path is implicit.
- Backticks for code identifiers (`func/2`), not paraphrase — `lib/auth.ex`, not "the auth module".

## Bad-vs-good examples

**LLM:** It would be advisable to handle the case where `customer.plan` is nil, as this could potentially cause an exception.
**Human:** What if `customer.plan` is nil here? Crashes on `.price`.

**LLM:** Consider extracting this into a separate function for improved readability.
**Human:** Worth extracting? Two callers want this logic.

**LLM:** I would suggest using `Enum.find/2` to make this more idiomatic.
**Human:** `Enum.find/2` reads cleaner here.

**LLM:** It is important to note that this approach may have performance implications at scale.
**Human:** N+1 risk, runs per row. Batch instead?

**LLM:** Please ensure proper error handling is implemented for this edge case.
**Human:** Empty-list case isn't handled. `[head | _]` will raise.

## How to apply

1. Draft the text
2. Scan for forbidden LLM tells — replace each
3. Check for missed contractions; replace `do not` → `don't`, etc.
4. Look for soft openers; cut them if the sentence stands without
5. Read aloud (mentally) — if it sounds like a tech-blog template, rewrite

## Layered with clear-writing

human-writing is voice. clear-writing is structure. For peer comms, load both:
- clear-writing trims needless words, enforces parallelism, drops jargon
- human-writing strips LLM tells, allows fragments, adds peer voice

Don't replace clear-writing. The two work together: clear-writing's edits keep sentences tight; human-writing's edits make them sound like a colleague.

clear-writing already bans hedging stacks, sycophancy closers ("I hope this helps"), and inflated vocab (`leverage`, the `furthermore`/`moreover` transitions) — don't re-list those here; this skill keeps only the peer-voice tells clear-writing doesn't cover.
