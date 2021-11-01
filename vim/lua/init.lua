local HOME = os.getenv("HOME")
package.cpath = package.cpath .. ";" .. HOME .. "/.luarocks/lib/lua/5.4/?.so"

require('utils')

require('lsp')
require('diagnostics')
require('snippets')
require('treesitter')

require('luabuffer')
require('status-line')
require('auto-pairs')
require('git')
require'lspsaga'.init_lsp_saga({
  use_saga_diagnostic_sign = false,
  code_action_keys = { quit = { 'q', '<Esc>' }, exec = '<CR>' },
  finder_action_keys = {
    open = 'o',
    vsplit = 's',
    split = 'i',
    quit = { 'q', '<Esc>' },
    scroll_down = '<C-d>',
    scroll_up = '<C-u>'
  }
})
