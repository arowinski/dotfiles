local util = require("util")

local M = {}

local function file_relative_path()
  return util.string.replace(
    vim.fn.expand("%:p:r"),
    vim.fs.root(vim.fn.expand("%"), "Gemfile") .. "/",
    ""
  )
end

local function app_dirs()
  local app_dir = vim.fs.root(vim.fn.expand("%"), "Gemfile") .. "/app/"
  local dirs = vim.fn.glob(app_dir .. "/*", false, 1)
  local dir_names = {}

  for _, dir in ipairs(dirs) do
    table.insert(dir_names, vim.fn.fnamemodify(dir, ":t"))
  end

  return dir_names
end

function M.infer_const_parts()
  local parts = vim.split(file_relative_path(), "/")

  if parts[1] == "spec" then
    parts = vim.tbl_map(function(e)
      return string.gsub(e, "_spec", "")
    end, parts)
  end

  table.remove(parts, 1)

  if vim.tbl_contains(app_dirs(), parts[1]) then
    table.remove(parts, 1)
  end

  return vim.tbl_map(util.string.camelcase, parts)
end

function M.infer_const()
  return table.concat(M.infer_const_parts(), "::")
end

return M
