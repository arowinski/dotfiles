local util = require("util")

local M = {}

local bmap = function(keys, action)
  util.nmap(keys, action, { buffer = true })
end

function M.setup()
  bmap("gD", vim.lsp.buf.declaration)
  bmap("gt", vim.lsp.buf.references)
  bmap("<leader>p", vim.lsp.buf.formatting)

  bmap("<C-a>", "<CMD>Lspsaga code_action<CR>")
  bmap("gh", "<CMD>Lspsaga lsp_finder<CR>")
  bmap("gd", "<CMD>Lspsaga peek_definition<CR>")
  bmap("gs", "<CMD>Lspsaga signature_help<CR>")
  bmap("K", "<CMD>Lspsaga hover_doc<CR>")
  util.inoremap("<C-s>", "<CMD>Lspsaga signature_help<CR>")

  bmap("[r", "<CMD>Lspsaga diagnostic_jump_prev<CR>")
  bmap("]r", "<CMD>Lspsaga diagnostic_jump_next<CR>")
  bmap("<leader>d", "<CMD>Lspsaga show_line_diagnostics<CR>")
end

return M
