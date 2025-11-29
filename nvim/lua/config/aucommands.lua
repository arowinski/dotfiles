local augroup = vim.api.nvim_create_augroup("CustomAutocmds", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = vim.highlight.on_yank,
})

-- auto-resize panes
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
})

-- auto-save
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup,
  callback = function(event)
    local buf = event.buf
    local bo = vim.bo[buf]

    if
      bo.modifiable
      and bo.buftype == ""
      and bo.filetype ~= ""
      and not vim.tbl_contains({ "oil", "qf", "gitcommit", "gitrebase" }, bo.filetype)
      and vim.fn.bufname(buf) ~= ""
    then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! write")
      end)
    end
  end,
})

-- create directories on file save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand("%:p:h")

    -- Ignore fugitive buffers
    if string.match(dir, "://") then
      return
    end

    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
      vim.notify("Created non-existing directory: " .. dir)
    end
  end,
})
