require("lspsaga").setup({
  lightbulb = {
    enable = true,
    enable_in_insert = true,
    sign = false,
    sign_priority = 20,
    virtual_text = true,
  },
  code_action = {
    num_shortcut = true,
    keys = {
      quit = { "q", "<ESC>" },
      exec = "<CR>",
    },
  },
  finder = {
    open = "o",
    vsplit = "s",
    split = "i",
    quit = "<ESC>",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },
  symbol_in_winbar = {
    enable = false,
    show_file = false,
    folder_level = 0,
  },
})
