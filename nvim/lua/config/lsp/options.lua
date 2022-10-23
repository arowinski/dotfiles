local on_attach = function(_, _)
  require("config.lsp.mappings").setup()
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = { debounce_text_changes = 150 },
}
