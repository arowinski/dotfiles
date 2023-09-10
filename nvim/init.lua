require("config.core")
require("config.builtins")
require("config.options")
require("config.lazy")
require("config.mappings")
require("config.aucommands")

-- TODO: make it generic
vim.g["ruby_path"] = vim.fn.expand("~/.asdf/shims/ruby")
vim.g["loaded_ruby_provider"] = 0
