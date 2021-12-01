require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "bash", "css", "go", "html", "http", "javascript", "json", "lua", "ruby",
    "typescript", "vim", "yaml"
  },
  indent = { enable = false },
  highlight = { enable = true, additional_vim_regex_highlighting = true },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 }
}
