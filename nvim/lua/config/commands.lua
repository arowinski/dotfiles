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
  local bufnr = vim.api.nvim_get_current_buf()
  local alt_bufnr = vim.fn.bufnr("#")
  if alt_bufnr ~= -1 and alt_bufnr ~= bufnr and vim.api.nvim_buf_is_loaded(alt_bufnr) then
    vim.cmd("buffer " .. alt_bufnr)
  else
    vim.cmd("enew")
  end
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.fn.delete(path)
  vim.notify("Removed " .. path)
end, {})
