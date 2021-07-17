local HOME = os.getenv("HOME")
package.cpath = package.cpath .. ";" .. HOME .. "/.luarocks/lib/lua/5.4/?.so"

require('lsp')
require('complete')
require('treesitter')
