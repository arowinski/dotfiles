local camelcase = require("util.string").camelcase
local project_root = require("util.dir").project_root

local M = {}

function M.infer_const_parts()
  local parts = vim.split(string.sub(project_root(), 2), "/")
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

  return vim.tbl_map(camelcase, parts)
end

function M.infer_const()
  return table.concat(M.infer_const_parts(), "::")
end

return M
