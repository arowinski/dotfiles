return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require("config.lsp")
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
    "glepnir/lspsaga.nvim",
    event = "BufReadPre",
    branch = "main",
    config = function()
      require("config.lsp-saga")
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("config.snip")
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
      "hrsh7th/nvim-cmp",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    config = function()
      require("config.telescope")
    end,
    keys = { "<C-p>", "<C-q>", "<C-y>", "\\", "<C-g>", "<C-x>" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "princejoogie/dir-telescope.nvim",
      { "debugloop/telescope-undo.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
}
