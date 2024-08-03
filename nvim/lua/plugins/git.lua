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
		keys = {
			{ "<leader>hs", "<CMD>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
			{ "<leader>hu", "<CMD>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
			{ "<leader>hU", "<CMD>Gitsigns undo_stage_hunk<CR>", desc = "Undo staged hunk" },
			{ "<leader>hp", "<CMD>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
			{ "<leader>hd", "<CMD>Gitsigns diffthis<CR>", desc = "Open diff split" },
			{ "<leader>gw", "<CMD>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
			{ "<leader>gr", "<CMD>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
			{ "<leader>gR", "<CMD>Gitsigns reset_buffer_index<CR>", desc = "Unstage buffer" },
			{ "<leader>td", "<CMD>Gitsigns toggle_deleted<CR>", desc = "Toggle deleted" },
			{ "]c", "<CMD>Gitsigns next_hunk<CR>", desc = "Next hunk" },
			{ "[c", "<CMD>Gitsigns prev_hunk<CR>", desc = "Prev hunk" },
		},
		opts = {
			max_file_length = 5000,
		},
	},
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
}
