return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "diff",
        "elixir",
        "graphql",
        "heex",
        "html",
        "http",
        "javascript",
        "json",
        "lua",
        "regex",
        "markdown",
        "markdown_inline",
        "c",
        "ruby",
        "sql",
        "tsx",
        "typescript",
        "yaml",
      },
      indent = { enable = false },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
      matchup = { enable = true },
      endwise = { enable = true },
      autotag = { enable = true },
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
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
