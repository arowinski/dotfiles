---
name: clear-writing
description: Use when writing or editing any prose humans will read — README, code comments, commit messages, PR descriptions, error messages, UI text, reports, explanations, or general module documentation. Also use when user says "write clearly", "clear writing", "improve writing", "tighten", or "edit for clarity". For generating Elixir `@moduledoc`/`@doc`/`@spec` from scratch, use /doc.
---

# Clear Writing

Every sentence must earn its place. Write the minimum that conveys the complete meaning.

## Composition

1. Omit needless words
2. One paragraph per topic
3. Begin each paragraph with a topic sentence
4. Use active voice
5. Put statements in positive form
6. Use definite, specific, concrete language
7. Avoid succession of loose sentences
8. Express co-ordinate ideas in similar form
9. Keep related words together
10. Place emphatic words at end of sentence

## Style

- Keep paragraphs short: no more than three brief sentences
- Vary sentence length to avoid monotony
- Replace jargon and complex words with plain, direct language; use contractions
- Remove cliches, filler adverbs, and stock metaphors (e.g., "navigate," "journey," "roadmap")
- Use bullets only for 3+ parallel items of the same grammatical shape
- Do not append a meta-summary of what you just wrote. Required structural sections (Test plan, Summary, etc.) are not summaries
- Do not use em dashes or double hyphens (--); use commas, colons, periods, or rewrite as needed

## De-AI checklist

After rewriting, scan for and eliminate these patterns:

**Vocabulary** — ban these words outright unless quoting someone: "testament," "landscape," "delve," "tapestry," "foster," "leverage," "nuanced," "multifaceted," "underscores," "notably," "arguably," "crucial," "vital," "moreover," "furthermore," "additionally," "comprehensive," "robust," "seamless," "paradigm," "realm"

**Inflation** — don't overstate importance. Cut "groundbreaking," "revolutionary," "game-changing" and similar hype. Say what it does, not how amazing it is.

**Copula hiding** — say "is" or "was." Don't write "serves as," "stands as," "functions as," "acts as" when a plain copula works.

**"Not just X, it's Y"** — delete this construction. State the point directly.

**Synonym cycling** — pick one word and stick with it. Don't rephrase the same idea three different ways in three sentences.

**Filler phrases** — "in order to" → "to." "It is important to note that" → cut. "At the end of the day" → cut.

**Excessive hedging** — one qualifier is enough. "Could potentially possibly" → "could." Don't stack "may," "might," "perhaps" in the same passage.

**Generic conclusions** — no "only time will tell," "the future remains to be seen," or other vague sign-offs. End with something concrete.

**Sycophancy and chatbot artifacts** — no "Great question!", "I hope this helps!", "Happy to help!" These don't belong in written prose.

## Output

Return only the prose. No commentary unless the user asks for an explanation of changes. Do not preface output with caveats about length, completeness, or what was cut.

## Process

1. List the ideas the output must carry: from the input if rewriting, from the source (diff, ticket, spec, conversation) if writing fresh. Write the shortest sentence per idea. Eliminate preamble, restatement, hedges, throat-clearing.
2. Read the result aloud (mentally). Fix any sentence that still sounds machine-made.
3. If the second pass changed anything, do a final read to make sure meaning was preserved.
