return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  cmd = { "Telescope" },
  keys = function()
    local builtin = require("telescope.builtin")

    return {
      { "<leader>ff", builtin.find_files, desc = "Find files" },
      { "<leader>fb", builtin.buffers, desc = "List buffers" },
      { "<leader>fr", builtin.resume, desc = "Resume finder" },
      { "<leader>fc", builtin.command_history, desc = "List command history" },
      {
        "<leader>fe",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live search",
      },
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
    local lga_actions = require("telescope-live-grep-args.actions")

    return {
      defaults = {
        preview = {
          filesize_limit = 0.1, -- MB
          highlight_limit = 0.05,
        },
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
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-m>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
        },
      },
    }
  end,
  config = function(_, options)
    local telescope = require("telescope")

    telescope.setup(options)
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
}
