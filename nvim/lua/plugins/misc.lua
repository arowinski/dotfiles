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
  { "tpope/vim-repeat", event = "VeryLazy" },
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
  {
    "echasnovski/mini.ai",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        mappings = {
          -- Main textobject prefixes
          around = "a",
          inside = "i",

          -- Next/last variants
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",

          -- Move cursor to corresponding edge of `a` textobject
          goto_left = "g[",
          goto_right = "g]",
        },
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter(
            { a = "@function.outer", i = "@function.inner" },
            {}
          ),
          c = ai.gen_spec.treesitter(
            { a = "@class.outer", i = "@class.inner" },
            {}
          ),
        },
      }
    end,
  },
  { "Pocco81/auto-save.nvim", event = "BufReadPre" },
}
