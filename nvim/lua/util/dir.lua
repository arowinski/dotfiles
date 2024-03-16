local M = {}

function M.create_on_save()
  local dir = vim.fn.expand("%:p:h")

  -- Ignore fugitive buffers
  if string.match(dir, "://") then
    return
  end

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
    require("util").info("Created non-existing directory: " .. dir)
  end
end

function M.project_root(file_pattern)
  local marker = nil

  if file_pattern then
    marker = vim.fn.fnamemodify(vim.fn.findfile(file_pattern, ".;"), ":p:h")
  else
    marker = vim.fn.finddir(".git/..", ".;")
  end

  if marker and string.len(marker) > 0 then
    return marker
  else
    require("util").warn("Couldn't find project root, using cwd")
    return vim.fn.getcwd()
  end
end

return M
