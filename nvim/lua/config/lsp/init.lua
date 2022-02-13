local util = require("util")
local lsp = require("lspconfig")

require("config.lsp.diagnostics").setup()

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lsp_config = {
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = { enable = true, globals = { "vim" } },
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  jsonls = {
    settings = { json = { schemas = require("schemastore").json.schemas() } },
  },
  yamlls = {},
  html = { filetypes = { "html" } },
  vimls = {},
  svelte = {},
  tailwindcss = { root_dir = lsp.util.root_pattern("tailwind.config.js") },
  tsserver = {},
}

local on_attach = function(client, _)
  require("config.lsp.mappings").setup()
  require("config.lsp.highlight").setup(client)

  if client.name == "typescript" or client.name == "tsserver" then
    require("config.lsp.ts-utils").setup(client)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = { debounce_text_changes = 150 },
}

local installer = require("config.lsp.install")
local servers = util.table.merge(vim.tbl_keys(lsp_config), { "eslint" })

installer.ensure(servers)
installer.setup(lsp_config, options)

require("config.lsp.null-ls").setup(options)
require("config.lsp.solargraph").setup(lsp, options)
require("config.lsp.eslint").setup(lsp, options)
