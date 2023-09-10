-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

-- auto-resize panes
vim.cmd([[ autocmd VimResized * :wincmd = ]])

-- create directories on file save
vim.cmd([[ autocmd BufWritePre * lua require("util.dir").create_on_save() ]])
