-- Install packer

local install_path = vim.fn.stdpath("data")
  .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute(
    "!git clone https://github.com/wbthomason/packer.nvim " .. install_path
  )
end

vim.cmd([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]])

local use = require("packer").use
require("packer").startup(function()
  -- "wants" keyword loads plugin before used one
  use("wbthomason/packer.nvim")

  -- Theme
  use("folke/tokyonight.nvim")
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })
  use({
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = [[require('config.lualine')]],
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  -- TMUX: integration
  use({
    "aserowy/tmux.nvim",
    keys = { "<C-j>", "<C-k>", "<C-h>", "<C-l>" },
    config = [[require('config.tmux')]],
  })
  use({
    "christoomey/vim-tmux-runner",
    keys = { "<c-f>", "<leader>ve", "<leader>vd" },
    cmd = { "VtrSendLinesToRunner", "VtrSendFile", "VtrSendCommand" },
    config = [[require("config.vtr")]],
  })

  -- Git integration
  use({
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = { "g<space>", "<leader>gl" },
    config = [[require('config.fugitive')]],
  })
  use({
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    requires = { "nvim-lua/plenary.nvim" },
    config = [[require("config.gitsigns")]],
  })

  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use({
    "nvim-treesitter/nvim-treesitter",
    opt = true,
    run = ":TSUpdate",
    event = "BufRead",
    config = [[require('config.treesitter')]],
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-endwise",
      "p00f/nvim-ts-rainbow",
    },
  })

  -- LSP
  use({
    "glepnir/lspsaga.nvim",
    event = "BufReadPre",
    branch = "main",
    config = [[require("config.lsp-saga")]],
  })

  use({
    "neovim/nvim-lspconfig",
    opt = true,
    -- event = "BufReadPre",
    after = "lspsaga.nvim",
    config = [[require('config.lsp')]],
    wants = {
      "cmp-nvim-lsp",
      "nvim-lsp-ts-utils",
      "null-ls.nvim",
      "lua-dev.nvim",
      "nvim-lsp-installer",
      "SchemaStore.nvim",
    },
    requires = {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/nvim-lsp-installer",
      "b0o/SchemaStore.nvim",
      "folke/lua-dev.nvim",
    },
  })

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    event = "UIEnter",
    opt = true,
    config = [[require('config.cmp')]],
    wants = { "LuaSnip" },
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      {
        module = "nvim-autopairs",
        "windwp/nvim-autopairs",
        config = [[require("config.autopairs")]],
      },
      "saadparwaiz1/cmp_luasnip",
    },
  })

  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("config.snip")
    end,
    after = "nvim-cmp",
    requires = { { "rafamadriz/friendly-snippets" } },
  })

  -- Delete buffer preserving windows
  use({ "famiu/bufdelete.nvim", cmd = { "Bdelete" } })

  -- Substitute with motions
  -- TODO: Replace with treesitter
  use({
    "gbprod/substitute.nvim",
    event = "CursorMoved",
    config = [[require("config.substitute")]],
    requires = {
      "kana/vim-operator-user",
      "rhysd/vim-operator-surround",
      "kana/vim-textobj-user",
      "kana/vim-textobj-line",
      "kana/vim-textobj-entire",
      "gaving/vim-textobj-argument",
      "rhysd/vim-textobj-ruby",
      "beloglazov/vim-textobj-quotes",
      "rhysd/vim-textobj-anyblock",
    },
  })

  -- Color higlighter
  use({
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = [[require('colorizer').setup()]],
  })

  -- Better notifications
  use({
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = [[vim.notify = require("notify")]],
  })

  -- Highlight same words
  use({
    "RRethy/vim-illuminate",
    event = "CursorHold",
    module = "illuminate",
    config = function()
      vim.g.Illuminate_highlightUnderCursor = 0
      vim.g.Illuminate_delay = 200
    end,
  })

  -- Fancy TODO
  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "TodoTelescope" },
    event = "BufReadPost",
    config = [[require("todo-comments").setup({})]],
  })

  -- Git diffs in visual form
  use({
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    module = "diffview",
    config = [[require("diffview").setup({})]],
  })

  use({
    "tpope/vim-surround",
    config = function()
      vim.g["surround_no_insert_mappings"] = 1
    end,
  })

  use({
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc", "gb", "gbc" },
    config = [[require("Comment").setup({})]],
    requires = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        module = "ts_context_commentstring",
      },
    },
  })

  -- Goto character
  use({
    "ggandor/lightspeed.nvim",
    keys = { "s", "S", "f", "F", "t", "T" },
    config = function()
      require("lightspeed").setup({
        repeat_ft_with_target_char = true,
      })
    end,
  })

  use({
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad" },
    config = [[require("luapad").init()]],
  })

  -- Test runner
  use({
    "vim-test/vim-test",
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast" },
    keys = { "<leader>tt", "<leader>tf", "<Leader>ts", "<Leader>tl" },
    config = [[require("config.test")]],
    wants = { "vim-tmux-runner" },
  })

  use({
    "tpope/vim-projectionist",
    opt = true,
    event = "VimEnter",
    config = [[require("config.projectionist")]],
    -- TODO: lazy load vim-rails
    requires = { "tpope/vim-rails" },
  })

  use({ "tpope/vim-bundler", cmd = { "Bopen" } })
  use({ "tpope/vim-repeat" })
  -- Vim sugar for the UNIX shell commands that need it the most.
  use({ "tpope/vim-eunuch", cmd = { "Delete", "Move", "Rename", "Remove" } })
  -- Subvert, coercion and abbreviation
  use({ "tpope/tpope-vim-abolish" })
  use({ "AndrewRadev/splitjoin.vim", keys = { "gJ", "gS" } })
  use({
    "FooSoft/vim-argwrap",
    config = function()
      require("util").nnoremap("<leader>aa", ":ArgWrap<CR>")
    end,
  })

  -- Finder
  use({
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    module = "telescope",
    config = [[require('config.telescope')]],
    keys = { "<C-p>", "<C-q>", "<C-y>", "\\", "<C-g>", "<C-x>" }, -- \\ messes up with textobj-quote
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    wants = { "trouble.nvim" },
  })

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    cmd = { "TroubleToggle", "Trouble" },
    config = [[require("config.trouble")]],
  })

  -- Measuring startup time for given file
  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

  -- Blank line identation
  use({ "lukas-reineke/indent-blankline.nvim" })

  -- Git conflict markers and mappings for quick resolving
  use({
    "rhysd/conflict-marker.vim",
    config = [[require("config.conflict-marker")]],
  })

  -- Replacement for matchit, more features
  use({ "andymass/vim-matchup" })

  -- GraphQL syntax
  use({ "jparise/vim-graphql" })

  -- Better javascript/typescript highlight
  use({
    "pangloss/vim-javascript",
    requires = { "leafgarland/typescript-vim", "peitalin/vim-jsx-typescript" },
  })
end)
