return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "giuxtaposition/blink-cmp-copilot",
      dependencies = {
        {
          "zbirenbaum/copilot.lua",
          cmd = "Copilot",
          build = ":Copilot auth",
          opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
          },
        },
      },
    },
  },
  version = "v0.*",
  opts = {
    keymap = {
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-l>"] = { "select_and_accept", "show" },
      ["<C-d>"] = { "show_documentation", "hide_documentation" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-q>"] = { "hide", "fallback" },
      ["<F13>2"] = { "snippet_forward" },
      ["<F13>3"] = { "snippet_backward" },
    },
    appearance = {
      kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
        Copilot = "",
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
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"

            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
      cmdline = {}, -- disable cmdline completion
    },
  },
  opts_extend = { "sources.default" },
}
