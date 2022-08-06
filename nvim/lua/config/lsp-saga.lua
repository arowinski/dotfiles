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
