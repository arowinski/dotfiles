local function attach_to_pane(pane_number)
  if pane_number or vim.v.count > 0 then
    vim.cmd(":VtrAttachToPane " .. (pane_number or vim.v.count))
  else
    vim.cmd(":VtrAttachToPane")
  end
end

attach_to_pane(1)

local noremap = require("util").noremap

noremap({ "n", "v" }, "<C-f>", ":VtrSendLinesToRunner<CR>")
noremap("n", "<leader>vd", ":VtrSendCtrlD<CR>")
noremap("n", "<leader>ve", ":VtrSendFile<CR>")
noremap("n", "<leader>vv", attach_to_pane)
