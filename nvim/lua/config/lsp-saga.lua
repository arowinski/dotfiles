require("lspsaga").init_lsp_saga({
  code_action_lightbulb = {
    enable = true,
    sign = false,
    sign_priority = 20,
    virtual_text = true,
  },
  code_action_keys = {
    quit = { "q", "<ESC>" },
    exec = "<CR>",
  },
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = { "q", "<ESC>" },
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
})

local nnoremap = require("util").nnoremap

nnoremap("gh", require("lspsaga.finder").lsp_finder)
nnoremap("gd", require("lspsaga.definition").preview_definition)
nnoremap("gs", require("lspsaga.signaturehelp").signature_help)
nnoremap("K", require("lspsaga.hover").render_hover_doc)
