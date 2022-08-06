local util = require("util")

local M = {}

local bmap = function(keys, action)
  util.nmap(keys, action, { buffer = true })
end

function M.setup()
  bmap("gD", vim.lsp.buf.declaration)
  bmap("gt", vim.lsp.buf.references)
  bmap("<leader>p", vim.lsp.buf.formatting)

  bmap("<C-a>", require("lspsaga.codeaction").code_action)
  bmap("gh", require("lspsaga.finder").lsp_finder)
  bmap("gd", require("lspsaga.definition").preview_definition)
  bmap("gs", require("lspsaga.signaturehelp").signature_help)
  bmap("K", require("lspsaga.hover").render_hover_doc)
  util.inoremap("<C-f>", require("lspsaga.signaturehelp").signature_help)

  bmap("[r", require("lspsaga.diagnostic").goto_prev)
  bmap("]r", require("lspsaga.diagnostic").goto_next)
  bmap("<leader>d", require("lspsaga.diagnostic").show_line_diagnostics)
end

return M
