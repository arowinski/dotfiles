local map = require("util").map

map("n", "<leader>bp", "odebugger<ESC>", { buffer = true })
map("n", "<leader>br", ":g/debugger/d<CR>", { buffer = true })
