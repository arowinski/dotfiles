local HOME = os.getenv("HOME")
package.cpath = package.cpath .. ";" .. HOME .. "/.luarocks/lib/lua/5.4/?.so"

require('utils')

require('lsp')
require('diagnostics')
require('complete')
require('treesitter')

require('shade').setup({ overlay_opacity = 50, opacity_step = 1 })
require('luabuffer')
require('status-line')
require('auto-pairs')
