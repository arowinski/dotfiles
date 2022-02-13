-- TODO: replace with lua

vim.cmd("source " .. vim.fn.expand("~/.config/nvim/lua/config/projections.vim"))

vim.cmd([[
  autocmd User ProjectionistDetect :call projections#set_projections(&filetype)
	command! ROV silent only|RV
	command! AOV silent only|AV
]])

local nnoremap = require("util").nnoremap

nnoremap("<Leader>av", ":AOV<cr>")
nnoremap("<Leader>rv", ":ROV<cr>")
