---
description: Ask five agents with fixed lenses (Architect, Skeptic, Pragmatist, Critic, Precedent) the same question, then synthesize where the lenses agree.
disable-model-invocation: true
argument-hint: <question about code, architecture, or approach>
allowed-tools: Bash(git rev-parse:*), Bash(git diff:*), Bash(git log:*), Read, Agent
---

Five agents answer one question independently, each through a different lens, then you synthesize. Agreement between lenses that pull in opposite directions is the signal; five copies of one lens would only agree with themselves.

Run `git` directly. For a different repo use `cd <path> && git <cmd>`.

## 1. Restate

Read the question from the argument. Empty? Stop and ask for one.

Rewrite it as three lines: **Decide** (the choice being made), **Constraints** (what is fixed: decisions already made, scope, deadlines), **Good answer** (what a useful answer contains). A vague question gets five vague answers; this is where it gets sharp. Don't wait for confirmation — the restatement opens your output, so a misread shows there.

## 2. Gather pointers

- `git diff HEAD` (uncommitted changes, if any)
- `git diff main...HEAD` (branch changes, if on a feature branch)
- Files the question names

Collect paths and facts, not conclusions. Agents read the files themselves.

## 3. Spawn

Launch five `subagent_type: general-purpose` agents in a **single message** with `run_in_background: true`, one per lens:

| lens | looks at |
|---|---|
| Architect | correctness and the long-term shape of the answer |
| Skeptic | the premise: does this need solving at all, is there a simpler framing |
| Pragmatist | shipping cost, operations, what breaks on Monday |
| Critic | edge cases and the downside if the answer is wrong |
| Precedent | what this codebase and its git history already do for this kind of problem, and whether it was tried before |

Every prompt carries the same brief plus its lens:

- the three-line restatement
- pointers: paths, refs, the diff range
- facts: constraints, decisions already made, what was tried and what happened — events, not verdicts on them
- its lens, from the table, as the angle to answer from
- "Answer independently. Do not coordinate. Be specific — cite files and line numbers."
- "Read only: never edit or run anything that changes the tree."
- "Run `git` directly. For a different repo use `cd <path> && git <cmd>`."

Leave out your own lean. A prompt that hints at the answer you expect turns five lenses into one.

## 4. Synthesize

Wait for all five, then present:

**Question** — the three-line restatement from step 1.

**Consensus** — points where 3+ lenses agree, naming the lenses. Skeptic and Pragmatist landing on the same answer outweighs Architect and Precedent doing so.

**Split** — where lenses disagree, each position and which lens holds it.

**Unique** — points raised by one lens that are worth weighing.

**Verdict** — what to do, on the weight of evidence.

Keep it concise.
