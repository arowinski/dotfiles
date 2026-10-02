import { expect, test } from 'claude-code/testing'
import type { Engine, On, SessionUsage } from 'claude-code/testing'

const usageAt = (percent: number): SessionUsage => ({
  startedAt: 0,
  context: { tokens: percent * 2000, window: 200_000, percent },
  rateLimits: [{ kind: 'five_hour', percentUsed: 23.5 }],
})

const ENGINE_LINE = { type: 'Text', props: {}, children: ['auto mode on'] } as const

const harness = (on: On) => {
  const seen = { percent: 10, tail: undefined as string | undefined, toasts: [] as string[] }
  on('session.start', ($, e) => ({ cwd: e.cwd }))
  on('session.usage', () => ({ value: usageAt(seen.percent) }))
  on('ui.toast', ($, e) => {
    seen.toasts.push(e.text)
  })
  on('ui.render', { component: 'PromptHint' }, ($, e) => {
    seen.tail = e.props.tail

    return ENGINE_LINE
  })

  return seen
}

const start = ($: Engine) => $.session.start({ cwd: '/tmp', surface: 'terminal', isInteractive: true })

const drawHint = ($: Engine) =>
  $.ui.render({
    surface: 'terminal',
    component: 'PromptHint',
    requestId: 'hint',
    props: { isDraft: false, isWorking: false, hint: 'auto mode on' },
  })

test('tails the hint line with the context fill, keeping the engine line', async ($, on) => {
  const seen = harness(on)

  await start($)
  const drawn = await drawHint($)

  expect(seen.tail).toEqual('◔ 10%')
  expect(drawn).toEqual(ENGINE_LINE)
})

test('just under 30% stays dim on the engine tail', async ($, on) => {
  const seen = harness(on)

  seen.percent = 29
  await start($)
  const drawn = await drawHint($)

  expect(seen.tail).toEqual('◔ 29%')
  expect(drawn).toEqual(ENGINE_LINE)
})

for (const [percent, color] of [
  [30, 'yellow'],
  [59, 'yellow'],
  [60, 'red'],
] as const) {
  test(`at ${percent}% draws the hint itself with the gauge in ${color}`, async ($, on) => {
    const seen = harness(on)

    seen.percent = percent
    await start($)
    const drawn = await drawHint($)

    expect(seen.tail).toBeUndefined()
    expect(drawn).toEqual(
      expect.objectContaining({
        type: 'Text',
        props: { dimColor: true },
        children: ['auto mode on · ', expect.objectContaining({ type: 'Text', props: { color }, children: [`◔ ${percent}%`] })],
      }),
    )
  })
}

test('leaves the hint line alone before the first reading', async ($, on) => {
  const seen = harness(on)

  const drawn = await drawHint($)

  expect(seen.tail).toBeUndefined()
  expect(drawn).toEqual(ENGINE_LINE)
})

test('toasts once when context crosses 70%, again after dropping below', async ($, on) => {
  const seen = harness(on)

  seen.percent = 72
  await start($)
  seen.percent = 80
  await start($)
  seen.percent = 30
  await start($)
  seen.percent = 75
  await start($)

  expect(seen.toasts).toEqual([
    'Context at 72% — consider /handover or /compact',
    'Context at 75% — consider /handover or /compact',
  ])
})
