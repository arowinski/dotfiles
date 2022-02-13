local util = require("util")

local substitute = require("substitute")
local range = require("substitute.range")
substitute.setup({})

util.nnoremap("gr", substitute.operator)
util.nmap("M", range.word)
util.noremap({ "n", "x" }, "m", function()
  range.operator({ prefix = "S" })
end)
util.nmap("cx", require("substitute.exchange").operator)

vim.g["textobj#anyblock#blocks"] = { "(", "{", "[", "<" }

vim.cmd([[
	nmap <silent>ysb <Plug>(operator-surround-append)<Plug>(textobj-anyblock-a)
	nmap <silent>dsb <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
	nmap <silent>csb <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)

	nmap <silent>ysq <Plug>(operator-surround-append)<Plug>(textobj-quote-a)
	nmap <silent>dsq <Plug>(operator-surround-delete)<Plug>(textobj-quote-a)
	nmap <silent>csq <Plug>(operator-surround-replace)<Plug>(textobj-quote-a)

	nmap <silent>ysl <Plug>(operator-surround-append)<Plug>(textobj-line-i)
	nmap <silent>dsl <Plug>(operator-surround-delete)<Plug>(textobj-line-i)
	nmap <silent>csl <Plug>(operator-surround-replace)<Plug>(textobj-line-i)

	nmap <silent>yse <Plug>(operator-surround-append)<Plug>(textobj-entire-i)
	nmap <silent>dse <Plug>(operator-surround-delete)<Plug>(textobj-entire-i)
	nmap <silent>cse <Plug>(operator-surround-replace)<Plug>(textobj-entire-i)
]])
