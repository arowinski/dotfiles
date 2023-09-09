return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      {
        "g<space>",
        ":G<CR>",
        desc = "Open git window",
        silent = true,
      },
      {
        "<leader>gl",
        ":0Gclog -n1000<CR>",
        desc = "Open git log for current file",
        silent = true,
      },
    },
    config = function()
      vim.cmd([[
        autocmd Filetype gitcommit setlocal spell textwidth=72
        autocmd BufReadPost fugitive://* set bufhidden=delete
        autocmd Filetype fugitive nmap <buffer> czu 1czw
      ]])
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = {
        add = {
          hl = "GitSignsAdd",
          text = "+",
          numhl = "GitSignsAddNr",
          linehl = "GitSignsAddLn",
        },
        change = {
          hl = "GitSignsChange",
          text = "~",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "-",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "-",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "~",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      max_file_length = 5000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function()
        local nnoremap = require("util").nnoremap
        local gs = package.loaded.gitsigns
        local wk = require("which-key")

        wk.register({
          h = {
            s = { gs.stage_hunk, "Stage hunk" },
            u = { gs.reset_hunk, "Reset hunk" },
            U = { gs.undo_stage_hunk, "Undo staged hunk" },
            p = { gs.preview_hunk, "Preview hunk" },
            d = { gs.diffthis, "Open diff split" },
          },
          g = {
            w = { gs.stage_buffer, "Stage buffer" },
            r = { gs.reset_buffer, "Reset buffer" },
            R = { gs.reset_buffer_index, "Unstage buffer" },
          },
          t = {
            d = { gs.toggle_deleted, "Toggle deleted" },
          },
        }, { prefix = "<leader>" })

        nnoremap("]h", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        nnoremap("[h", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })
      end,
    },
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
}
