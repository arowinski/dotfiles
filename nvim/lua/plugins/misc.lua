return {
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
  { "andymass/vim-matchup", event = "VeryLazy" },
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<C-c>", ":Bdelete<CR>", silent = true },
    },
  },
  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = {
      autoclose = true, -- set autoclose to false if you want to close manually
      threshold = 20,
      close_command = function(bufnr)
        vim.api.nvim_buf_delete(bufnr, {})
      end,
    },
  },
  { "tpope/vim-eunuch", cmd = { "Delete", "Move", "Rename", "Remove" } },
  { "tpope/vim-abolish", event = "VeryLazy" },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      user_default_options = { tailwind = "lsp" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    opts = {
      highlight = {
        treesitter = true,
        lsp = false,
        load_buffers = false,
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
