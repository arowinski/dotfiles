local nvim_lsp = require("lspconfig")
local make_config = require("lsp.make_config")
local on_attach = require("lsp.on_attach")
local ts_utils_attach = require("lsp.ts_utils")

U.nmap("<leader>p", "<cmd>lua vim.lsp.buf.formatting()<CR>")

local lsp_config = {
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = { enable = true, globals = { "vim", "U", "MPairs" } },
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
  solargraph = {
    root_dir = nvim_lsp.util.root_pattern(".git"),
    cmd = { "solargraph", "stdio" },
    settings = { solargraph = { useBundler = true } },
    filetypes = { "ruby" },
    flags = { debounce_text_changes = 150 },
  },
  tailwindcss = {},
  tsserver = {
    root_dir = nvim_lsp.util.root_pattern(".git", "yarn.lock"),
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      ts_utils_attach(client)
      on_attach(client, bufnr)
    end,
    settings = { documentFormatting = false },
  },
}

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local config = lsp_config[server.name] and lsp_config[server.name]

  server:setup(make_config(config))
end)

require("lspconfig").solargraph.setup(make_config(lsp_config.solargraph))

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylelint,
    null_ls.builtins.diagnostics.stylelint,
    null_ls.builtins.formatting.stylua.with({
      extra_args = {
        "--indent-type=Spaces",
        "--indent-width=2",
        "--column-width=80",
      },
    }),
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.yamllint,
  },
  on_attach = on_attach,
})

LspInstallDefined = function()
  local exclude = { "solargraph" }
  local required = vim.tbl_filter(function(element)
    return not vim.tbl_contains(exclude, element)
  end, vim.tbl_keys(lsp_config))
  local installed = vim.tbl_map(function(v)
    return v.name
  end, lsp_installer.get_installed_servers())

  for _, server in pairs(required) do
    if not vim.tbl_contains(installed, server) then
      lsp_installer.install(server)
    end
  end
end
