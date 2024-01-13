return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true,
    opts = { default = true },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    opts = function()
      local lsp_progress = require("util.lsp")

      local filename_with_icon = require("lualine.components.filename"):extend()
      filename_with_icon.apply_icon =
        require("lualine.components.filetype").apply_icon
      filename_with_icon.icon_hl_cache = {}

      return {
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
              function()
                if lsp_progress.is_attached() then
                  return "[LSP]"
                else
                  return ""
                end
              end,
              color = function()
                if lsp_progress.is_ready() then
                  return { fg = "#9ece6a", gui = "bold" }
                else
                  return { fg = "#d99f0d", gui = "bold" }
                end
              end,
              separator = "",
            },
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
            function()
              local value = require("lspsaga.symbolwinbar"):get_winbar()

              if value then
                return value
              else
                return ""
              end
            end,
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
      }
    end,
  },
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPre" },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    keys = {
      {
        "<leader>nc",
        "<cmd>Fidget clear<CR>",
        desc = "Clear notifications",
      },
    },
    opts = {
      notification = {
        override_vim_notify = true,
        view = {
          stack_upwards = false,
        },
        window = {
          normal_hl = "BufferCurrent",
          border = "none",
          winblend = 100,
          max_width = 0,
          max_height = 0,
          x_padding = 1,
          y_padding = -1,
          align = "top",
          relative = "win",
        },
      },
    },
  },
}
