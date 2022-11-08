local util = require("util")

local M = {}

local bmap = function(mode, keys, action)
  util.noremap(mode, keys, action, { buffer = true })
end

function M.setup()
  bmap("n", "gD", vim.lsp.buf.definition)
  bmap("n", "gt", vim.lsp.buf.references)
  bmap("n", "<leader>p", vim.lsp.buf.format)

  bmap({ "n", "v" }, "<C-a>", "<CMD>Lspsaga code_action<CR>")
  bmap("n", "gh", "<CMD>Lspsaga lsp_finder<CR>")
  bmap("n", "gd", "<CMD>Lspsaga peek_definition<CR>")
  bmap("n", "gs", "<CMD>Lspsaga signature_help<CR>")
  bmap("n", "K", "<CMD>Lspsaga hover_doc<CR>")
  bmap("i", "<C-s>", "<CMD>Lspsaga signature_help<CR>")

  bmap("n", "[r", "<CMD>Lspsaga diagnostic_jump_prev<CR>")
  bmap("n", "]r", "<CMD>Lspsaga diagnostic_jump_next<CR>")
  bmap("n", "<leader>d", "<CMD>Lspsaga show_line_diagnostics<CR>")
end

return M
