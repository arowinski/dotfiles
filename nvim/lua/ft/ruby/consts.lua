local camelcase = require("util").string.camelcase
local Rails = require("ft.ruby.rails")
local Project = require("ft.ruby.project")

local M = {}

local function infer_const_parts()
  local parts = vim.split(Project.file_path(), "/")

  if parts[1] == "spec" then
    parts = vim.tbl_map(function(e)
      local value = string.gsub(e, "_spec", "")

      return value
    end, parts)
  end

  if vim.tbl_contains({ "lib", "app", "spec" }, parts[1]) then
    table.remove(parts, 1)
  end

  if vim.tbl_contains(Rails.app_dirs(), parts[1]) then
    table.remove(parts, 1)
  end

  return vim.tbl_map(camelcase, parts)
end

-- @param parts (optional) A boolean indicating whether to return the parts as a table.
-- @return If `parts` is true, returns the inferred constant parts as a table.
--         If `parts` is false or nil, returns the inferred constant as a string.
function M.infer(parts)
  if not Project.root() then
    return nil
  end

  local v = parts or false

  if vim.b.const then
    return v and vim.split(vim.b.const, "::") or vim.b.const
  else
    local const_parts = infer_const_parts()

    return v and const_parts or table.concat(const_parts, "::")
  end
end

return M
