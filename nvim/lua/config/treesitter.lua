require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "css",
    "elixir",
    "go",
    "html",
    "http",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "ruby",
    "sql",
    "typescript",
    "vim",
    "yaml",
  },
  indent = { enable = false },
  highlight = { enable = true, additional_vim_regex_highlighting = true },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  matchup = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ar"] = "@block.outer",
        ["ir"] = "@block.inner",
      },
    },
  },
  endwise = { enable = true },
  autotag = { enable = true },
})
