local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--vimgrep",
      "--smart-case",
      "--max-filesize=500000",
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<ESC>"] = actions.close,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
})

require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
local nmap = require("util").nmap
local vmap = require("util").vmap

nmap("<C-p>", builtin.find_files)
nmap("<C-y>", builtin.registers)
nmap("\\", builtin.live_grep)
nmap("<C-q>", builtin.buffers)
nmap("<leader>gs", builtin.git_stash)
nmap("<C-g>", builtin.git_commits)
nmap("<C-x>", builtin.command_history)
nmap("<leader>sr", builtin.resume)

nmap("<C-b>", function()
  builtin.git_branches({
    attach_mappings = function(_, map)
      map("i", "<c-d>", actions.git_delete_branch)
      return true
    end,
  })
end)

nmap("<leader>\\", function()
  builtin.grep_string({ default_text = vim.fn.expand("<cword>") })
end)

vmap("<leader>\\", function()
  builtin.grep_string({
    default_text = require("util.selection").get_visual_selection(),
  })
end)

require("telescope").load_extension("dir")
nmap("<C-\\>", "<cmd>Telescope dir live_grep<CR>")
