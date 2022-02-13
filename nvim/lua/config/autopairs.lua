local npairs = require("nvim-autopairs")

npairs.setup({
  chaeck_ts = true,
  fast_wrap = {
    map = "<C-w>",
    chars = { "{", "[", "(", '"', "'", "`" },
    -- pattern = string.gsub([[ [%'%"%)%>%]% })%}%,%(,s+)] ]], "%s+", ""),
    end_key = "w",
    keys = "qertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    hightlight = "Search",
  },
})

-- TODO: add rule for ruby block `do | |` and `{ || }`
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.add_rules({
  Rule("|", "|", "ruby")
    :with_pair(cond.before_text("do "))
    :with_pair(cond.is_end_line()),
  Rule("|", "|", "ruby"):with_pair(cond.before_regex("{%s?", 2)),
})
