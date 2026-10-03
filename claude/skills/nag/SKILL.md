---
name: nag
description: Interview the user about a plan, decision, or idea until nothing that changes the build is left undecided, then write the decisions to the plan file. Use on "nag me", "grill me", "interview me about X", "poke holes in this", "stress-test my thinking", "what am I missing", "question me before we build", including a plan laid out right in the message; a leading `one` asks one question at a time. Not for a question that has an answer (answer it), not for researching how to build (design), and not on a plan the user already called final.
allowed-tools: Bash(git rev-parse:*), Bash(git branch:*), Bash(mkdir:*), Read, Write, Edit, Agent
argument-hint: [one] <plan, decision, or idea to be questioned about>
---

# Nag Me

Interview the user until you share one understanding of what gets built. Map the decisions as a **design tree**: each settled decision exposes the ones that hang off it.

**You do NOT:** answer your own questions, act on the plan, create branches, commit, or hand off to design or implementation. The session ends with a written decisions block and the user's confirmation.

## Rounds and the frontier

Work in **rounds**. The **frontier** is every decision whose prerequisites are settled: the questions you can ask now without guessing at answers you haven't heard. Ask the whole frontier in one round, numbered, each with your recommended answer, then wait. A question whose answer depends on another question still open in this round belongs to the next round.

Each answer reshapes the tree: settled decisions push the frontier outward and unblock what depended on them. Recompute and ask the next round.

**One at a time.** When the argument starts with `one`, a round is a single question: the frontier decision the most others hang off, asked alone, in the same format as a round of one. The rest of the frontier waits for the answer. Assumptions accumulate and print once, at the finish, instead of after every question.

## What earns a question

Ask only where the answer changes what gets built: a different module, schema, interface, behaviour, or scope. Everything else you would otherwise ask, decide yourself and list under **Assumed** at the end of the round, one line each, so nothing is silently assumed and nothing trivial blocks the user. The user overrides an assumption by saying so.

## Facts are yours, decisions are theirs

Never ask for a fact you can look up: read the code, grep, check git. Spawn an Explore agent only when the lookup is a real exploration (many files, unknown location), and keep asking the rest of the frontier while it runs; only the questions downstream of it wait. Every decision goes to the user, and you wait.

## Round format

Write every round out as prose — each question with its context and the reason it matters, choices inline, recommended one first; never the AskUserQuestion picker:

```
**Q1 · <title>**
<question, with the choices if there are any>
Recommended: <answer, one line of why>

**Q2 · <title>**
...

**Assumed**
- <decision you made and why it doesn't need them>
```

## Finish

The session is done when the frontier is empty. Then:

1. Write the decisions to `<git-common-dir>/claude/plans/<branch>.md` (`git rev-parse --git-common-dir`; `mkdir -p` the parent). Add or replace a `## Decisions` section: one line per settled decision, assumptions included, each stated as a fact ("Targeting lives in tags, not a join table"). If the file doesn't exist, create it with a title and that section; `/design` fills the rest.
2. Show the block and stop:

> Decisions saved at `<path>`. Confirm they match your understanding before /design or building.
