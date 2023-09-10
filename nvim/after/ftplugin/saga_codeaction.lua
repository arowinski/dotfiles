local map = require("util").map

map("n", "<C-h>", "<NOP>", { buffer = true })
map("n", "<C-j>", "<NOP>", { buffer = true })
map("n", "<C-k>", "<NOP>", { buffer = true })
map("n", "<C-l>", "<NOP>", { buffer = true })

local augroup = vim.api.nvim_create_augroup("AU_LSPSAGA", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
  group = augroup,
  buffer = 0,
  callback = function()
    require("lspsaga.codeaction"):close_action_window()
    return true --- Delete autocmd
  end
})
