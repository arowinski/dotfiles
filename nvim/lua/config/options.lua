-- set line options
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true

-- disable swapfiles and backup
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

-- Put new windows below or right
vim.opt.splitbelow = true
vim.opt.splitright = true

--Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Don't wrap long lines
vim.opt.wrap = false

-- Confirm possibly destructive actions
vim.o.confirm = true

-- Always show sign column
vim.wo.signcolumn = "yes"

-- Decrease update time for CursorHold
vim.o.updatetime = 250

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
