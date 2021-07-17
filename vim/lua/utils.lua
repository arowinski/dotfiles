local utils = {}

function utils.reduce(list, acc, fn)
  for k, v in ipairs(list) do acc = fn(acc, v, k) end

  return acc
end

function utils.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function utils.nmap(k, f)
  return vim.api.nvim_set_keymap('n', k, f, {noremap = true, silent = true})
end

return utils;
