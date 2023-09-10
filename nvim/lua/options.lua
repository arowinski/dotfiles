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
vim.cmd([[colorscheme tokyonight-night]])

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
util.map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
util.map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- set line options
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true

-- don't redraw window on running macros
vim.opt.lazyredraw = true

util.map("n", "<leader>w", ":w<CR>")
util.map("n", "<leader>q", ":q<CR>")
util.map("n", "<C-e>", ":e<CR>")
util.map("n", "<space><space>", "<C-^>")

-- convenience mappings
util.map("n", "H", "^")
util.map("n", "L", "$")
util.map("n", "0", "^")
util.map("n", "^", "0")

util.map("n", "Q", "<NOP>")

-- shell like jump mappings
util.map("i", "<C-e>", "<END>")
util.map("i", "<C-a>", "<C-o>^")
util.map("i", "<C-b>", "<LEFT>")
util.map("i", "<C-f>", "<RIGHT>")

-- quickfix
util.map("n", "]q", ":cnext<CR>")
util.map("n", "[q", ":cprev<CR>")
util.map("n", "]Q", ":clast<CR>")
util.map("n", "[Q", ":cfirst<CR>")

-- copy to system clipboard
util.map("n", "<Leader>y", '"+y')

vim.keymap.set("n", "<M-q>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)

      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
      end
    end
  end
end)

vim.cmd([[
  cnoremap <C-a> <Home>
  cnoremap <C-e> <END>
]])
