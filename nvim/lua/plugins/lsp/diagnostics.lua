local M = {}

M.signs = { Error = "✗ ", Warn = " ", Hint = " ", Info = " " }

function M.setup()
  for type, icon in pairs(M.signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = false,
    float = { source = "if_many", border = "rounded" },
    severity_sort = true,
    show_diagnostic_autocmds = { "InsertLeave", "TextChanged" },
  })
end

return M
