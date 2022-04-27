local util = require("util")

local function lsp_progress(_, is_active)
  if not is_active then
    return
  end

  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return ""
  end

  local status = {}
  for _, msg in pairs(messages) do
    local title = ""
    if msg.title then
      title = msg.title
    end
    table.insert(status, (msg.percentage or 0) .. "%% " .. title)
  end

  return table.concat(status, "  ") .. " " .. util.spinner()
end

vim.cmd("au User LspProgressUpdate let &ro = &ro")

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      {
        "diagnostics",
        separator = "|",
        symbols = {
          error = "✗ ",
          warn = " ",
          hint = " ",
          info = " ",
        },
      },
      {
        "filename",
        path = 1,
        symbols = { modified = "  ", readonly = "" },
      },
    },
    lualine_x = { lsp_progress, "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
