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
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("config.lualine")
    end,
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = { "g<space>", "<leader>gl" },
    config = function()
      require("config.fugitive")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("config.treesitter")
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-endwise",
      "mrjones2014/nvim-ts-rainbow",
      "windwp/nvim-ts-autotag",
    },
  },
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
    "hrsh7th/nvim-cmp",
    event = "UIEnter",
    config = function()
      require("config.cmp")
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      {
        module = "nvim-autopairs",
        "windwp/nvim-autopairs",
        config = function()
          require("config.autopairs")
        end,
      },
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "ray-x/cmp-treesitter",
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
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
  { "famiu/bufdelete.nvim", cmd = { "Bdelete" } },
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
  { "tpope/vim-repeat" },
  { "tpope/vim-eunuch", cmd = { "Delete", "Move", "Rename", "Remove" } },
  { "tpope/tpope-vim-abolish" },
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
  { "tweekmonster/startuptime.vim", cmd = "StartupTime" },
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPre" },
  {
    "rhysd/conflict-marker.vim",
    event = "BufReadPost",
    config = function()
      require("config.conflict-marker")
    end,
  },
  { "andymass/vim-matchup" },
  { "jparise/vim-graphql", cmd = "BufReadPre" },
  { "stevearc/dressing.nvim", cmd = "VimEnter" },
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
  },
  { "elihunter173/dirbuf.nvim", event = "BufReadPre" },
  {
    "axkirillov/hbac.nvim",
    config = function()
      require("hbac").setup({
        autoclose = true, -- set autoclose to false if you want to close manually
        threshold = 15,
        close_command = function(bufnr)
          vim.api.nvim_buf_delete(bufnr, {})
        end,
      })
    end,
  },
}
