local protocol = "https://"

require("util").map("n", "gl", function()
  local remote = vim.fn.system("git remote get-url origin")

  if string.find(remote, "fatal: not a git repository") == 1 then
    vim.notify("Not a git repo", vim.log.levels.WARN, { title = "Gitlab" })
    return
  end

  ---@diagnostic disable-next-line: need-check-nil
  local repo_url = protocol .. remote:match("git@(.+).git\z"):gsub(":", "/")
  local sha = vim.fn.system("git rev-parse HEAD"):gsub("[\n\r]", "")
  local fpath = vim.fn.expand("%:~:.")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  if vim.fn.empty(fpath) == 1 then
    vim.notify("Please open a file", vim.log.levels.WARN, { title = "Gitlab" })
    return
  end

  vim.fn.setreg("+", repo_url .. "/-/blob/" .. sha .. "/" .. fpath .. "#L" .. row)
  vim.notify("URL copied to clipboard", vim.log.levels.INFO, { title = "Gitlab" })
end)
