local M = {}

function M.create_on_save()
  local dir = vim.fn.expand("%:p:h")

  -- Ignore fugitive buffers
  if string.match(dir, "://") then
    return
  end

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
    vim.notify("Created non-existing directory: " .. dir)
  end
end

return M
