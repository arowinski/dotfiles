local nvim_lsp = require('lspconfig')
local efm_config = require('efm/config')

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

local on_attach = function(_, _)
  local function buf_map(lhs, rhs)
    U.buf_nmap(lhs, '<cmd>lua  ' .. rhs .. '<CR>')
  end

  require'lsp_signature'.on_attach({ use_lspsaga = true })

  buf_map('gD', 'vim.lsp.buf.declaration()')
  buf_map('gd', 'vim.lsp.buf.definition()')
  buf_map('gt', 'vim.lsp.buf.references()')

  buf_map('K', "require'lspsaga.hover'.render_hover_doc()")
  buf_map('gh', "require'lspsaga.provider'.preview_definition()")
  buf_map('gs', "require('lspsaga.signaturehelp').signature_help()")
  buf_map('<Leader>d', "require'lspsaga.diagnostic'.show_line_diagnostics()")
  buf_map('<C-u>', "require('lspsaga.action').smart_scroll_with_saga(1)")
  buf_map('<C-d>', "require('lspsaga.action').smart_scroll_with_saga(-1)")
end

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
