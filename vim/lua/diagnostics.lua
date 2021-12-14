require("trouble").setup({
  position = "bottom",
  height = 10,
  width = 50,
  icons = true,
  mode = "document_diagnostics",
  fold_open = "",
  fold_closed = "",
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = { "<cr>", "g" },
    open_split = { "<c-x>" },
    open_vsplit = { "<c-v>" },
    jump_close = { "o" },
    toggle_mode = "m",
    toggle_preview = "P",
    hover = "K",
    preview = "p",
    previous = "k",
    next = "j"
  },
  indent_lines = true,
  auto_preview = true,
  signs = {
    error = "✗",
    warning = "",
    hint = "",
    information = "",
    other = "﫠"
  }
})

-- Signs fix

local signs = { Error = "✗ ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local nmap = function(lhs, rhs) U.nmap(lhs, "<cmd>" .. rhs .. '<CR>') end

nmap('<leader>e', "TroubleToggle")

nmap('[r', "Lspsaga diagnostic_jump_prev")
nmap(']r', "Lspsaga diagnostic_jump_next")
-- nmap('[r', 'lua vim.lsp.diagnostic.goto_prev({enable_popup = false})')
-- nmap(']r', 'lua vim.lsp.diagnostic.goto_next({enable_popup = false})')

vim.diagnostic.config({
  virtual_text = false,
  float = { source = "always" },
  severity_sort = true
})
