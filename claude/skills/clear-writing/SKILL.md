---
name: clear-writing
description: Check two exclusions first. Elixir documentation attributes and doctests — `@moduledoc`, `@doc`, `@spec`, `@typedoc` — always belong to /doc, whether the ask is to write one from scratch or clean one up; never handle those here. Text aimed at a person in a live thread — reviewer replies, issue comments, Slack — belongs to human-writing. Otherwise use this skill whenever the wording itself is the deliverable: drafting or reworking a README, doc page, code comment, commit message, PR description, release note, error string, UI copy, or report, plus any request to tighten, shorten, polish, de-jargon, cut fluff, or make something read better. Signal: prose is being produced or handed to you and the user cares how it sounds. Not for work about documents rather than their words — verifying docs still match reality, fixing links or a failing docs build, grepping stale references — and not for writing code or tests.
---

# Clear Writing

Every sentence earns its place. The reader's attention is the scarce resource, and prose that wastes it gets skimmed, then ignored, then not read at all. Write the minimum that carries the complete meaning.

That last word matters. Compression never trades away meaning: a qualifier that marks real uncertainty, a negation, a number, a condition, all stay. Cutting them makes the text shorter and wrong.

## Composition

These do the heavy lifting, in rough order of how often they fire:

1. Omit needless words. Most first drafts carry 20-30% packing material.
2. Begin each paragraph with a topic sentence, one topic per paragraph. A reader scanning first sentences should get the argument.
3. Use active voice and definite, concrete language. "The job retries three times" beats "retry behavior is applied as configured."
4. Put statements in positive form. "Forgot" beats "did not remember."
5. Keep related words together, and put the emphatic word last. The end of a sentence is the position a reader remembers.
6. Express parallel ideas in parallel form, and vary sentence length so a run of them doesn't drone.

## Style

- Paragraphs run three brief sentences at most.
- Plain words over jargon. Contractions are fine.
- No cliches, filler adverbs, or stock metaphors ("navigate", "journey", "roadmap").
- Bullets only for 3+ parallel items of the same grammatical shape. Two items are a sentence.
- No meta-summary of what you just wrote. A required structural section (Test plan, Summary) is not a meta-summary.
- No em dashes or double hyphens in prose you produce; use commas, colons, periods, or rewrite. This governs your output, not the user's own text, which you leave alone unless asked to edit it.

## The AI tells

These patterns mark text as generated and unedited. A reader who spots two or three of them starts discounting everything around them, which costs you the argument even when the content is right. Scan for them after rewriting:

**Vocabulary** - cut unless quoting someone: "testament", "landscape", "delve", "tapestry", "foster", "leverage", "nuanced", "multifaceted", "underscores", "notably", "arguably", "moreover", "furthermore", "additionally", "comprehensive", "robust", "seamless", "paradigm", "realm". "Crucial" and "vital" are usually inflation; keep one only where the stakes are genuinely load-bearing and named.

**Inflation** - "groundbreaking", "revolutionary", "game-changing". Say what it does; let the reader judge how impressive that is.

**Copula hiding** - "serves as", "stands as", "functions as", "acts as". Say "is".

**"Not just X, it's Y"** - state the point directly.

**Synonym cycling** - one name per thing, every time. Renaming the same component three ways reads as variety to the writer and as three components to the reader.

**Filler phrases** - "in order to" becomes "to". "It is important to note that" gets cut whole.

**Stacked hedges** - one qualifier is enough. "Could potentially possibly" becomes "could". Genuine uncertainty stated once is not hedging.

**Generic conclusions** - no "only time will tell", no "the future remains to be seen". End on something concrete, or stop.

**Sycophancy** - no "Great question!", "I hope this helps!". These belong to chat, not to prose.

## Examples

Each pair shows one tell and what survives once it's gone. The note under a pair explains the edit to you. It is not part of the rewrite, and nothing like it belongs in what you hand back.

**Hedge plus filler:**
`It is important to note that this change could potentially improve performance in some cases.`
becomes `This change cuts p99 query time by roughly 40%.`
The hedge carried no information. The number does.

**Copula hiding plus inflation:**
`The scheduler serves as a robust, comprehensive solution for managing job execution.`
becomes `The scheduler runs queued jobs and retries the ones that fail.`

**Synonym cycling:**
`The parser validates the input. The analyzer checks the payload. The component then verifies the request body.`
becomes `The parser validates the request body.`
Three names for one thing read as three things.

**Generic conclusion:**
`Only time will tell how this approach performs at scale.`
becomes `We have not tested this above 10k concurrent connections.`
The vague version says nothing; the concrete version tells the reader what risk they're taking.

## Output

Return only the prose. No commentary unless the user asks what changed, and no caveats about length or what was cut.

Where the source is vague but real ("expires after some period"), keep the fact and drop the padding ("expires after a set period"). Deleting it entirely tells the reader less than the draft did, and inventing a specific value the source never gave is worse than either.

Keep the subject a standalone sentence needs. "Rollbacks work in most cases" reads fine next to the draft it replaced and says nothing on its own; "The migration tooling rolls back in most cases" survives being read cold.

## Process

1. List the ideas the output must carry: from the input if rewriting, from the source (diff, ticket, spec, conversation) if writing fresh. Write the shortest sentence that carries each one.
2. Read it back. Any sentence that sounds machine-made gets rewritten, not patched.
3. Check the ideas from step 1 all survived. Compression that dropped one is a rewrite failure, not a tight draft.
