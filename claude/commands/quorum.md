---
description: Ask 3 architects + 2 code reviewers the same question, then synthesize consensus.
disable-model-invocation: true
argument-hint: <question about code, architecture, or approach>
allowed-tools: Bash(git rev-parse:*), Bash(git diff:*), Bash(git log:*), Read, Glob, Grep, Agent
---

Spawn a quorum of 5 agents to answer the same question independently, then synthesize.

Run `git` directly. For a different repo use `cd <path> && git <cmd>`.

## Setup

1. Read the question from the argument. If empty, stop and ask for one.
2. Gather context the agents will need:
   - `git diff HEAD` (current uncommitted changes, if any)
   - `git diff main...HEAD` (branch changes, if on a feature branch)
   - Read any files referenced in the question
## Spawn

Launch all 5 agents in a **single message** using the Agent tool with `run_in_background: true`:

- 3x `subagent_type: architect` — prompt each with the question + context. Each must work independently.
- 2x `subagent_type: code-reviewer` — prompt each with the question + context + diff (if relevant).

Include in every agent prompt:
- The full question
- Relevant context (diff, file contents)
- "Answer independently. Do not coordinate. Be specific — cite files and line numbers."
- "Run `git` directly. For a different repo use `cd <path> && git <cmd>`."

## Collect

Wait for all 5 responses.

## Synthesize

Present the result as:

**Consensus** — points where 3+ agents agree. These are high-confidence findings.

**Split** — points where agents disagree, with the positions and who holds them.

**Unique insights** — points raised by only one agent that are worth considering.

**Verdict** — your synthesis: what should the user do, based on the weight of evidence?

Keep it concise. Quote agents by name when attributing positions.

No team cleanup needed — agents terminate when done.
