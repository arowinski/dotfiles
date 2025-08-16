return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  "b0o/SchemaStore.nvim",
  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lightbulb = {
        enable = true,
        enable_in_insert = true,
        sign = false,
        sign_priority = 20,
        virtual_text = true,
      },
      code_action = {
        num_shortcut = true,
        keys = {
          quit = { "q", "<ESC>" },
          exec = "<CR>",
        },
      },
      finder = {
        open = "o",
        vsplit = "s",
        split = "i",
        quit = "<ESC>",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
      symbol_in_winbar = {
        enable = false,
        show_file = false,
        folder_level = 0,
      },
    },
  },
  { "zeioth/garbage-day.nvim", event = "VeryLazy" },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
