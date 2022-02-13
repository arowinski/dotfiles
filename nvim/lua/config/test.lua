local nmap = require("util").nmap

vim.g["test#strategy"] = "vtr"

nmap("<Leader>tt", ":TestNearest<CR>")
nmap("<Leader>tf", ":TestFile<CR>")
nmap("<Leader>ts", ":TestSuite<CR>")
nmap("<Leader>tl", ":TestLast<CR>")
