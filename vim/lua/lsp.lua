local nvim_lsp = require('lspconfig')
local efm_config = require('efm.config')
local make_config = require('lsp.make_config')
local on_attach = require('lsp.on_attach')
local ts_utils_attach = require('lsp.ts_utils')

U.nmap('<leader>p', "<cmd>lua vim.lsp.buf.formatting()<CR>")

local lsp_config = {
  efm = efm_config,
  lua = {
    settings = {
      Lua = {
        diagnostics = { enable = true, globals = { "vim", "U", "MPairs" } }
      }
    }
  },
  json = { settings = { json = { schemas = require('lsp.json_schemas') } } },
  yaml = {},
  html = {},
  vim = {},
  solargraph = {
    root_dir = nvim_lsp.util.root_pattern(".git"),
    cmd = { "solargraph", "stdio" },
    settings = { solargraph = { useBundler = true } },
    filetypes = { "ruby" },
    flags = { debounce_text_changes = 150 }
  },
  typescript = {
    root_dir = nvim_lsp.util.root_pattern(".git", "yarn.lock"),
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      ts_utils_attach(client)
      on_attach(client, bufnr)
    end,
    settings = { documentFormatting = false }
  }
}

local required_lsp_servers = {
  'efm', 'lua', 'json', 'yaml', 'html', 'vim', 'typescript'
}

local function setup_servers()
  require'lspinstall'.setup()

  local servers = require'lspinstall'.installed_servers()

  for _, server in pairs(required_lsp_servers) do
    if not vim.tbl_contains(servers, server) then
      require'lspinstall'.install_server(server)
    end
  end

  table.insert(servers, "solargraph")

  for _, server in pairs(servers) do
    local config = lsp_config[server] and lsp_config[server] or {};

    require'lspconfig'[server].setup(make_config(config))
  end
end

setup_servers()

require'lspinstall'.post_install_hook = function()
  setup_servers()

  vim.cmd("bufdo e")
end
