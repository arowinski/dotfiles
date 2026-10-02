import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

const WARN_AT = 70
const YELLOW_FROM = 30
const RED_FROM = 60

const percent = atom({ plugin: 'context-gauge', key: 'percent' } as const, null)

// Stores the fill for the footer label and toasts on crossing WARN_AT;
// returns whether the context is past it, so the caller toasts once per crossing.
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

  // Tails the hint line: the footer's right side holds the effort indicator,
  // and a mode label there wraps to a row of its own. The engine's `tail` is
  // always dim, so from YELLOW_FROM the hook draws the hint text itself
  // with a colored gauge; the engine's pills around it stay its own.
  on('ui.render', { component: 'PromptHint' }, async ($, e, next) => {
    const now = await read($, percent)

    if (now === null) {
      return next(e)
    }
    if (now < YELLOW_FROM) {
      return next({ ...e, props: { ...e.props, tail: `◔ ${now}%` } })
    }

    const { Text } = $.ui.resolve(e)

    return (
      <Text dimColor>
        {`${e.props.hint} · `}
        <Text color={now >= RED_FROM ? 'red' : 'yellow'}>{`◔ ${now}%`}</Text>
      </Text>
    )
  })
}
