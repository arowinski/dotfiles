local Project = require("ft.ruby.project")

M = {}

local RESOURCE_TO_PARENT_CLASS_NAME = {
  models = "ApplicationRecord",
  controllers = "ApplicationController",
  mailers = "ApplicationMailer",
  jobs = "ApplicationJob",
  components = "ApplicationComponent",
  services = "ApplicationService",
}

-- local function is_package()
--   return vim.fs.root(vim.fn.expand("%"), ".git") ~= find_root()
-- end

function M.app_dirs()
  local dirs = vim.fn.glob(Project.root() .. "/app/*", false, 1)
  local dir_names = {}

  for _, dir in ipairs(dirs) do
    table.insert(dir_names, vim.fn.fnamemodify(dir, ":t"))
  end

  return dir_names
end

function M.resource_type()
  local parts = vim.split(Project.file_path(), "/")

  return parts[1] ~= "app" and nil or RESOURCE_TO_PARENT_CLASS_NAME[parts[2]]
end

return M
