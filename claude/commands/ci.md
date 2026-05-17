---
description: Monitor GitHub PR checks and analyze failures. Use when user shares a GitHub Actions URL, asks to "fix failing CI", says "what wrong in CI", pastes an actions/runs URL, or asks why a CI job failed.
argument-hint: [PR-NUMBER]
---

Use the ci-monitor agent to check CI status and analyze any failures.

Pass the PR number if provided as argument ($ARGUMENTS), otherwise the agent will auto-detect from current branch.
