local util = require("util")

vim.o.confirm = true

--Set highlight on search
vim.o.hlsearch = false

--Enable mouse mode
vim.o.mouse = "a"

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

--Set colorscheme
vim.o.termguicolors = true
vim.g.tokyonight_style = "night"
vim.cmd([[colorscheme tokyonight]])

-- Put new windows below or right
vim.opt.splitbelow = true
vim.opt.splitright = true

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable swapfiles and backup
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

--Set indentation to 2 spaces always
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

vim.opt.wrap = false

vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10

--Remap for dealing with word wrap
util.nnoremap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
util.nnoremap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

-- set line options
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true

-- highlight columns above 80
vim.cmd([[
  highlight ColorColumn ctermbg=236 guibg=#212121
  let &colorcolumn=join(range(81,500),",")
]])

-- toggle columns highlight on focus
vim.cmd([[
  augroup BgHighlight
    autocmd!
    autocmd WinEnter * let &colorcolumn=join(range(81,999),",")
    autocmd WinLeave * set colorcolumn=0
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
  augroup END
]])

-- don't redraw window on running macros
vim.opt.lazyredraw = true

-- auto-resize panes
vim.cmd([[ autocmd VimResized * :wincmd = ]])

util.nnoremap("<leader>w", ":w<CR>")
util.nnoremap("<leader>q", ":q<CR>")
util.nnoremap("<C-c>", ":Bdelete<CR>")
util.nnoremap("<C-e>", ":e<CR>")
util.nnoremap("<space><space>", "<C-^>")

-- convenience mappings
util.nnoremap("H", "^")
util.nnoremap("L", "$")
util.nnoremap("0", "^")
util.nnoremap("^", "0")

util.nnoremap("Q", "<NOP>")

-- shell like jump mappings
util.inoremap("<C-e>", "<END>")
util.inoremap("<C-a>", "<C-o>^")
util.inoremap("<C-b>", "<LEFT>")
util.inoremap("<C-f>", "<RIGHT>")

-- quickfix
util.nmap("]q", ":cnext<CR>")
util.nmap("[q", ":cprev<CR>")
util.nmap("]Q", ":clast<CR>")
util.nmap("[Q", ":cfirst<CR>")

vim.cmd([[
  cnoremap <C-a> <Home>
  cnoremap <C-e> <END>
]])

-- go to last loc when opening a buffer
vim.cmd([[
  autocmd BufReadPost * if &ft =~ 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- create directories on file save
vim.cmd([[ autocmd BufWritePre * lua require("util.dir").create_on_save() ]])
