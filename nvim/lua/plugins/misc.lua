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
  { "tpope/tpope-vim-abolish", event = "VeryLazy" },
  { "elihunter173/dirbuf.nvim", event = "BufReadPre" },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      user_default_options = { tailwind = "lsp" },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "CursorHold",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 200,
        filetypes_denylist = { "fugitive" },
        under_cursor = false,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { "Pocco81/auto-save.nvim", event = "BufReadPre" },
}
