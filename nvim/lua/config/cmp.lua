-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.setup({
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "copilot" },
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
    { name = "treesitter", priority = 7 },
  }),
  mapping = {
    ["<C-d>"] = cmp.mapping(function(fallback)
      if cmp.visible({ select = false }) then
        cmp.scroll_docs(-4)
      else
        fallback()
      end
    end),
    ["<C-f>"] = cmp.mapping(function(fallback)
      if cmp.visible({ select = false }) then
        cmp.scroll_docs(4)
      else
        fallback()
      end
    end),
    ["<C-q>"] = cmp.mapping.close(),
    ["<c-l>"] = cmp.mapping(function(fallback)
      if cmp.visible({ select = true }) then
        cmp.confirm({ select = true })
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif has_words_before() then
        cmp.complete()
      end
    end, { "i", "s" }),
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  formatting = {
    format = require("config.lsp.kind").cmp_format(),
  },
  experimental = { ghost_text = true },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
