---
name: resolving-merge-conflicts
description: Work an in-progress git merge or rebase conflict hunk by hunk, resolving each by the intent behind both sides, then run the project's checks. Use when a merge, rebase, cherry-pick, or stash pop stops on conflicts — "resolve the conflicts", "fix the merge conflict", "the rebase blew up", CONFLICT (content) in git output. Not for choosing a merge strategy or planning a rebase. Never aborts; finishes the operation only when the request said to.
allowed-tools: Bash(git:*), Bash(gh:*), Bash(gh-comments:*), Bash(just:*), Bash(mix:*), Bash(MIX_ENV=* mix:*), Bash(bundle exec:*), Bash(yarn:*), Read, Edit, mcp__atlassian__getJiraIssue
---

# Resolving Merge Conflicts

Resolve by intent, not by picking lines. Every hunk has two authors who each wanted something; the resolution keeps both wants, or names which one lost and why.

**You do NOT:** run `--abort` or `--skip`, take a whole file with `--ours`/`--theirs`, invent behaviour neither side had, or finish the operation (`--continue`, `git commit`) unless the user's request said to.

## Workflow

1. **See the state.** `git status` names the operation and the conflicted files. For a merge, `git log --oneline --merge` lists the commits from both sides that touch the conflicts. For a rebase, `git rebase --show-current-patch` is the commit being replayed and `git log --oneline HEAD..<upstream>` the other side.

2. **Find the primary source for each side.** Commit messages and `git show` for the commits, the PR (`gh pr view`, `gh-comments`), the ticket when the branch or PR names one. Know why each change was made before touching the hunk.

3. **Resolve each hunk.** Keep both intents where they compose. Where they conflict, keep the one that matches the operation's stated goal and note the trade-off. Read the whole file after editing: a resolved hunk can leave a duplicate definition, a missing import, or a dangling reference outside the markers. `grep -n '^<<<<<<<\|^=======\|^>>>>>>>'` over the touched files must return nothing.

4. **Run the checks.** The `just` recipe if the project has one, else typecheck, the tests for the touched files, then format. Fix what the merge broke, nothing else.

5. **Stage and report.** `git add` the resolved files. Report per hunk: file, both intents, what you kept, any trade-off. End with the command that finishes the operation (`git rebase --continue`, `git merge --continue`, `git cherry-pick --continue`). Run it only when the request asked for the operation to be finished; a rebase can stop again on the next commit, so repeat from step 1 until it's through.
