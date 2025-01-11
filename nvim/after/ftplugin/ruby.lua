local map = require("util").map

map("n", "<leader>bp", "obinding.irb<ESC>", { buffer = true })
map("n", "<leader>br", ":g/binding.irb/d<CR>", { buffer = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "Rails",
  callback = function()
    if vim.fn.exists("g:rails_projections") then
      vim.g.rails_projections = require("plugins.coding.projectionist").load_projections("rails")
    end
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.rb",
  callback = function()
    local const = require("ft.ruby").infer_const()

    require("ft.ruby.lsp").find_const(const, function()
      vim.b.const = const
    end)
  end,
})
