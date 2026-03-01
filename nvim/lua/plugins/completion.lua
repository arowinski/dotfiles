return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "v1.*",
  opts = {
    keymap = {
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-l>"] = { "select_and_accept", "show" },
      ["<C-d>"] = { "show_documentation", "hide_documentation" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-q>"] = { "hide", "fallback" },
      ["<Tab>"] = {},
      ["<S-Tab>"] = {},
    },
    appearance = {
      kind_icons = {
        Snippet = "",
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 300,
        window = {
          border = "padded",
        },
      },
      menu = {
        border = "none",
        draw = {
          treesitter = { "lsp" },
          padding = 1,
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
          },
        },
      },
      ghost_text = { enabled = true },
    },
    snippets = { preset = "luasnip" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    cmdline = { enabled = false },
  },
  opts_extend = { "sources.default" },
}
