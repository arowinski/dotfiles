local util = require("util")

local M = {}

local bmap = function(mode, keys, action)
  util.map(mode, keys, action, { buffer = true })
end

function M.setup()
  bmap("n", "gD", vim.lsp.buf.definition)
  bmap("n", "gt", vim.lsp.buf.references)

  bmap({ "n", "v" }, "<C-a>", "<CMD>Lspsaga code_action<CR>")
  bmap("n", "gh", "<CMD>Lspsaga finder def+ref<CR>")
  bmap("n", "gd", "<CMD>Lspsaga peek_definition<CR>")
  bmap("n", "K", "<CMD>Lspsaga hover_doc<CR>")
  bmap("n", "gs", vim.lsp.buf.signature_help)

  bmap("n", "[r", "<CMD>Lspsaga diagnostic_jump_prev<CR>")
  bmap("n", "]r", "<CMD>Lspsaga diagnostic_jump_next<CR>")
  bmap("n", "<leader>d", "<CMD>Lspsaga show_line_diagnostics<CR>")
end

return M
