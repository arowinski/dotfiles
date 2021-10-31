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
