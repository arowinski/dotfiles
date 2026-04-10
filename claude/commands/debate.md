---
description: Spawn an agent team to debate a question and converge on a recommendation
argument-hint: <question, topic, or Jira URL>
model: opus
---

Accept a question, pasted requirements, or Jira URL as input.
If no argument provided, ask for a topic.

If Jira URL: fetch ticket details via Atlassian MCP (if available).

Frame 2-4 positions or perspectives worth arguing. If the user provided specific positions, use those. Otherwise, present the framing and wait for confirmation.

## Rules

- Use TeamCreate and SendMessage to create a real agent team. Do NOT simulate the debate.
- Do NOT use tmux for agent management.
- All teammates are read-only — no file edits.
- Give each teammate the full topic, context, and their assigned position.
- Teammates must research the codebase for evidence, challenge others, and concede when evidence is against them.

## Moderation

1. **Opening arguments** — each teammate presents their case with evidence
2. **Cross-examination** — direct teammates to challenge specific claims
3. **Convergence** — ask if any have changed position or want to concede

Limit to 4-5 rounds. Cut off unproductive tangents.

## Output

Synthesize a recommendation:

**Topic** — the question debated

**Positions** — each position's core argument + key evidence

**Consensus** — what all sides agreed on

**Disagreements** — what they couldn't resolve

**Recommendation** — your synthesis

**Open Questions** — anything needing user input

Present to user. Clean up the team.
