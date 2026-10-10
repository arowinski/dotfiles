import { expect, test } from 'claude-code/testing'

const EDIT = 'mcp__atlassian__editJiraIssue'
const COMMENT = 'mcp__atlassian__addCommentToJiraIssue'
const TRANSITIONS = 'mcp__atlassian__getTransitionsForJiraIssue'

const ISSUE_ECHO = JSON.stringify({ key: 'ABC-7', fields: { summary: 'Old', description: 'A long body' } })

test('an edit reads back as the issue key and the fields it set', async ($, on) => {
  on('tool.call', { tool: EDIT }, () => ({ result: ISSUE_ECHO, text: ISSUE_ECHO }))

  const out = await $.tool.call({ tool: EDIT, cloudId: 'site', issueIdOrKey: 'ABC-7', fields: { summary: 'New', labels: ['x'] } })

  expect(out).toEqual({ result: 'Updated ABC-7: summary, labels' })
})

test('a failed edit keeps the server error', async ($, on) => {
  const failed = { result: 'Field labels cannot be set', text: 'Field labels cannot be set', isError: true } as const
  on('tool.call', { tool: EDIT }, () => failed)

  const out = await $.tool.call({ tool: EDIT, cloudId: 'site', issueIdOrKey: 'ABC-7', fields: { labels: ['x'] } })

  expect(out).toEqual(failed)
})

test('a denied edit stays denied', async ($, on) => {
  on('tool.call', { tool: EDIT }, () => ({ deny: 'Confirm: Jira write' }))

  const out = await $.tool.call({ tool: EDIT, cloudId: 'site', issueIdOrKey: 'ABC-7', fields: { summary: 'New' } })

  expect(out).toEqual({ deny: 'Confirm: Jira write' })
})

test('a comment reads back as the issue it landed on', async ($, on) => {
  const echo = JSON.stringify({ id: '10421', body: 'Looks good' })
  on('tool.call', { tool: COMMENT }, () => ({ result: echo, text: echo }))

  const out = await $.tool.call({ tool: COMMENT, cloudId: 'site', issueIdOrKey: 'ABC-9', commentBody: 'Looks good' })

  expect(out).toEqual({ result: 'Commented on ABC-9' })
})

test('transitions read back as one id, name and target status per line', async ($, on) => {
  const json = JSON.stringify({
    expand: 'transitions',
    transitions: [
      { id: '21', name: 'Start', hasScreen: false, to: { name: 'In Progress', iconUrl: 'https://x/icon.png' } },
      { id: '31', name: 'Finish', hasScreen: true, to: { name: 'Done', iconUrl: 'https://x/icon.png' } },
    ],
  })
  on('tool.call', { tool: TRANSITIONS }, () => ({ result: json, text: json }))

  const out = await $.tool.call({ tool: TRANSITIONS, cloudId: 'site', issueIdOrKey: 'ABC-7' })

  expect(out).toEqual({ result: '21: Start → In Progress\n31: Finish → Done' })
})

test('transitions text that is not the transitions JSON passes through', async ($, on) => {
  const answer = { result: 'Issue ABC-404 does not exist', text: 'Issue ABC-404 does not exist' }
  on('tool.call', { tool: TRANSITIONS }, () => answer)

  const out = await $.tool.call({ tool: TRANSITIONS, cloudId: 'site', issueIdOrKey: 'ABC-404' })

  expect(out).toEqual(answer)
})
