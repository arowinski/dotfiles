local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

npairs.setup({
  fast_wrap = {
    map = '<C-w>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,%s+] ]], '%s+', ''),
    end_key = 'w',
    keys = 'qertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    hightlight = 'Search'
  }
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done',
             cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- CUSTOM RULES

npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
npairs.add_rule(Rule('|', '|', 'ruby'))

npairs.add_rules {
  Rule(' ', ' '):with_pair(function(opts)
    local pair = opts.line:sub(opts.col, opts.col + 1)
    return vim.tbl_contains({ '()', '[]', '{}' }, pair)
  end), Rule('( ', ' )'):with_pair(function() return false end):with_move(
      function(opts) return opts.prev_char:match('.%)') ~= nil end):use_key(')'),
  Rule('{ ', ' }'):with_pair(function() return false end):with_move(
      function(opts) return opts.prev_char:match('.%}') ~= nil end):use_key('}'),
  Rule('[ ', ' ]'):with_pair(function() return false end):with_move(
      function(opts) return opts.prev_char:match('.%]') ~= nil end):use_key(']')
}

_G.context_aware_cr = function()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local next_char = string.sub(line, cursor_col + 1, cursor_col + 1)

  if next_char == "|" then
    vim.api.nvim_feedkeys(npairs.esc('<C-e><CR>'), "i", true)

    return ''
  else
    return MPairs.completion_confirm()
  end
end

U.imap("<CR>", "v:lua.context_aware_cr()", { expr = true, noremap = true })
