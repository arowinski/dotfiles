U = { list = {}, dict = {} }

local function map_keys(mode, command, value, opts)
  opts = opts or { noremap = true, silent = true }

  vim.api.nvim_set_keymap(mode, command, value, opts)
end

function U.nmap(command, value, opts) map_keys('n', command, value, opts) end
function U.imap(command, value, opts) map_keys('i', command, value, opts) end

function U.buf_nmap(command, value, opts) map_keys('n', command, value, opts) end
function U.buf_vmap(command, value, opts) map_keys('v', command, value, opts) end

function U.list.reduce(list, acc, fn)
  for k, v in ipairs(list) do acc = fn(acc, v, k) end

  return acc
end

function U.dict.merge(target, source)
  for k, v in pairs(source) do target[k] = v end

  return target;
end
