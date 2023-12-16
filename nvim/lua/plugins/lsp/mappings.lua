local util = require("util")

local M = {}

local bmap = function(mode, keys, action)
  util.map(mode, keys, action, { buffer = true })
end

function M.setup()
  bmap("n", "gD", vim.lsp.buf.definition)
  bmap("n", "gt", vim.lsp.buf.references)
  bmap("n", "<leader>p", vim.lsp.buf.format)

  bmap({ "n", "v" }, "<C-a>", "<CMD>Lspsaga code_action<CR>")
  bmap("n", "gh", "<CMD>Lspsaga finder def+ref<CR>")
  bmap("n", "gd", "<CMD>Lspsaga peek_definition<CR>")
  bmap("n", "K", "<CMD>Lspsaga hover_doc<CR>")
  bmap("n", "gs", vim.lsp.buf.signature_help)

  bmap("n", "[r", vim.diagnostic.goto_prev)
  bmap("n", "]r", vim.diagnostic.goto_next)
  bmap("n", "<leader>d", "<CMD>Lspsaga show_line_diagnostics<CR>")
end

return M
