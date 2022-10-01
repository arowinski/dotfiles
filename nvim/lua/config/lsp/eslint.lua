local M = {}

function M.setup(lsp, options)
  lsp.eslint.setup(vim.tbl_extend("force", options, {
    root_dir = lsp.util.root_pattern(".eslintrc", ".eslintrc.js"),
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = true
      options.on_attach(client, bufnr)
    end,
    settings = { format = { enable = true } },
  }))
end

return M
