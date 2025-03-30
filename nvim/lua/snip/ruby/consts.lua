local luasnip = require("luasnip")
local tbl = require("util.table")
local Ruby = require("ft.ruby")

local snippet = luasnip.snippet
local dynamic_node = luasnip.dynamic_node
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local snippet_node = luasnip.snippet_node

local inheritance_part = function()
  local res = Ruby.Rails.resource_type()

  if res == nil then
    return ""
  else
    return " < " .. res
  end
end

local formatted_const_name = function(_, _, _, object_type)
  local names = Ruby.infer_const(true)

  local def_top = tbl.map_with_index(function(name, index)
    local prefix = "module"
    local suffix = ""

    if index == #names then
      prefix = object_type
      suffix = prefix == "class" and inheritance_part() or ""
    end

    return string.rep("\t", index - 1) .. prefix .. " " .. name .. suffix
  end, names)

  local def_bottom = tbl.map_with_index(function(_, index)
    return string.rep("\t", #names - index) .. "end"
  end, names)

  return snippet_node(nil, {
    text_node(vim.list_extend(def_top, { "" })),
    text_node(string.rep("\t", #names)),
    insert_node(1),
    text_node(vim.list_extend({ "" }, def_bottom)),
  })
end

local const_snip = function(type)
  return snippet(type, { dynamic_node(1, formatted_const_name, {}, { user_args = { type } }) })
end

return { const_snip("class"), const_snip("module") }
