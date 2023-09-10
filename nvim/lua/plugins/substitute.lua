return {
  "gbprod/substitute.nvim",
  event = "CursorMoved",
  config = function()
    local wk = require("which-key")

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

    wk.register({
      g = {
        r = { substitute.operator, "Replace from register with operator" },
      },
      M = {
        function()
          range.operator({ subject = { motion = "iw" } })
        end,
        "Replace word",
      },
      m = {
        function()
          range.operator({ prefix = "S" })
        end,
        "Replace text object",
        mode = { "n", "x" },
      },
      c = {
        x = {
          require("substitute.exchange").operator,
          "Exchange text object",
        },
      },
    })

    vim.g["textobj#anyblock#blocks"] = { "(", "{", "[", "<" }
  end,
  dependencies = {
    "kana/vim-operator-user",
    "rhysd/vim-operator-surround",
    "kana/vim-textobj-user",
    "kana/vim-textobj-line",
    "kana/vim-textobj-entire",
    "beloglazov/vim-textobj-quotes",
    "rhysd/vim-textobj-anyblock",
    "gbprod/yanky.nvim",
  },
}
