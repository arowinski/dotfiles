require'nvim-treesitter.configs'.setup {
  ensure_installed = { "ruby", "javascript", "html", "css", "lua", "bash" },
  indent = { enable = false },
  highlight = { enable = true, additional_vim_regex_highlighting = true },
  rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 }
}
