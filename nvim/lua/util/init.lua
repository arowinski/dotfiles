local M = {
  string = require("util.string"),
  table = require("util.table"),
}

function _G.put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

function M.map(mode, key, cmd, opts)
  local lopts = vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts or {})

  return vim.keymap.set(mode, key, cmd, lopts)
end

function M.is_visual_mode(m)
  return type(m) == "string" and string.upper(m) == "V"
    or string.upper(m) == "CTRL-V"
    or string.upper(m) == "<C-V>"
    or m == "\22"
end

return M
