local M = {}

function M.setup(_, options)
  local nls = require("null-ls")

  nls.setup({
    sources = {
      nls.builtins.formatting.prettierd,
      nls.builtins.formatting.stylelint,
      nls.builtins.diagnostics.write_good.with({
        filetypes = { "gitcommit" },
      }),
      nls.builtins.formatting.stylua.with({
        extra_args = {
          "--indent-type=Spaces",
          "--indent-width=2",
          "--column-width=80",
        },
      }),
      nls.builtins.diagnostics.yamllint,
      nls.builtins.formatting.shfmt,
      nls.builtins.diagnostics.vale
    },
    on_attach = options.on_attach,
  })
end

return M
