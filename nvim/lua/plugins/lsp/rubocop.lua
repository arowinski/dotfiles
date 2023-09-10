require("lspconfig.configs").rubocop = {
  default_config = {
    cmd = { "rubocop", "--lsp" },
    filetypes = { "ruby" },
    root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git"),
    -- init_options = {
    --   enabledFeatures = {
    --     "diagnostics",
    --     "formatting",
    --     "codeaction"
    --   },
    -- },
  },
}

return {
  setup = function(lsp, _)
    lsp.rubocop.setup({})
  end,
}
