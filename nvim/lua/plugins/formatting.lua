return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>p",
        function()
          require("conform").format()
        end,
        "Format the current buffer",
      },
    },
    opts = {
      default_format_opts = {
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
        ["*"] = { "typos" },
        ruby = { "typos", lsp_format = "first" },
      },
      formatters = {
        stylua = {
          append_args = {
            "--indent-type=Spaces",
            "--indent-width=2",
            "--column-width=80",
          },
        },
      },
    },
  },
}
