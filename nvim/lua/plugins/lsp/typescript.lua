local M = {}

function M.setup(_, options)
  require("typescript-tools").setup({
    on_attach = options.on_attach,
  })
end

return M
