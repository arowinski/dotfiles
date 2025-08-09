return {
  "gbprod/substitute.nvim",
  event = "CursorMoved",
  config = function()
    local wk = require("which-key")

    local substitute = require("substitute")
    local range = require("substitute.range")
    substitute.setup({
      on_substitute = function(event)
        require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
      end,
    })

    wk.add({
      { "gr", substitute.operator, desc = "Replace from register with operator" },
      {
        "M",
        function()
          range.operator({ subject = { motion = "iw" }, complete_word = true })
        end,
        desc = "Replace word",
      },
      {
        "m",
        function()
          range.operator({ prefix = "S" })
        end,
        desc = "Replace text object",
        mode = { "n", "x" },
      },
      { "cx", require("substitute.exchange").operator, desc = "Exchange text object" },
    })
  end,
  dependencies = {
    {
      "chrisgrieser/nvim-various-textobjs",
      keys = {
        {
          "ae",
          "<cmd>lua require('various-textobjs').entireBuffer()<CR>",
          desc = "Entire buffer",
          mode = { "o", "x" },
        },
        {
          "is",
          "<cmd>lua require('various-textobjs').subword('inner')<CR>",
          desc = "Inner subword",
          mode = { "o", "x" },
        },
        {
          "as",
          "<cmd>lua require('various-textobjs').subword('outer')<CR>",
          desc = "Outer subword",
          mode = { "o", "x" },
        },
        {
          "il",
          "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>",
          desc = "Inner line",
          mode = { "o", "x" },
        },
        {
          "al",
          "<cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>",
          desc = "Outer line",
          mode = { "o", "x" },
        },
        {
          "iq",
          "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>",
          desc = "Inner quote",
          mode = { "o", "x" },
        },
        {
          "aq",
          "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>",
          desc = "Outer quote",
          mode = { "o", "x" },
        },
        {
          "ib",
          "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>",
          desc = "Inner bracket",
          mode = { "o", "x" },
        },
        {
          "ab",
          "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>",
          desc = "Outer bracket",
          mode = { "o", "x" },
        },
      },
    },
    "gbprod/yanky.nvim",
  },
}
