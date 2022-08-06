local on_attach = function(client, _)
  require("config.lsp.mappings").setup()
  require("config.lsp.highlight").setup(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

return {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = { debounce_text_changes = 150 },
}
