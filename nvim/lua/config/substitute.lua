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
