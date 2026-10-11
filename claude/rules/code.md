# Code

Proposals, tickets, reviews: one solution, the smallest that works. No feature flags, config knobs, abstractions, or future-proofing unless asked by name. Extras = one line each, no code.
Any code change: finish what you touched (callers, tests, specs, renames, dead code from the old path). No TODO standing in for the work.
A code comment marks only what the code can't make clear: a gotcha, or a deliberate choice that looks wrong. Everything else goes into names, structure, or the commit message.
Every claim in a doc or comment matches the current code: a change updates the docs and comments it makes stale, in the same edit.
Before writing code, reuse in order: this codebase's existing pattern or helper, stdlib, platform feature, installed dependency.
Validate at trust boundaries: user input, params, external APIs, files, job args, rows other writers touch. Past them, a state is unreachable only when a match, a DB constraint, or every caller rules it out (read which), and it gets no branch and no test. Where a silent default (`|| []`, `&.`, `Map.get/3`) would hide a broken guarantee, assert instead (`{:ok, x} =`, bang, `fetch`). Minimalism never cuts authz, boundary validation, or data-loss guards.
Adjacent inconsistency your change exposed: fix only if leaving it breaks or misleads; otherwise name it in one line.
