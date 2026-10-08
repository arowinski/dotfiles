---
name: review
description: One-run compound code review — parallel specialists, a tester that runs the changed behaviour in the live app (UI or eval), a verifier that confirms findings by experiment, a pragmatic skeptic pass, one numbered report with an apply menu. Use on "review", "review this / my changes / the PR", "thorough review", "before I push", or a PR link with review intent. Not for posting comments (post-review) or answering review feedback (triage-review).
argument-hint: [PR number or link, path, ref range, or empty for uncommitted]
allowed-tools: Bash(git:*), Bash(gh:*), Bash(find:*), Bash(wc:*), Bash(mix:*), Bash(bundle exec rspec:*), Bash(claude-review-ledger:*), Agent, SendMessage, Read, Edit, Skill, AskUserQuestion, ToolSearch, mcp__atlassian__getJiraIssue, mcp__tidewave__project_eval
---

# Review

One run, one report. Specialists work blind and read-only, the tester runs the change in the live app, the verifier experiments, the orchestrator judges. Nothing is applied until the menu at the end.

## 1. Scope

Resolve `$ARGUMENTS` to a diff:

- PR number or link: `gh pr view` + `gh pr diff`, after branch alignment below
- path: `git diff` restricted to that path, plus the files there for context
- ref range (`main...feature`): `git diff <range>`
- empty: uncommitted changes (staged + unstaged); clean tree → commits ahead of upstream (`git diff @{upstream}...HEAD`); no upstream → `git diff HEAD~1`

Write the diff once to `<scratchpad>/review-diff.patch`; every agent reads that path instead of carrying a copy. Delete it in step 7.

**Branch alignment (PR only).** Agents read file content from a working tree, so the tree they read must be at the PR head or every citation is wrong:

1. `gh pr view <pr> --json headRefOid,headRefName` vs `git rev-parse HEAD`
2. On mismatch, `git worktree list`: a sibling worktree already on the PR's head branch becomes the review tree. Every command runs from that path and every agent prompt names it ("Repo: <path>, a git worktree; run all commands from there, never cd to another repo"); the current tree is left alone.
3. No such worktree: if `git status --porcelain` shows changes, `git stash push -m "auto-stash before /review of PR #<n>"` and tell the user to `git stash pop` when done; then `gh pr checkout <pr>`. In a workspace with a running app this swaps the code under it, so say so in the same line.
4. Re-verify HEAD in the review tree

## 2. Context, built once

