local indicators = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}

return function()
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #indicators

  return indicators[frame + 1]
end
