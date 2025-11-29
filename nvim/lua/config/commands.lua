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

vim.api.nvim_create_user_command("Remove", function()
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file to remove", vim.log.levels.ERROR)
    return
  end
  vim.fn.delete(path)
  vim.cmd("bdelete!")
  vim.notify("Removed " .. path)
end, {})
