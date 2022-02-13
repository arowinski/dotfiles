local M = {}

function M.create_on_save()
  local dir = vim.fn.expand("%:p:h")

  if string.match(dir, "://") then
    return
  end

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
    require("util").info("Created non-existing directory: " .. dir)
  end
end

function M.project_root()
  local expand = vim.fn.expand
  local root = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git/..", expand("%:p:h") .. ";")

  if string.len(git_dir) > 0 then
    root = git_dir
  end

  return string.gsub(expand("%:p:r"), root, "")
end

return M
