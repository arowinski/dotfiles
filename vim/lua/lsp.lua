local nvim_lsp = require('lspconfig')
local efm_config = require('efm.config')
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
  css = {},
  vim = {}
}

local merge = U.dict.merge
local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local config = lsp[server] and lsp[server] or {};

    require'lspconfig'[server].setup(merge({ on_attach = on_attach }, config))
  end
end

setup_servers()

require'lspinstall'.post_install_hook = function()
  setup_servers()

  vim.cmd("bufdo e")
end

-- Ruby

nvim_lsp.solargraph.setup {
  root_dir = nvim_lsp.util.root_pattern(".git"),
  cmd = { "solargraph", "stdio" },
  settings = { solargraph = { useBundler = true } },
  filetypes = { "ruby" },
  flags = { debounce_text_changes = 150 },
  on_attach = on_attach
}

-- Typescript

nvim_lsp.tsserver.setup {
  root_dir = nvim_lsp.util.root_pattern(".git", "yarn.lock"),
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach(client, bufnr)
  end,
  settings = { documentFormatting = false }
}
