local lsp_progress = require("config.lualine.lsp_progress")
local lsp_symbol = require("config.lualine.lsp_symbol")

local filename_with_icon = require("lualine.components.filename"):extend()
filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon
filename_with_icon.icon_hl_cache = {}

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
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
        symbols = { modified = "", readonly = "" },
        color = function()
          if vim.bo["modified"] == true then
            return { fg = "#d99f0d" }
          end
        end,
      },
    },
    lualine_x = {
      {
        lsp_progress,
        icon = "",
        color = { fg = "#d99f0d", gui = "bold" },
      },
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  winbar = {
    lualine_c = {
      {
        filename_with_icon,
        file_status = true,
        newfile_status = false,
        path = 1,
        colored = true,
        separator = "",
        padding = 0,
      },
      lsp_symbol,
    },
  },
  inactive_winbar = {
    lualine_c = {
      {
        filename_with_icon,
        file_status = true,
        newfile_status = false,
        path = 1,
        colored = true,
      },
    },
  },
  extensions = {},
})
