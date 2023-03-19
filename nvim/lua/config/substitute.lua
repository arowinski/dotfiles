local util = require("util")

local substitute = require("substitute")
local range = require("substitute.range")
substitute.setup({
  on_substitute = function(event)
    require("yanky").init_ring(
      "p",
      event.register,
      event.count,
      event.vmode:match("[vV�]")
    )
  end,
})

util.nnoremap("gr", substitute.operator)
util.nmap("M", range.word)
util.noremap({ "n", "x" }, "m", function()
  range.operator({ prefix = "S" })
end)
util.nmap("cx", require("substitute.exchange").operator)

vim.g["textobj#anyblock#blocks"] = { "(", "{", "[", "<" }
