local str_replace = require("util").string.replace

local M = {}

function M.root()
  return vim.b.rails_root or vim.fs.root(vim.fn.expand("%"), { "Gemfile", "Gemspec" })
end

function M.file_path()
  return str_replace(vim.fn.expand("%:p:r"), M.root() .. "/", "")
end

return M
