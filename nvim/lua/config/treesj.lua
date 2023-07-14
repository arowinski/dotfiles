local treejs = require("treesj")

treejs.setup({ use_default_keymaps = false })

vim.keymap.set("n", "gJ", treejs.join, { noremap = true, silent = true })
vim.keymap.set("n", "gS", treejs.split, { noremap = true, silent = true })
vim.keymap.set("n", "gG", treejs.toggle, { noremap = true, silent = true })
