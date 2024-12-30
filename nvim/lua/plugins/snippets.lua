return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  build = "make install_jsregexp",
  event = "VeryLazy",
  config = function()
    local util = require("util")
    local luasnip = require("luasnip")

    -- Remapped with karabiner-elements, <C-S-[ljk]>
    util.map({ "i", "v" }, "<F13>1", function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        vim.notify("No snippet under cursor")
      end
    end)
    util.map({ "i", "v" }, "<F13>2", function()
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        vim.notify("Snippet: can't jump forward")
      end
    end)
    util.map({ "i", "v" }, "<F13>3", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        vim.notify("Snippet: can't jump back")
      end
    end)

    luasnip.config.set_config({
      history = false,
      -- Update more often, :h events for more info.
      updateevents = "TextChanged,TextChangedI",
    })

    luasnip.add_snippets("ruby", require("snip.ruby"))

    require("luasnip/loaders/from_vscode").lazy_load({
      paths = { "~/.config/nvim/snippets/" },
    })

    require("luasnip").config.setup({ store_selection_keys = "<F13>1" })
  end,
}
