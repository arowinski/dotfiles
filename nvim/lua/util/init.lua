local M = {
  string = require("util.string"),
  dir = require("util.dir"),
  table = require("util.table"),
  selection = require("util.selection")
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

function M.warn(msg, name)
  vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.error(msg, name)
  vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
  vim.notify(msg, vim.log.levels.INFO, { title = name })
end

local lmap = function(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend(
    "force",
    { silent = true },
    defaults or {},
    opts or {}
  )

  return vim.keymap.set(mode, key, cmd, opts)
end

M.map = function(mode, key, cmd, opts)
  return lmap(mode, key, cmd, opts, { noremap = true })
end

return M
