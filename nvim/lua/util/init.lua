local M = {
  string = require("util.string"),
  dir = require("util.dir"),
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

function M.get_selection()
  return vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { mode = vim.fn.mode() })
end

function M.map(mode, key, cmd, opts)
  local lopts = vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts or {})

  return vim.keymap.set(mode, key, cmd, lopts)
end

return M
