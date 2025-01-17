require("which-key").add({
  { "<leader>q", "<cmd>q<CR>", desc = "Close split" },
  { "<leader>w", "<cmd>w<CR>", desc = "Write buffer" },
})

local map = require("util").map
map("n", "<C-e>", ":e<CR>")

-- convenience mappings
map("n", "H", "^")
map("n", "L", "$")

-- shell like jump mappings
map("i", "<C-e>", "<END>")
map("i", "<C-a>", "<C-o>^")
map("i", "<C-b>", "<LEFT>")
map("i", "<C-f>", "<RIGHT>")

-- travel quickfix
map("n", "]q", ":cnext<CR>")
map("n", "[q", ":cprev<CR>")
map("n", "]Q", ":clast<CR>")
map("n", "[Q", ":cfirst<CR>")

-- copy to system clipboard
map({ "n", "v" }, "<Leader>y", '"+y')

-- previous buffer
map("n", "<space><space>", "<C-^>")

-- handle line wraps better
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

map("n", "<M-q>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)

      if config.relative ~= "" then
        vim.api.nvim_win_close(win, false)
      end
    end
  end
end)

map("c", "<C-a>", "<Home>", { noremap = true, silent = false })
map("c", "<C-e>", "<End>", { noremap = true, silent = false })
map("c", "<A-b>", "<S-Left>", { noremap = true, silent = false })
map("c", "<A-f>", "<S-Right>", { noremap = true, silent = false })
map("c", "<A-BS>", "<C-w>", { noremap = true, silent = false })
map("c", "<A-d>", "<S-Right><C-W>", { noremap = true, silent = false })
