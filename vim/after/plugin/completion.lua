vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append "c"

local lspkind = require "lspkind"
lspkind.init()

local cmp = require "cmp"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
             vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
                 :match("%s") == nil
end

local has_snippet = function() return vim.fn['vsnip#available'](1) == 1 end

cmp.setup {
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-q>"] = cmp.mapping.close(),
    ["<c-l>"] = cmp.mapping(function(fallback)
      if cmp.visible({ select = true }) then
        if has_snippet() then
          U.feed_key("<Plug>(vsnip-expand-or-jump)", "")
        else
          cmp.confirm({ select = true })
        end
      elseif has_snippet() then
        U.feed_key("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#jumpable'](1) == 1 then
        U.feed_key("<Plug>(vsnip-jump-next)", "")
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        U.feed_key("<Plug>(vsnip-jump-prev)", "")
      else
        fallback()
      end
    end, { 'i', 's' })
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
