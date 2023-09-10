return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = { "Telescope" },
  keys = function()
    local builtin = require("telescope.builtin")

    return {
      { "<leader>ff", builtin.find_files, desc = "Find files" },
      { "<leader>fb", builtin.buffers, desc = "List buffers" },
      { "<leader>fe", builtin.live_grep, desc = "Live search" },
      { "<leader>fr", builtin.resume, desc = "Resume finder" },
      { "<leader>fc", builtin.command_history, desc = "List command history" },
      {
        "<leader>fw",
        function()
          builtin.grep_string({
            default_text = require("util.selection").get_visual_selection(),
          })
        end,
        mode = "v",
        desc = "Find selection",
      },
      {
        "<leader>fw",
        function()
          builtin.grep_string({ default_text = vim.fn.expand("<cword>") })
        end,
        desc = "Find word under cursor",
      },
      { "<leader>fy", builtin.registers, desc = "List registers" },
    }
  end,
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
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
    }
  end,
}