- **Size**: added + removed lines in the patch. Under 50 is a *small* diff.
- **Languages**: extensions of changed files. `.ex`/`.exs` present enables the docs angle.
- **Plan file**: `<git-common-dir>/claude/plans/<branch>.md` if present.
- **Ticket**: from the plan file, the PR title or body (`ENG-\d+` or the project's key), or the branch name (`eng-555`). If found, fetch title, description, acceptance criteria, and comments via Atlassian MCP. A ticket enables the acceptance angle.
- **Doc inventory**, deterministic:

  ```
  find . \( -name node_modules -o -name vendor -o -name deps -o -name _build \
            -o -name worktrees -o -name .git \) -prune -o \
       \( -name 'CLAUDE.md' -o -name 'AGENTS.md' -o -name 'AGENT.md' \
          -o -path '*/.claude/rules/*.md' \
          -o -path '*docs/guidelines/*.md' -o -path '*docs/how-to/*.md' \) -print
  ```

  `wc -w` the list. Identical counts beside each other (`AGENTS.md` next to `CLAUDE.md`) are one file under two names: keep one. Always include `~/.claude/CLAUDE.md`, repo-root `CLAUDE.md`, repo-root `README.md`, and each `~/.claude/rules/*.md` whose `paths:` glob matches a changed file. If the corpus cannot sit beside the diff in one agent, say so in the report rather than letting an agent sample silently.

## 3. Fan-out

Launch every firing angle in a single message via the Agent tool with `run_in_background: true`, then invoke `Skill(doc, "branch")` when the docs angle fires; the doc fork runs in the foreground and overlaps the background agents. Wait for all of them before step 4.

| angle | fires when | subagent_type, model |
|---|---|---|
| conformance | always | review-specialist, sonnet |
| discovery | diff not small | review-specialist, opus |
| architecture | diff not small | review-specialist, opus |
| security | always | review-specialist, opus |
| correctness | always | review-specialist, opus |
| acceptance | ticket or plan `## Invariants` found | review-specialist, opus |
| reuse | always | simplifier, opus |
| simplification | always | simplifier, opus |
| efficiency | always | review-specialist, opus |
| altitude | always | simplifier, opus |
| docs | `.ex`/`.exs` in diff | doc-writer fork via `/doc branch` |

**Every prompt carries**: the review tree's path as the repo to run in, the patch path, its report path `<scratchpad>/review-<angle>.md`, the size and language facts, the plan and ticket summaries, the angle's name, and "Answer independently. Do not coordinate." A review-specialist prompt also gets the angle's paragraph from the Angles section at the end of this file as its whole scope and "Scope strictly to lines the diff adds or changes"; a simplifier's angles and scope are its own. Conformance and discovery also get the doc list. The finding format, severity scale, read-only rule, and report return are each agent's own; do not restate them.

**Every prompt returns the same way**: the agent writes its full report to its report path with a Bash redirect (the scratchpad sits under `/private/tmp`, which the hook allows) and returns a short receipt ending in the path: a review-specialist sends the Coverage line (conformance and discovery only) and finding counts by severity, a simplifier its finding count. A background agent's inline result is cut at about 5K characters, so the file is the report and the return is the receipt.

## 4. Gather and dedupe

Read every report file. Merge findings that share file, line, and claim into one, citing every agent that raised it; conformance and discovery, or a simplify lens and correctness, converging from different directions is signal, note it. A cleanup (reuse, simplification, altitude) whose fix conflicts with a correctness or security finding on the same line or mechanism is dropped; the defect wins. Map the doc report: each per-file draft becomes one finding at nit severity (`[docs] path`, one line on what changed, draft attached); each unverifiable claim becomes one finding at info.

## 5. Verify by experiment

**Preflight.** Experiments need a live app, and Tidewave binds to the workspace the session started in (its port expands from that worktree's env), so it only speaks for the session's own tree. Check, in order, before dispatching:

1. The review tree is the session's tree: `git rev-parse --show-toplevel` from the session cwd equals the review tree path. A sibling worktree fails this.
2. Elixir in the diff → Tidewave is loaded (`ToolSearch "select:mcp__tidewave__project_eval"` returns it) and live (`project_eval` of `System.version()` answers).
3. Rails in the diff → `bundle exec rspec --version` answers from the review tree.

Check 2 fails with Tidewave loaded but silent, and `ws status` shows the workspace stopped → start it yourself: `ws run` with `run_in_background: true`, then re-run check 2 until `project_eval` answers. A running workspace whose app will not answer or compile (a reloader that demands a server restart after a config change) → restart only the app process, never the whole workspace, because `ws restart` on a live workspace can corrupt its postgres; say so in one line and carry on.

Check 2 fails with `ws status` showing the workspace running but the Tidewave tools absent from the session → its MCP connection gave up while the workspace was down (Claude Code retries a dropped server for about 30 seconds, then marks it failed), and only the user can reconnect it.

Any check still failing → `AskUserQuestion`, one question: which is missing, and the choice between *continue on evidence only* (the verifier and tester are skipped, every finding keeps its desk verdict and the report says so in the Coverage line) and *stop* (you restart the session in the right worktree, then rerun). In the Tidewave case above, offer *reconnect* first: the user runs `/mcp`, reconnects tidewave, and says go; then rerun check 2. A non-Elixir, non-Rails diff skips the preflight.

Dispatch exactly one `verifier` agent with the review tree path and every deduped finding (angle, `path:line`, claim, reasoning), whatever angle raised it. Its experiments, the `static` label, and the rules for probes and state are its own; do not restate them, and do not split the findings across several verifiers. An experiment the orchestrator runs inline counts as none. The step 7 Coverage line carries the verifier's tally.

**Exercise the diff.** In the same message as the verifier, dispatch the `tester` agent with the review tree path, the patch path, the PR number, the ticket key, and the plan path when step 2 found them. It builds its own behaviour list from those, runs each line in the live app (UI through the Tidewave browser, backend through `project_eval`), and returns one line per behaviour: `works (ui|eval)`, `broken`, or `untestable (<cause>)`. Every `broken` line becomes a finding, severity by its harm, angle `exercise`, verdict `confirmed`, and goes through step 6 like any other.

**Second pass.** Once the verifier and the tester have both returned, a finding the tester saw happen in the app is `confirmed`, citing the tester's line. Then send the same verifier a mutation pass via SendMessage: every finding it left `static` or `untestable`, unfiltered. The verifier, not you, decides which an eval or an edit-and-run settles. In the same message, send the tester every such finding whose claim shows in the app (a page, a count, a refresh). Their new verdicts replace the old ones, and the step 7 Coverage line counts them.

## 6. Skeptic pass

Orchestrator, no extra agents. For each finding, four checks:

- **Mechanical**: the cited file and line exist; the line sits on the right side of the diff (RIGHT for added or modified, LEFT for deleted); the quoted evidence matches the code or rule text.
- **Reasoning**: the chain from evidence to harm holds with no gap and no "could be exploited if" without a shown path.
- **Fix coherence**: the fix addresses the claim.
- **Reach and cost**: a caller in this repo produces the triggering input (name the caller check that shows it), and the fix costs less than the harm.

A cleanup (reuse, simplification, altitude) has no triggering input, so its fourth check is **behaviour kept** instead: the Fix's after form returns the same result as the before form for every input the code receives. A cleanup that removes a guard gets reach inverted: the cited guarantee holds, and no caller or boundary produces the guarded state. A cleanup passing all four is Polish; failing behaviour kept or the inverted reach is Failed.

Bucket:

| bucket | criteria | treatment |
|---|---|---|
| Strong | all four pass | present, numbered |
| Polish | passes all but the harm is small and the fix is a few lines that leave the code plainly better | present, numbered, own section |
| Weak | mechanical passes, reasoning has a gap | present with the gap named |
| Unlikely | reach fails: no caller reaches the input, or the fix costs more than the harm | drop; one line each in a count so the user can disagree |
| Failed | mechanical fails, or the verifier refuted it | drop, count silently |

The verifier's verdict settles the reasoning check: `refuted` is Failed; `confirmed` passes it, and the finding is Strong or Polish by size unless reach fails. A probe can build an input no caller produces, so a finding can be confirmed and Unlikely at once. Pragmatism cuts both ways: a small real improvement is worth listing, a hypothetical that needs an input nothing produces is not, however elegant the argument.

## 7. Report

Open with one Coverage line: docs read, docs skipped with reason, then `changes exercised: N/B` over the tester's behaviours, then the verifier tally over every deduped finding: `tested: N/M`, followed by the M−N not tested, counted by reason — `S static (grep/read only)`, `K desk (no command settles it)`, `J untestable (<cause>)`, or `M desk — verifier skipped: <reason>`. The counts sum to M. Under it, the tester's lines as a short list: behaviour, then `works via UI`, `works via eval`, `broken → #N`, or `untestable (<cause>)`. Then numbered findings: **Blockers**, **Major**, **Nit**, **Polish**, **Info**, then **Weak** with each gap named, then `_(Unlikely: N — one line each)_` and `_(Failed: N)_`, both printed even at zero. Within a section, order by file path. Omit empty severity sections. Each finding:

- **N. [angle] path:line** — Claim; Evidence; Reasoning (Cost for a cleanup); Fix; verifier verdict and command, or `desk — <why not>` when no experiment ran.

**Record the run** before printing the report: pipe one tab-separated row per deduped finding, Unlikely and Failed included, to `claude-review-ledger add --tree <review tree>`, plus `--pr <n>` when the scope is a PR. A row is: the report number (`-` for Unlikely and Failed), section (`blocker` `major` `nit` `polish` `info` `weak` `unlikely` `failed`), angle, `path:line`, verdict (`confirmed` `refuted` `static` `desk`, or `untestable (<cause>)` with the verifier's cause), the claim in a few words. The ledger refuses a correctness, security, efficiency, or acceptance row marked `static` or `desk`: send that finding back to the verifier, then record its new verdict. A clean run records too, with nothing on stdin: a reviewer's later comment on it is a miss. Keep the run id it prints for step 8.

Every specialist clean → "No findings", no menu. Once the report is printed, delete the patch and every `review-*.md` in the scratchpad, whichever way the run ends: one `rm -f <scratchpad>/<name>` per path, absolute (a `cd` plus a relative path prompts).

## 8. Apply menu

End with one line; the user types the key as the next message (Colemak home row: `t` left index, `n` right index, `s` left ring):

> Next: `[t]` apply every Strong and Polish finding · `[n]` apply by number · `[s]` /post-review

Show `[s]` only when the scope is a PR whose author (`gh pr view <pr> --json author -q .author.login`) differs from `gh api user -q .login`. On `t` or `n`: apply each chosen finding in the main session from its Fix field, doc drafts included, run the narrowest matching test after each, show one diff at the end, and record the fixes that landed with `claude-review-ledger applied <run id> <n,n,...>`. Skip a fix that would change intended behaviour or reach well outside the reviewed diff, and say which and why instead of arguing with the finding. A typed action word ("apply", "post") works too.

## Angles

One paragraph per review-specialist angle: its role and non-scope, pasted into its prompt at step 3. Reuse, simplification, and altitude live in the simplifier agent.

**Conformance** — full diff plus the doc list with word counts; reads every doc on the list; checks the changeset against stated rules and nothing else. Quote the rule verbatim with its source path beside the offending code. Before claiming something is missing from a config file, read that file. Apply a rule only where it governs: a rule about how the agent issues commands does not govern a committed script; look for existing code that contradicts the reading before flagging; when scope is uncertain, say so and lower the severity.

**Discovery** — the doc list as paths, reading what it needs; its job is what no rule names: a change satisfying one layer of a multi-layer convention but not the others; a new file diverging from the established pattern for its file type (audit siblings to prove the pattern); a rule that plainly does not apply despite matching keywords (say so, cite the precedent); claims checked against the world (does the cited path exist, does the command resolve); anything the docs never anticipated, including a malformed diff.

**Security** — auth, input validation, secrets, injection, authz, SSRF, deserialization, crypto, race conditions on security-relevant paths. Reasoning must describe a concrete attack: input source → vulnerable sink → impact. Non-scope: style, naming, architecture.

**Architecture** — patterns, layering, coupling, abstractions, module boundaries, dependency direction, public API design, structural naming (modules, classes, public functions). Non-scope: line-level bugs, local style.

**Correctness** — edge cases, off-by-one, error handling, nil/empty handling, test gaps, local naming (variables, private functions, locals). Two audits on top: for every line the diff deletes or replaces, name the invariant it enforced and find where the new code re-establishes it (a removed guard, a dropped error path, a narrowed validation, a deleted test is a finding when nothing does); for every changed function, find its callers with `rg -n` and check the change against each call site (new precondition, changed return shape, new exception, ordering dependency) and its callees for a parallel change in the same diff. For every changed public function, find its test: a new branch with none, or a vacuous test, is a finding. A test is vacuous when it would still pass with the change reverted: it only checks "doesn't raise", supplies the value the code should produce, or refutes with no positive twin. Non-scope: security, architecture, acceptance criteria.

**Acceptance** — for every acceptance criterion in the ticket, name the diff hunk that fulfils it; missing or partially met criteria are findings. For every reviewer comment on the ticket that raises a concern, check whether the diff addresses or ignores it. When the plan has an `## Invariants` section, every invariant is kept by the diff or its removal is justified in the plan; one silently dropped is a finding. Non-scope: anything the ticket or plan does not mention.

**Efficiency** — wasted work the diff introduces: repeated queries or preloads for the same rows, N+1 patterns, independent queries that could be one, list operations on large id lists that a query or subquery would do, `OFFSET` pagination on a large table where a cursor would do, inserts in a loop instead of one multi-row insert, an external call inside a transaction, sequential work that is independent, blocking work added to startup or a hot path, and client events that reach the server more often than the work needs (a keystroke or blur that triggers a LiveView `phx-change` or a request, including an event bubbling up from a nested input to its form). Name the cheaper alternative and the cost as extra round-trips per call or how it scales. Report only what costs a real round-trip or scales with data; skip micro-optimisations.

**Docs** — the doc skill's own `branch` sweep, returned as per-file drafts plus unverifiable claims.
