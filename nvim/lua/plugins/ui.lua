return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "wave",
      overrides = function(colors)
        return {
          BlinkCmpKindSnippet = { fg = colors.palette.boatYellow1 },
          BlinkCmpDoc = { bg = colors.palette.waveBlue1 },
          BlinkCmpDocBorder = { bg = colors.palette.waveBlue1 },
          BlinkCmpDocSeparator = { bg = colors.palette.waveBlue1 },
          BlinkCmpGhostText = { fg = colors.palette.dragonAsh },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)

      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = { default = true },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local lsp_progress = require("util.lsp")

      local filename_with_icon = require("lualine.components.filename"):extend()
      filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon
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
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#ff9e64" },
            },
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
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = "25%",
            col = "50%",
          },
        },
        popupmenu = {
          relative = "editor",
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "DiagnosticInfo",
            },
          },
        },
      },
      routes = {
        {
          filter = {
            any = {
              { event = "msg_show", find = "written" },
              { event = "msg_show", find = "AutoSave" },
            },
          },
          opts = { skip = true },
        },
      },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
  },
}
