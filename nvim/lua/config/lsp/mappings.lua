local util = require("util")

local M = {}

local bmap = function(keys, action)
  util.nmap(keys, action, { buffer = true })
end

function M.setup(_)
  bmap("gD", vim.lsp.buf.declaration)
  bmap("gd", vim.lsp.buf.definition)
  bmap("gt", vim.lsp.buf.references)
  bmap("<C-a>", vim.lsp.buf.code_action)
  bmap("<leader>p", vim.lsp.buf.formatting)
  util.inoremap("<C-f>", vim.lsp.buf.signature_help)
end

return M
