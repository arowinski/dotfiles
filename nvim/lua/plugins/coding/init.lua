return {
  { "tpope/vim-bundler", cmd = "Bopen" },
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gcc", "gb", "gbc" },
    config = function(_, _)
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },
  {
    "gbprod/yanky.nvim",
    config = function()
      require("yanky").setup({})

      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

      vim.keymap.set("n", "<M-j>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<M-k>", "<Plug>(YankyCycleBackward)")
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        aliases = {
          ["b"] = { ")", "}", "]" },
        },
      })
    end,
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { use_default_keymaps = false, max_join_length = 150 },
    keys = {
      { "gJ", "<cmd>TSJJoin<CR>", desc = "Join block" },
      { "gS", "<cmd>TSJSplit<CR>", desc = "Split block" },
      { "gG", "<cmd>TSJToggle<CR>", desc = "Toggle block" },
    },
  },
  {
    "vim-test/vim-test",
    dependencies = { "christoomey/vim-tmux-runner" },
    keys = {
      { "<leader>tt", "<CMD>TestNearest<CR>", desc = "Run nearest test" },
      { "<leader>tf", "<CMD>TestFile<CR>", desc = "Run test file" },
      { "<Leader>tl", "<CMD>TestLast<CR>", desc = "Run last test" },
    },
    init = function()
      vim.g["test#strategy"] = "vtr"
      vim.g["test#javascript#jest#executable"] = "yarn test"
    end,
  },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    keys = {
      { "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" } },
      { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" } },
    },
  },
  {
    "tpope/vim-projectionist",
    lazy = false,
    dependencies = { "tpope/vim-rails" },
    keys = {
      { "<leader>av", ":AOV<CR>", "Open alternate in vsplit" },
      { "<leader>rv", ":ROV<CR>", "Open related in vsplit" },
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "ProjectionistDetect",
        callback = function()
          require("plugins.coding.projectionist").append_projections(vim.bo.filetype)
        end,
      })

      vim.cmd([[
        command! ROV silent only|RV
        command! AOV silent only|AV
      ]])
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    opts = {
      strategies = {
        inline = {
          keymaps = {
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              opts = { nowait = true },
              description = "Reject the suggested change",
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>ca",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion Actions",
      },
      {
        "<leader>co",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "Toggle CodeCompanion Chat",
      },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to CodeCompanion Chat" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
