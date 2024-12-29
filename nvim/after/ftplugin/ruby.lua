local map = require("util").map

map("n", "<leader>bp", "obinding.irb<ESC>", { buffer = true })
map("n", "<leader>br", ":g/binding.irb/d<CR>", { buffer = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "Rails",
  callback = function()
    if vim.fn.exists("g:rails_projections") == 1 then
      vim.g.rails_projections = require("plugins.coding.projectionist").load_projections("rails")

      vim.api.nvim_create_autocmd("User", {
        pattern = "ProjectionistDetect",
        callback = function()
          require("plugins.coding.projectionist").set_projections("rails")
        end,
      })
    end
  end,
})
