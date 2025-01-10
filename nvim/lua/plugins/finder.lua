return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>fr", "<CMD>FzfLua resume<CR>", desc = "Resume finder" },
    { "<leader>ff", "<CMD>FzfLua files<CR>", desc = "Files" },
    { "<leader>fb", "<CMD>FzfLua buffers sort_mru=true sort_lastused=true<CR>", desc = "Buffers" },
    { "<leader>fe", "<CMD>FzfLua live_grep_glob<CR>", desc = "Grep" },
    { "<leader>fc", "<CMD>FzfLua command_history<CR>", desc = "Command history" },
    { "<leader>fw", "<CMD>FzfLua grep_cword<CR>", desc = "Find word" },
    { "<leader>fy", "<CMD>FzfLua grep_visual<CR>", desc = "Find selection", mode = "v" },
    { "<leader>gs", "<CMD>FzfLua git_stash<CR>", desc = "Git stashes" },
    { "<leader>gb", "<CMD>FzfLua git_branches<CR>", desc = "Git branches" },
  },
  opts = {},
  config = function()
    local fzf = require("fzf-lua")
    local actions = fzf.actions

    require("fzf-lua").setup({
      "border-fused",
      fzf_opts = { ["--layout"] = "default", ["--cycle"] = true },
      -- winopts = { preview = { delay = 50 } },
      keymap = {
        builtin = {
          true,
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          true,
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
        },
      },
      actions = {
        files = {
          ["enter"] = actions.file_edit_or_qf,
          ["ctrl-q"] = actions.file_sel_to_qf,
          ["alt-q"] = { fn = actions.file_edit_or_qf, prefix = "select-all+" },
        },
      },
      grep = {
        rg_glob_fn = function(query)
          local regex, flags = query:match("^(.-)%s%-%-(.*)$")
          -- If no separator is detected will return the original query
          return (regex or query), flags
        end,
      },
      buffers = {
        keymap = { builtin = { ["<C-d>"] = false } },
        actions = { ["ctrl-x"] = false, ["ctrl-d"] = { actions.buf_del, actions.resume } },
      },
      files = {
        prompt = "❯ ",
        cwd_prompt = false,
      },
      git = {
        branches = {
          cmd = "git branch",
        },
      },
      previewers = {
        builtin = {
          syntax_limit_b = -102400, -- 100KB limit on highlighting files
        },
      },
      defaults = {
        git_icons = false,
        file_icons = false,
        color_icons = false,
      },
    })
  end,
}
