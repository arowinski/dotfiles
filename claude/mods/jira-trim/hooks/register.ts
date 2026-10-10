import type { Register, ToolCallResult } from 'claude-code'

const EDIT = 'mcp__atlassian__editJiraIssue'
const COMMENT = 'mcp__atlassian__addCommentToJiraIssue'
const TRANSITIONS = 'mcp__atlassian__getTransitionsForJiraIssue'

type Transition = { id: string; name: string; to: { name: string } }

// A denied or failed call keeps the server's answer: its error text is what
// the model needs to recover.
const landed = (out: ToolCallResult) => out.deny === undefined && !out.isError

// One `id: name → status` line per transition; null when the text isn't the
// transitions JSON, so the caller keeps the server's answer.
function transitionLines(text: string) {
  try {
    const { transitions } = JSON.parse(text) as { transitions: Transition[] }

    return transitions.map(t => `${t.id}: ${t.name} → ${t.to.name}`).join('\n')
  } catch {
    return null
  }
}

export const register: Register = on => {
  // The server echoes the whole issue after an edit (~1.3k tokens) and the
  // whole comment after a comment (~1k); the model only needs to know it landed.
  on('tool.call', { tool: EDIT }, async ($, e, next) => {
    const out = await next(e)

    return landed(out) ? { result: `Updated ${e.issueIdOrKey}: ${Object.keys(e.fields as object).join(', ')}` } : out
  })

  on('tool.call', { tool: COMMENT }, async ($, e, next) => {
    const out = await next(e)

    return landed(out) ? { result: `Commented on ${e.issueIdOrKey}` } : out
  })

  // The transitions JSON runs ~2.4k tokens, mostly icon URLs and status
  // categories; transitionJiraIssue needs only the id.
  on('tool.call', { tool: TRANSITIONS }, async ($, e, next) => {
    const out = await next(e)
    const lines = landed(out) && out.text !== undefined ? transitionLines(out.text) : null

    return lines ? { result: lines } : out
  })
}
