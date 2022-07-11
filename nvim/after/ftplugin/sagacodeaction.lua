local util = require("util")
util.nmap("<C-h>", "<NOP>", { buffer = true })
util.nmap("<C-j>", "<NOP>", { buffer = true })
util.nmap("<C-k>", "<NOP>", { buffer = true })
util.nmap("<C-l>", "<NOP>", { buffer = true })

local augroup = vim.api.nvim_create_augroup("AU_LSPSAGA", { clear = true })

vim.api.nvim_create_autocmd("BufLeave", {
  group = augroup,
  buffer = 0,
  callback = function()
    require("lspsaga.codeaction"):quit_action_window()
    return true --- Delete autocmd
  end
})
