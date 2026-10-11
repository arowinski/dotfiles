import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

const WARN_AT = 70
const YELLOW_FROM = 30
const RED_FROM = 60
// Terminals have no named orange, so xhigh's is the 256-color palette's 208.
const EFFORT_COLORS: Record<string, string> = { medium: 'green', high: 'yellow', xhigh: '#ff8700' }

const percent = atom({ plugin: 'context-gauge', key: 'percent' } as const, null)
const effort = atom({ plugin: 'context-gauge', key: 'effort' } as const, null)

// Stores the fill for the footer label and toasts on crossing WARN_AT; returns
// whether the context is past it, so the caller toasts once per crossing.
async function refresh($: EngineInterface, hasWarned: boolean) {
  const usage = await $.session.usage()
  const now = usage.context.percent ?? 0

  await update($, percent, () => now)

  if (now >= WARN_AT && !hasWarned) {
    $.ui.toast(`Context at ${now}% — consider /handover or /compact`)
  }

  return now >= WARN_AT
}

export const register: Register = on => {
  let hasWarned = false

  on('session.start', async ($, e, next) => {
    const result = await next(e)
    hasWarned = await refresh($, hasWarned)

    return result
  })

  on('tool.call', async ($, e, next) => {
    const result = await next(e)
    hasWarned = await refresh($, hasWarned)

    return result
  })

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    hasWarned = await refresh($, hasWarned)

    return result
  })

  on('session.compact', async ($, e, next) => {
    const result = await next(e)
    hasWarned = await refresh($, hasWarned)

    return result
  })

  // No `$` call reads the session's effort; each main-loop model request carries
  // it, so the label shows it from the first request and follows `/effort`.
  on('turn.step', async function* ($, e, next) {
    if (e.agentId === undefined) {
      await update($, effort, () => e.effort ?? null)
    }

    return yield* next(e)
  })

  // Tails the hint line: the footer's right side holds the effort indicator,
  // and a mode label there wraps to a row of its own. The engine's `tail` is
  // always dim, so from YELLOW_FROM, or with an effort that has a color, the
  // hook draws the hint text itself; the engine's pills around it stay its own.
  on('ui.render', { component: 'PromptHint' }, async ($, e, next) => {
    const now = await read($, percent)
    const level = await read($, effort)

    if (now === null) {
      return next(e)
    }

    const levelColor = typeof level === 'string' ? EFFORT_COLORS[level] : undefined

    if (now < YELLOW_FROM && levelColor === undefined) {
      const after = level === null ? '' : ` · ${level}`

      return next({ ...e, props: { ...e.props, tail: `◔ ${now}%${after}` } })
    }

    const { Text } = $.ui.resolve(e)
    const gauge =
      now < YELLOW_FROM ? `◔ ${now}%` : <Text color={now >= RED_FROM ? 'red' : 'yellow'}>{`◔ ${now}%`}</Text>

    if (level === null) {
      return (
        <Text dimColor>
          {`${e.props.hint} · `}
          {gauge}
        </Text>
      )
    }

    return (
      <Text dimColor>
        {`${e.props.hint} · `}
        {gauge}
        {' · '}
        {levelColor === undefined ? `${level}` : <Text color={levelColor}>{`${level}`}</Text>}
      </Text>
    )
  })
}
