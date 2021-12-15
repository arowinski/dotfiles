U = { list = {}, dict = {} }

local default_map_opts = { noremap = true, silent = true }

local function map_key(mode, command, value, opts)
  vim.api.nvim_set_keymap(mode, command, value, opts or default_map_opts)
end

local function buf_map_key(mode, command, value, opts)
  vim.api.nvim_buf_set_keymap(0, mode, command, value, opts or default_map_opts)
end

function U.nmap(command, value, opts)
  map_key("n", command, value, opts)
end

function U.imap(command, value, opts)
  map_key("i", command, value, opts)
end

function U.vmap(command, value, opts)
  map_key("v", command, value, opts)
end

function U.buf_nmap(command, value, opts)
  buf_map_key("n", command, value, opts)
end

function U.buf_vmap(command, value, opts)
  buf_map_key("v", command, value, opts)
end

function U.list.reduce(list, acc, fn)
  for k, v in ipairs(list) do
    acc = fn(acc, v, k)
  end

  return acc
end

function U.dict.merge(target, source)
  for k, v in pairs(source) do
    target[k] = v
  end

  return target
end

function U.feed_key(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode,
    true
  )
end
