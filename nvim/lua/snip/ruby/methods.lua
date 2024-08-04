local luasnip = require("luasnip")

local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node
local dynamic_node = luasnip.dynamic_node
local snippet_node = luasnip.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

local arg_to_name = function(arg)
  return vim.split(arg, "[=:]")[1]:gsub("%s+", "")
end

local args_to_list = function(args)
  return vim.tbl_map(function(arg)
    return arg_to_name(arg)
  end, vim.split(args, ","))
end

local initializer_args = function(index, cp_index)
  return dynamic_node(index, function(args)
    if args[1][1] == "" then
      return snippet_node(nil, {})
    end

    local rb_arguments = vim.tbl_map(function(arg)
      local name = arg_to_name(arg)

      if name == "" then
        return name
      else
        return "\t@" .. name .. " = " .. name
      end
    end, vim.split(args[1][1], ","))

    return snippet_node(nil, { text_node(rb_arguments) })
  end, { cp_index })
end

local init_readers = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for _, line in ipairs(lines) do
    local word = line:find("def initialize")

    if word then
      local brackets = line:match("%(.+%)")

      if brackets then
        local args = vim.tbl_map(function(arg)
          return ":" .. arg
        end, args_to_list(brackets:sub(2, -2)))

        return "attr_reader " .. vim.fn.join(args, ", ")
      end
    end
  end

  vim.notify("No initializer defined")
  return ""
end

return {
  snippet(
    "defi",
    fmt(
      [[
				def initialize({})
				{}
				end
  		]],
      { insert_node(1), initializer_args(2, 1) }
    )
  ),
  snippet("irw", function_node(init_readers)),
}
