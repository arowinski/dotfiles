local util = require("util")

local M = {}

local function file_relative_path()
  return util.string.replace(
    vim.fn.expand("%:p:r"),
    util.dir.project_root("Gemfile") .. "/",
    ""
  )
end

function M.infer_const_parts()
  local parts = vim.split(file_relative_path(), "/")
  local root = parts[1]

  if root == "spec" then
    parts = vim.tbl_map(function(e)
      return string.gsub(e, "_spec", "")
    end, parts)
  end

  if root == "lib" or root == "spec" then
    table.remove(parts, 1)
  elseif root == "app" then
    table.remove(parts, 1)
    table.remove(parts, 1)
  end

  return vim.tbl_map(util.string.camelcase, parts)
end

function M.infer_const()
  return table.concat(M.infer_const_parts(), "::")
end

return M
