local lsp = require("lspconfig")
local options = require("plugins.lsp.options")

require("plugins.lsp.lua-ls").setup(lsp, options)
require("plugins.lsp.typescript").setup(lsp, options)

local function setup(server, extension)
  lsp[server].setup(vim.tbl_extend("force", options, extension or {}))
end

setup(
  "jsonls",
  { settings = { json = { schemas = require("schemastore").json.schemas() } } }
)
setup("tailwindcss")
setup("html")
setup("yamlls")
setup("rubocop")
setup("eslint")
setup("elixirls")
setup("solargraph")
setup("typos_lsp")
