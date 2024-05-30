local M = {}

function M.is_ready()
  local messages = vim.lsp.status()

  return #messages == 0
end

function M.is_attached()
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_clients({ bufnr = 0 })

  if next(clients) == nil then
    return false
  end

  local size = vim.tbl_filter(function(client)
    local filetypes = client.config.filetypes

    return filetypes and vim.fn.index(filetypes, buf_ft) ~= -1
  end, clients)

  return #size > 0
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return M
