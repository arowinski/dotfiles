local nvim_lsp = require('lspconfig')
local prettier = require('efm.prettier')
local eslint = require('efm.eslint')
local stylelint = require('efm.stylelint')

local languages = {
  lua = { require('efm/luafmt') },
  typescript = { prettier, eslint },
  javascript = { prettier, eslint },
  typescriptreact = { stylelint, prettier, eslint },
  javascriptreact = { stylelint, prettier, eslint },
  yaml = { prettier },
  json = { prettier },
  html = { stylelint, prettier },
  scss = { stylelint, prettier },
  css = { stylelint, prettier },
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
