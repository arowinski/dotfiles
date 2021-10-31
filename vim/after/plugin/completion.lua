vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local lspkind = require "lspkind"
lspkind.init()

local cmp = require "cmp"

cmp.setup {
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-q>"] = cmp.mapping.close(),
    ["<c-l>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    },
    ['<C-j>'] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Insert
    }),
    ['<C-k>'] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Insert
    })
  },

  sources = {
    { name = "vsnip" }, { name = "nvim_lua" }, { name = "nvim_lsp" },
    { name = "path" }, { name = "cmdline" },
    { name = "buffer", keyword_length = 5 }
  },

  sorting = {
    comparators = {
      cmp.config.compare.offset, cmp.config.compare.exact,
      cmp.config.compare.score, function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end, cmp.config.compare.kind, cmp.config.compare.sort_text,
      cmp.config.compare.length, cmp.config.compare.order
    }
  },

  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },

  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        vsnip = "[snip]"
      }
    }
  },

  experimental = { native_menu = false, ghost_text = true }
}
