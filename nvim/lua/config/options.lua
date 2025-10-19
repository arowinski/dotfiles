-- set line options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true

-- disable swapfiles and backup
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Put new windows below or right
vim.opt.splitbelow = true
vim.opt.splitright = true

--Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Don't wrap long lines
vim.opt.wrap = false

-- Confirm possibly destructive actions
vim.opt.confirm = true

-- Always show sign column
vim.opt.signcolumn = "yes"

-- Decrease update time for CursorHold
vim.opt.updatetime = 250

--Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

--Set indentation to 2 spaces always
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

--Set highlight on search
vim.opt.hlsearch = false
