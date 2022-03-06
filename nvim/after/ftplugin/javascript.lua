local nnoremap = require("util").nnoremap

nnoremap("<leader>bp", "odebugger<ESC>", { buffer = true })
nnoremap("<leader>br", ":g/debugger/d<CR>", { buffer = true })
