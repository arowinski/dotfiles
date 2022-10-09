local M = {}

function M.setup(_, options)
  require("typescript").setup({
    disable_commands = false,
    debug = false,
    go_to_source_definition = {
      fallback = true,
    },
    server = {
      on_attach = options.on_attach,
    },
  })
end

return M
