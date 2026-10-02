export type Percent = number | null

declare module 'claude-code' {
  interface PluginState {
    'context-gauge': { percent: Percent }
  }
}
