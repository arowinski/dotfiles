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
      threshold = 15,
      close_command = function(bufnr)
        vim.api.nvim_buf_delete(bufnr, {})
      end,
    },
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-eunuch", cmd = { "Delete", "Move", "Rename", "Remove" } },
  { "tpope/tpope-vim-abolish", event = "VeryLazy" },
  { "elihunter173/dirbuf.nvim", event = "BufReadPre" },
}
