require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "css",
    "go",
    "html",
    "http",
    "javascript",
    "json",
    "lua",
    "ruby",
    "typescript",
    "vim",
    "yaml",
  },
  indent = { enable = false },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  endwise = { enable = true },
})
