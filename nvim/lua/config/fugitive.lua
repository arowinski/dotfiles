local nnoremap = require("util").nnoremap

nnoremap("g<space>", ":G<CR>")
nnoremap("<leader>gl", ":0Gclog -n1000<CR>")
nnoremap("<leader>gl", ":0Gclog<CR>")

vim.cmd([[
  autocmd Filetype gitcommit setlocal spell textwidth=72
  autocmd BufReadPost fugitive://* set bufhidden=delete
	autocmd Filetype fugitive nmap <buffer> czu 1czw
]])
