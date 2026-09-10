---
description: Measure and improve a skill - trigger evals for the description, A/B for the body. Reports a table, not a wall of runs.
---

# Optimize skill

Target: $ARGUMENTS (a skill name or path; ask if missing)

Skills fail in two independent ways, and they need different evidence. A description that never triggers makes the body irrelevant. A body that doesn't change the output makes a rewrite theatre. Measure the first, and only touch the second when you hold a case it currently gets wrong.

`skill-eval` wraps the skill-creator plugin, so its train/test split and description-improvement loop stay upstream and keep improving. Don't edit the plugin.

## 1. Description first

Write 20 eval queries: 10 that should trigger, 10 that shouldn't. Realistic, specific, the way this user actually types - lowercase, file paths, a bit of backstory, occasional typos. The negatives carry the weight: make them near-misses that share vocabulary with the skill but belong to a sibling skill or to no skill at all. "Write a fibonacci function" as a negative for a PDF skill tests nothing.

Skip queries where two skills legitimately both apply. Companion skills stack (a `commit` run loading `clear-writing` is correct), so a query with no single right answer teaches the optimizer noise.

```
skill-eval triggers --skill claude/skills/<name> --evals /tmp/<name>-evals.json [--fixture <dir>]
```

Build a fixture whenever queries name files or need a dirty tree: the agent checks before it acts, and against an empty directory it answers "the working tree is unrelated" and never loads the skill. Every run gets its own copy, because eval runs commit and stage for real.

## 2. Read the result honestly

The tool prints a table, the winning description, and any borderline verdict re-probed without the injected probe command. Three traps, all of which have already produced wrong conclusions here:

- **Everything at zero, negatives included.** The harness is broken, not the description. `skill-eval` refuses to report in this case; fix the cause rather than working around the guard.
- **A "false positive" that co-loaded.** Two skills firing together is the inheriting relationship working, not a precision defect. The re-probe table shows what actually loaded.
- **One non-trigger on a short query.** Claude skips skills for tasks it can do in one step. Re-run with more context before calling it a defect; a one-line "reply to this comment" scored 0/5 while the same request with real context scored 3/3.

Apply the winning description only if it beat the original on the held-out split. Report the delta as recall and precision, not as a vibe.

## 3. Body only with a failing case

Don't rewrite a body because it reads like a wall of rules. Rewrite it when you can name output it currently gets wrong. Then:

```
skill-eval ab --skill claude/skills/<name> --cases /tmp/<name>-cases.json --runs 2
```

The arms are HEAD versus the working copy with the description held constant, so any difference is the body. Cases must not reuse scenarios from the skill's own examples: the model copies an example verbatim when the scenario matches, which looks like a win and proves nothing.

Call it a wash unless a difference repeats. Two arms differing once is noise. A rewrite that measures as a wash can still be worth keeping for what it teaches, but say so in exactly those terms rather than claiming an improvement.

## Size is a tiebreak, not a goal

Shorter isn't automatically better: `clear-writing` improved by *adding* worked examples, and that addition is the only body change that has beaten its baseline here. What's actually true is narrower - text that doesn't change behaviour is dead weight, and dead weight crowds out the rules that do fire.

So: when two versions measure the same, keep the shorter one and say why. A three-line rule that grew to seventeen and then A/B'd as a wash goes back to roughly three, fixing whatever made the original wrong and nothing else. Report the body's line count next to the scores so growth stays visible instead of accumulating quietly.

The asymmetry is deliberate. Additions have to earn their place with a measured difference; cuts only have to not lose one.

## 4. Report

Lead with the table. Then at most three sentences of summary, and one line naming what went unmeasured. No run-by-run narration.

```
| iteration | train | test | recall | precision |
```

State plainly when a change is unproven. "Kept for the meaning-preservation guard, measured as a wash" beats an implied win every time.
