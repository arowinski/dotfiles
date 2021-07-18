local nvim_lsp = require('lspconfig')
local prettier = require('efm/prettier')
local eslint = require('efm/eslint')

local languages = {
  lua = { require('efm/luafmt') },
  typescript = { prettier, eslint },
  javascript = { prettier, eslint },
  typescriptreact = { prettier, eslint },
  javascriptreact = { prettier, eslint },
  yaml = { prettier },
  json = { prettier },
  html = { prettier },
  scss = { prettier },
  css = { prettier },
  markdown = { prettier }
}

return {
  root_dir = nvim_lsp.util.root_pattern(".git"),
  filetypes = vim.tbl_keys(languages),
  init_options = { documentFormatting = true, codeAction = true },
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
  end,
  settings = { languages = languages }
}

