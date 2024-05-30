local M = {}

function M.setup(_, options)
  require("ts-error-translator").setup()
  require("typescript-tools").setup({
    on_attach = options.on_attach,
  })
end

return M
