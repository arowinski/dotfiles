local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local ex = function(str) vim.api.nvim_feedkeys(t(str), 'i', true) end

local cmp = require "cmp"

_G.tab_complete = function()
  if cmp.visible({ select = true }) then
    cmp.confirm()
  elseif vim.fn['vsnip#available'](1) == 1 then
    ex("<Plug>(vsnip-expand-or-jump)")
  else
    cmp.complete()
  end

  return ''
end

_G.next_completion = function()
  if vim.fn['vsnip#jumpable'](1) == 1 then
    ex("<Plug>(vsnip-jump-next)")
  else
    return t("<C-j>")
  end

  return ''
end

_G.prev_completion = function()
  if vim.fn['vsnip#jumpable'](-1) == 1 then
    ex("<Plug>(vsnip-jump-prev)")
  else
    return t("<C-k>")
  end

  return ''
end

U.imap("<C-j>", "v:lua.next_completion()", { expr = true })
U.imap("<C-k>", "v:lua.prev_completion()", { expr = true })
U.imap("<C-l>", "v:lua.tab_complete()", { expr = true })

U.vmap("<C-j>", "v:lua.next_completion()", { expr = true })
U.vmap("<C-k>", "v:lua.prev_completion()", { expr = true })
U.vmap("<C-l>", 'v:lua.tab_complete()', { expr = true })
