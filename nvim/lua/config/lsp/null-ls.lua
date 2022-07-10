local M = {}

function M.setup(options)
  local nls = require("null-ls")

  nls.setup({
    sources = {
      nls.builtins.formatting.prettierd,
      nls.builtins.formatting.stylelint,
      nls.builtins.diagnostics.write_good.with({
				filetypes = { "gitcommit" }
			}),
      -- nls.builtins.code_actions.gitsigns,
      nls.builtins.diagnostics.yamllint,
    },
    on_attach = options.on_attach,
  })
end

return M
