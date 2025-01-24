local function attach_to_pane(pane_number)
  if pane_number or vim.v.count > 0 then
    vim.cmd(":VtrAttachToPane " .. (pane_number or vim.v.count))
  else
    vim.cmd(":VtrAttachToPane")
  end
end

return {
  {
    "christoomey/vim-tmux-runner",
    keys = {
      {
        "<leader>vs",
        ":VtrSendLinesToRunner<CR>",
        mode = { "n", "v" },
        desc = "Send lines to runner",
        silent = true,
      },
      {
        "<leader>vd",
        "<CMD>VtrSendCtrlD<CR>",
        desc = "Send CTRL-D to runner",
      },
      { "<leader>va", attach_to_pane, desc = "Attach to panel" },
      { "<leader>vv", "<CMD>VtrSendFile<CR>", desc = "Send file" },
    },
    cmd = {
      "VtrSendLinesToRunner",
      "VtrSendCommand",
      "VtrAtachtoPane",
    },
    config = function()
      attach_to_pane(1)
    end,
  },
  {
    "aserowy/tmux.nvim",
    keys = { "<C-j>", "<C-k>", "<C-h>", "<C-l>" },
    opts = {
      copy_sync = { enable = false },
      resize = { enable_default_keybindings = false },
    },
  },
}
