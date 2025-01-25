local luasnip = require("luasnip")
local Ruby = require("ft.ruby")

local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node
local choice_node = luasnip.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  snippet(
    "spec",
    fmt(
      [[
				# frozen_string_literal: true

				RSpec.describe {} do
					{}
				end
			]],
      { function_node(function()
        return Ruby.infer_const()
      end, nil), insert_node(0) }
    )
  ),
  snippet(
    "exp",
    fmt("expect({}).{} {}({})", {
      insert_node(1),
      choice_node(2, { text_node("to"), text_node("not_to") }),
      insert_node(3, "eq"),
      insert_node(4),
    })
  ),
}
