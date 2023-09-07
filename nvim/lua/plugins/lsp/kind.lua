local M = {}

M.icons = {
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = " ",
  Variable = " ",
  Class = "ﴯ ",
  Interface = " ",
  Module = " ",
  Property = "ﰠ ",
  Unit = " ",
  Value = " ",
  Enum = " ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = " ",
  Folder = " ",
  EnumMember = " ",
  Constant = " ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
  Copilot = "",
}

function M.cmp_format()
  return function(_, vim_item)
    if M.icons[vim_item.kind] then
      vim_item.kind = M.icons[vim_item.kind] .. vim_item.kind
    end
    return vim_item
  end
end

function M.setup()
  local kinds = vim.lsp.protocol.CompletionItemKind
  for i, kind in ipairs(kinds) do
    kinds[i] = M.icons[kind] or kind
  end
end

return M
