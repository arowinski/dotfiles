local on_attach = function(_, _)
  require("plugins.lsp.mappings").setup()
end

local capabilities = require("blink.cmp").get_lsp_capabilities()

return {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = { debounce_text_changes = 150 },
}
