local nvim_lsp = require('lspconfig')
local efm_config = require('efm/config')

-- LSP  Settings

U.nmap('<leader>p', "<cmd>lua vim.lsp.buf.formatting()<CR>")

local lsp = {
  efm = efm_config,
  lua = {
    settings = { Lua = { diagnostics = { enable = true, globals = { "vim" } } } }
  },
  json = {}
}

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup(lsp[server] and lsp[server] or {})
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
  flags = { debounce_text_changes = 150 }
}

-- Typescript

nvim_lsp.tsserver.setup {
  root_dir = nvim_lsp.util.root_pattern(".git"),
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
  end,
  settings = { documentFormatting = false }
}
