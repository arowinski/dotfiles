return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.lsp.config")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "b0o/SchemaStore.nvim",
      "folke/lua-dev.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "j-hui/fidget.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "kyazdani42/nvim-web-devicons",
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
}