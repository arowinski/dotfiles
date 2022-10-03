local M = {
  string = require("util.string"),
  dir = require("util.dir"),
  table = require("util.table"),
  spinner = require("util.spinner"),
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

local map = function(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend(
    "force",
    { silent = true },
    defaults or {},
    opts or {}
  )

  return vim.keymap.set(mode, key, cmd, opts)
end

-- TODO: revisit, maybe simplify mapping to always provide mode
function M.nmap(key, cmd, opts)
  return map("n", key, cmd, opts)
end

function M.xmap(key, cmd, opts)
  return map("x", key, cmd, opts)
end

function M.vmap(key, cmd, opts)
  return map("x", key, cmd, opts)
end

function M.imap(key, cmd, opts)
  return map("i", key, cmd, opts)
end

function M.nnoremap(key, cmd, opts)
  return map("n", key, cmd, opts, { noremap = true })
end

function M.inoremap(key, cmd, opts)
  return map("i", key, cmd, opts, { noremap = true })
end

function M.noremap(mode, key, cmd, opts)
  return map(mode, key, cmd, opts, { noremap = true })
end

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feed_keys(key, mode)
  vim.api.nvim_feedkeys(M.t(key), mode, true)
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

return M
