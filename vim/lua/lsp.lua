local nvim_lsp = require('lspconfig')
local efm_config = require('efm.config')
local make_config = require('lsp.make_config')
local on_attach = require('lsp.on_attach')

U.nmap('<leader>p', "<cmd>lua vim.lsp.buf.formatting()<CR>")

local lsp = {
  efm = efm_config,
  lua = {
    settings = {
      Lua = {
        diagnostics = { enable = true, globals = { "vim", "U", "MPairs" } }
      }
    }
  },
  json = {},
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
  tsserver = {
    root_dir = nvim_lsp.util.root_pattern(".git", "yarn.lock"),
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      on_attach(client, bufnr)
    end,
    settings = { documentFormatting = false }
  }
}

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()

  table.insert(servers, "tsserver")
  table.insert(servers, "solargraph")

  for _, server in pairs(servers) do
    local config = lsp[server] and lsp[server] or {};

    require'lspconfig'[server].setup(make_config(config))
  end
end

setup_servers()

require'lspinstall'.post_install_hook = function()
  setup_servers()

  vim.cmd("bufdo e")
end
