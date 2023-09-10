local M = {}

function M.setup()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { focusable = false }
  )
end

return M
