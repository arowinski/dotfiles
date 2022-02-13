local luasnip = require("luasnip")
local camelcase = require("util.string").camelcase
local tbl = require("util.table")
local project_root = require("util.dir").project_root

local snippet = luasnip.snippet
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node
local dynamic_node = luasnip.dynamic_node
local snippet_node = luasnip.snippet_node

local file_path_to_names = function()
  local parts = vim.split(string.sub(project_root(), 2), "/")
  local root = parts[1]

  if root == "spec" then
    parts = vim.tbl_map(function(e)
      return string.gsub(e, "_spec", "")
    end, parts)
  end

  if root == "lib" or root == "spec" then
    table.remove(parts, 1)
  elseif root == "app" then
    table.remove(parts, 1)
    table.remove(parts, 1)
  end

  return vim.tbl_map(camelcase, parts)
end

local formatted_const_name = function(_, _, _, object_type)
  local names = file_path_to_names()

  local def_top = tbl.map_with_index(function(name, index)
    local prefix = "module"

    if index == #names then
      prefix = object_type
    end

    return string.rep("\t", index - 1) .. prefix .. " " .. name
  end, names)

  local def_bottom = tbl.map_with_index(function(_, index)
    return string.rep("\t", #names - index) .. "end"
  end, names)

  return snippet_node(nil, {
    text_node(tbl.merge(def_top, {""})),
    text_node(string.rep("\t", #names)),
    insert_node(0),
    text_node(tbl.merge({ "" }, def_bottom)),
  })
end

local const_name = function()
  return table.concat(file_path_to_names(), "::")
end

return {
  definitions = {
    snippet("class", { dynamic_node(1, formatted_const_name, {}, "class") }),
    snippet("module", { dynamic_node(1, formatted_const_name, {}, "module") }),
    snippet("spec", {
      text_node({ "# frozen_string_literal: true", "", "RSpec.describe " }),
      function_node(const_name, nil),
      text_node({ " do", "\t" }),
      insert_node(0),
      text_node({ "", "end" }),
    }),
  },
}
