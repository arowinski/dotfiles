local t = require('utils').t

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 2;
  allow_prefix_unmatch = false,
  preselect = 'disable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  min_length = 1,
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
    treesitter = true;
    vsnip = { priority = 9999 };
  };
}

_G.tab_complete = function()
  if vim.fn.pumvisible() and vim.fn['compe#_has_completed_item']() then
    return vim.fn['compe#confirm']()
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif vim.fn.pumvisible() and not vim.fn['compe#_has_completed_item']() then
    return vim.fn['compe#confirm']({select = true})
  else
    return vim.fn['compe#complete']()
  end
end

_G.next_completion = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#jumpable'](1) == 1 then
    return t "<Plug>(vsnip-jump-next)"
  else
    return ''
  end
end

_G.prev_completion = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return ''
  end
end

vim.api.nvim_set_keymap('i', "<C-j>", "v:lua.next_completion()", {expr = true})
vim.api.nvim_set_keymap('i', "<C-k>", "v:lua.prev_completion()", {expr = true})
vim.api.nvim_set_keymap('i', "<C-l>", "v:lua.tab_complete()", {expr = true})
