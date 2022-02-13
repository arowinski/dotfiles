local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<ESC>"] = actions.close,
        ["<M-q>"] = trouble.open_with_trouble,
        ["<C-q>"] = trouble.open_selected_with_trouble,
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
  vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "-u",
  },
})

require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
local nmap = require("util").nmap

nmap("<C-p>", builtin.find_files)
nmap("<C-y>", builtin.registers)
nmap("\\", builtin.live_grep)
nmap("<C-q>", builtin.buffers)
nmap("<leader>gs", builtin.git_stash)
nmap("<C-g>", builtin.git_commits)
nmap("<C-x>", builtin.command_history)
