local map = require("util").map

-- LSP mappings
map("n", "gD", vim.lsp.buf.definition)
map("n", "gt", vim.lsp.buf.references)

map({ "n", "v" }, "<C-a>", "<CMD>Lspsaga code_action<CR>")
map("n", "gh", "<CMD>Lspsaga finder def+ref<CR>")
map("n", "gd", "<CMD>Lspsaga peek_definition<CR>")
map("n", "K", "<CMD>Lspsaga hover_doc<CR>")
map("n", "gs", vim.lsp.buf.signature_help)

map("n", "[r", "<CMD>Lspsaga diagnostic_jump_prev<CR>")
map("n", "]r", "<CMD>Lspsaga diagnostic_jump_next<CR>")
map("n", "<leader>d", "<CMD>Lspsaga show_line_diagnostics<CR>")

-- Remove default mappings
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grt")

vim.diagnostic.config({
  virtual_text = false,
  float = { source = "if_many", border = "rounded" },
  severity_sort = true,
  show_diagnostic_autocmds = { "InsertLeave", "TextChanged" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗ ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    }
  },
})

-- Enable all configs from nvim/lsp
local configs = {}

for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
  local name = vim.fn.fnamemodify(v, ":t:r")
  configs[name] = true
end

vim.lsp.enable(vim.tbl_keys(configs))
