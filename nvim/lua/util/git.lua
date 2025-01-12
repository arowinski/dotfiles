local util = require("util")
local protocol = "https://"
local open_cmd = "open -a 'Google Chrome' "

local function getRepoURL()
  local remote = vim.fn.system("git remote get-url origin")

  if string.find(remote, "fatal: not a git repository") == 1 then
    vim.notify("Not a git repo", vim.log.levels.WARN, { title = "Git" })
    return
  end

  return protocol .. remote:match("git@(.+).git\z"):gsub(":", "/")
end

local function get_remote_url()
  local repo_url = getRepoURL()

  if not repo_url then
    return
  end

  local sha = vim.fn.system("git rev-parse HEAD"):gsub("[\n\r]", "")
  local fpath = vim.fn.expand("%:~:.")
  local lines_segment = nil

  if util.is_visual_mode(vim.api.nvim_get_mode().mode) then
    vim.cmd([[execute "normal! \<ESC>"]])
    lines_segment = "#L" .. vim.fn.getpos("'<")[2] .. "-L" .. vim.fn.getpos("'>")[2]
  else
    lines_segment = "#L" .. unpack(vim.api.nvim_win_get_cursor(0))
  end

  if vim.fn.empty(fpath) == 1 then
    vim.notify("Please open a file", vim.log.levels.WARN, { title = "Git" })
    return
  end

  local blob_segment = string.find(repo_url, "github") and "/blob/" or "/-/blob/"

  return repo_url .. blob_segment .. sha .. "/" .. fpath .. lines_segment
end

local function open_url(url)
  vim.fn.jobstart(open_cmd .. vim.fn.shellescape(url), {
    detach = true,
    on_exit = function(_, code, _)
      if code ~= 0 then
        vim.notify(
          "Could not open the page (" .. code .. ")",
          vim.log.levels.ERROR,
          { title = "Git" }
        )
      end
    end,
  })
end

util.map({ "n", "v" }, "gl", function()
  local url = get_remote_url()

  if url then
    vim.fn.setreg("+", url)

    vim.notify("URL copied to clipboard", vim.log.levels.INFO, { title = "Git" })
  end
end)

util.map({ "n", "v" }, "go", function()
  local url = get_remote_url()

  if url then
    open_url(url)
  end
end)

util.map({ "n", "v" }, "gp", function()
  local url = getRepoURL()

  if url then
    open_url(url .. "/pulls")
  end
end)
