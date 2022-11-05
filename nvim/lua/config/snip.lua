local util = require("util")

local function prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end

  error("Upsi luasnip failed")
end

local luasnip = prequire("luasnip")

-- Remapped with karabiner-elements, <C-S-[ljk]>
util.noremap({ "i", "v" }, "<F2>1", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    util.info("No snippet under cursor")
  end
end)
util.noremap({ "i", "v" }, "<F2>2", function()
  if luasnip.jumpable(1) then
    luasnip.jump(1)
  else
    util.info("Snippet: can't jump forward")
  end
end)
util.noremap({ "i", "v" }, "<F2>3", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    util.info("Snippet: can't jump back")
  end
end)

luasnip.config.set_config({
  history = false,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
})

luasnip.add_snippets("ruby", require("snip.ruby"))

-- Must be valid JSON without comma on end
require("luasnip/loaders/from_vscode").lazy_load({
  paths = { "~/.config/nvim/snippets/" },
})
---@diagnostic disable-next-line: different-requires
require("luasnip.loaders.from_vscode").lazy_load()
