require("config.core")
require("builtins")
require("util")
require("options")

vim.defer_fn(function()
  require("plugins")
end, 0)

-- TODO: make it generic
vim.g["ruby_path"] = vim.fn.expand("~/.asdf/shims/ruby")
vim.g["loaded_ruby_provider"] = 0
