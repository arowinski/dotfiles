---
description: Spawn an agent team to debate a design question and converge on a recommendation
argument-hint: <question, topic, or Jira URL>
model: opus
---

Accept a design question, pasted requirements, or Jira URL as input.
If no argument provided, ask for a topic.

## Setup

1. **Parse input:**
   - If Jira URL: fetch ticket details via Atlassian MCP (if available), extract title, description, acceptance criteria
   - Otherwise: use input as the debate topic

2. **Frame the debate:**
   - Identify 2-3 distinct positions or approaches worth arguing
   - If positions aren't obvious from the topic, research the codebase first to find realistic options
   - If the user already provided specific positions, skip confirmation and spawn immediately
   - Otherwise, present the framing: "I'll set up a debate between: [position A] vs [position B] vs [position C]. Sound right?" and wait for confirmation

## Team

You MUST use the TeamCreate and SendMessage tools to create a real agent team. Do NOT simulate the debate in your own context.

Create an agent team with 2-3 teammates. Each teammate:
- Argues FOR their assigned position and AGAINST the others
- Is read-only — no file edits, only research and analysis
- Should be given codebase context relevant to the debate (key file paths, patterns, constraints)

Spawn prompt for each teammate should include:
- The full debate topic and context (including Jira details if applicable)
- Their assigned position to argue for
- Instruction to research the codebase for evidence supporting their position
- Instruction to actively challenge other teammates' arguments when messaged
- Instruction to concede points when the evidence is against them

Do NOT require plan approval — the framing confirmation is sufficient. Let agents start researching immediately.

## Moderation

You are the moderator. After teammates complete initial research:

1. **Opening arguments** — have each teammate present their case with evidence from the codebase
2. **Cross-examination** — direct teammates to challenge specific claims from other teammates
3. **Rebuttals** — let teammates respond to challenges
4. **Convergence** — ask teammates if any have changed their position or want to concede points

Limit to 2-3 rounds of back-and-forth. Cut off unproductive tangents.

## Output

After the debate, synthesize a recommendation:

**Topic**
[The question debated]

**Positions Argued**
- [Position A]: [core argument + key evidence]
- [Position B]: [core argument + key evidence]

**Key Disagreements**
- [What they couldn't resolve and why]

**Consensus Points**
- [What all sides agreed on]

**Recommendation**
[Your synthesis — which position won and why, or a hybrid if warranted]

**Open Questions**
- [Anything that needs user input or further investigation]

Present this to the user. Then clean up the team.
