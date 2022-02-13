local M = {}

function M.setup(client)
  local ts_utils = require("nvim-lsp-ts-utils")

  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false

  ts_utils.setup({
    import_all_scan_buffers = 100,
    update_imports_on_move = true,
    -- filter out dumb module warning
    filter_out_diagnostics_by_code = { 80001 },
  })

  ts_utils.setup_client(client)
end

return M
