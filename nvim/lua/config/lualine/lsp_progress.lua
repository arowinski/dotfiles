local util = require("util")

local function active_lsp()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()

  if next(clients) == nil then
    return ""
  end
  local size = vim.tbl_filter(function(client)
    local filetypes = client.config.filetypes

    return filetypes and vim.fn.index(filetypes, buf_ft) ~= -1
  end, clients)

  if #size > 0 then
    return "[LSP]"
  else
    return ""
  end
end

local function lsp_progress(_, is_active)
  if not is_active then
    return ""
  end

  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return active_lsp()
  end

  local status = {}
  for _, msg in pairs(messages) do
    local title = ""
    if msg.title then
      title = msg.title
    end
    table.insert(status, (msg.percentage or 0) .. "%% " .. title)
  end

  return table.concat(status, " | ") .. util.spinner()
end

return lsp_progress
