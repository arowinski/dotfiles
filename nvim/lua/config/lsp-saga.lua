require("lspsaga").init_lsp_saga({
  code_action_lightbulb = {
    enable = true,
    enable_in_insert = true,
    cache_code_action = true,
    sign = false,
    update_time = 150,
    sign_priority = 20,
    virtual_text = true,
  },
  code_action_keys = {
    quit = { "<ESC>", "q" },
    exec = "<CR>",
  },
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "<ESC>",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  symbol_in_winbar = {
    in_custom = true,
  },
})
