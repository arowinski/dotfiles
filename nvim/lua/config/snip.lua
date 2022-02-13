local nmap = require("util").nmap
local luasnip = require("luasnip")

nmap(
  "<leader>sv",
  "<cmd>source ~/.config/nvim/lua/config/snippets.lua<CR>"
)

luasnip.config.set_config({
  history = false,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
})

require("luasnip/loaders/from_vscode").lazy_load({
  paths = { "~/.config/nvim/snippets/" },
})

luasnip.snippets = {
  ruby = require("config.snip.ruby").definitions,
}
