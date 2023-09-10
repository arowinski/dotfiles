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

-- set line options
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true

-- don't redraw window on running macros
vim.opt.lazyredraw = true
