local map = require("util").map

map("n", "<leader>bp", "oimport IEx; IEx.pry()<ESC>", { buffer = true })
map("n", "<leader>br", ":g/IEx.pry/d<CR>", { buffer = true })
