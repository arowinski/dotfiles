local function setup_command_alias(from, to)
  vim.cmd(
    string.format(
      'cnoreabbrev <expr> %s ((getcmdtype() == ":" && getcmdline() == "%s") ? ("%s") : ("%s"))',
      from,
      from,
      to,
      from
    )
  )
end

setup_command_alias("E", "e")
