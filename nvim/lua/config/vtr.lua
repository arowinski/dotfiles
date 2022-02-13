local noremap = require("util").noremap

noremap({ "n", "v" }, "<C-f>", ":VtrSendLinesToRunner<CR>")
noremap("n", "<leader>vd", ":VtrSendCtrlD<CR>")
noremap("n", "<leader>ve", ":VtrSendFile<CR>")

vim.cmd(":VtrAttachToPane 1")
io.popen(
  string.format("tmux clock-mode -t 1 &&  sleep 0.1 &&  tmux send-keys -t 1 q")
)
