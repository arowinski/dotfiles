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
    "gbprod/substitute.nvim",
    event = "CursorMoved",
    config = function()
      require("config.substitute")
    end,
    dependencies = {
      "kana/vim-operator-user",
      "rhysd/vim-operator-surround",
      "kana/vim-textobj-user",
      "kana/vim-textobj-line",
      "kana/vim-textobj-entire",
      "beloglazov/vim-textobj-quotes",
      "rhysd/vim-textobj-anyblock",
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({
        user_default_options = { tailwind = "lsp" },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require("notify")
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "CursorHold",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 200,
        filetypes_denylist = { "dirvish", "fugitive" },
        under_cursor = false,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTelescope" },
    event = "BufReadPost",
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VimEnter",
    config = function()
      require("config.surround")
    end,
  },
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc", "gb", "gbc" },
    config = function()
      require("Comment").setup({})
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  {
    "ggandor/lightspeed.nvim",
    keys = { "s", "S", "f", "F", "t", "T" },
    config = function()
      require("lightspeed").setup({
        repeat_ft_with_target_char = true,
      })
    end,
  },
  {
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast" },
    keys = { "<leader>tt", "<leader>tf", "<Leader>ts", "<Leader>tl" },
    config = function()
      require("config.test")
    end,
    dependencies = { "christoomey/vim-tmux-runner" },
  },
  {
    "tpope/vim-projectionist",
    event = "VimEnter",
    config = function()
      require("config.projectionist")
    end,
    dependencies = { "tpope/vim-rails" },
  },
  { "tpope/vim-bundler", cmd = { "Bopen" } },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("config.treesj")
    end,
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
  { "jparise/vim-graphql", cmd = "BufReadPre" },
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
  },
}
