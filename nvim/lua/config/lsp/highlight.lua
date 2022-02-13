local M = {}

function M.setup(client)
  -- does not work properly
  if client.name == "solargraph" then
    return
  end

  if client.resolved_capabilities.document_highlight then
    require("illuminate").on_attach(client)
  end
end

return M
