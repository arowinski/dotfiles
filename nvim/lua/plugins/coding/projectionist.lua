local projections_dir = vim.fn.stdpath("config") .. "/projections/"

local M = {}

local function exists(name)
  return vim.fn.filereadable(projections_dir .. name .. ".json") == 1
end

function M.load_projections(name)
  local json = vim.fn.readfile(projections_dir .. name .. ".json")
  return vim.fn["projectionist#json_parse"](json)
end

function M.set_projections(name)
  local types = vim.split(name, "%.")
  for _, type in ipairs(types) do
    if exists(type) then
      vim.fn["projectionist#append"](vim.fn.getcwd(), M.load_projections(type))
    end
  end
end

local function setup_command_alias(from, to)
  vim.cmd(
    string.format(
      'cnoreabbrev <expr> %s ((getcmdtype() == ":" && getcmdline() == "%s") ? ("%s") : ("%s"))',
      from,
      from,
      to,
      from
    )
  )
end

setup_command_alias("E", "e")

return M
