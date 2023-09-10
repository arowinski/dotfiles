local map = require("util").map

map("n", "<leader>bp", "orequire 'pry'; binding.pry<ESC>", { buffer = true })
map("n", "<leader>br", ":g/binding.pry/d<CR>", { buffer = true })

function _G.load_rails_projections()
  if vim.fn.exists("g:rails_projections") then
    vim.g["rails_projections"] = vim.fn["projections#load_projections"]("rails")
    vim.cmd([[
			autocmd User ProjectionistActivate :call projections#set_projections('rails')
		]])
  end
end

vim.cmd([[autocmd User Rails :lua load_rails_projections()]])
