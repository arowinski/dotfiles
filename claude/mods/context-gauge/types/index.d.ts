export type Percent = number | null
export type Effort = string | number | null

declare module 'claude-code' {
  interface PluginState {
    'context-gauge': { percent: Percent; effort: Effort }
  }
}
