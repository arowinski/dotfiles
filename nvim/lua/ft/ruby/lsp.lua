local M = {}

local function request(query, callback)
  local client = vim.lsp.get_clients({ name = "ruby_lsp" })[1]

  if not client then
    return
  end

  client.request("workspace/symbol", { query = query }, function(error, result)
    if error then
      vim.notify("Error fetching " .. query .. "symbols", "warn")
      return
    end

    callback(result)
  end, 0)
end

function M.find_const(query, callback)
  request(query, function(symbols)
    for _, item in ipairs(symbols) do
      if item.kind == 5 or item.kind == 3 then
        return callback(item.name)
      end
    end

    callback(nil)
  end)
end

return M
