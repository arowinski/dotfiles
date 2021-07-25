local on_attach = require('lsp.on_attach')
local merge = U.dict.merge

return function(config)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return merge({ capabilities = capabilities, on_attach = on_attach }, config)
end
