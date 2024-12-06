return {
	{ "tpope/vim-bundler", cmd = "Bopen" },
	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gcc", "gb", "gbc" },
		config = function(_, _)
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	{
		"gbprod/yanky.nvim",
		config = function()
			require("yanky").setup({})

			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

			vim.keymap.set("n", "<M-j>", "<Plug>(YankyCycleForward)")
			vim.keymap.set("n", "<M-k>", "<Plug>(YankyCycleBackward)")
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = { use_default_keymaps = false, max_join_length = 150 },
		keys = {
			{ "gJ", "<cmd>TSJJoin<CR>", desc = "Join block" },
			{ "gS", "<cmd>TSJSplit<CR>", desc = "Split block" },
			{ "gG", "<cmd>TSJToggle<CR>", desc = "Toggle block" },
		},
	},
	{
		"vim-test/vim-test",
		dependencies = { "christoomey/vim-tmux-runner" },
		keys = {
			{ "<leader>tt", "<CMD>TestNearest<CR>", desc = "Run nearest test" },
			{ "<leader>tf", "<CMD>TestFile<CR>", desc = "Run test file" },
			{ "<Leader>tl", "<CMD>TestLast<CR>", desc = "Run last test" },
		},
		init = function()
			vim.g["test#strategy"] = "vtr"
			vim.g["test#javascript#jest#executable"] = "yarn test"
		end,
	},
	{
		"ggandor/leap.nvim",
		event = "VeryLazy",
		config = function()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward-to)")
		end,
	},
	{
		"tpope/vim-projectionist",
		lazy = false,
		dependencies = { "tpope/vim-rails" },
		keys = {
			{ "<leader>av", ":AOV<CR>", "Open alternate in vsplit" },
			{ "<leader>rv", ":ROV<CR>", "Open related in vsplit" },
		},
		config = function()
			vim.cmd("source " .. vim.fn.expand("~/.config/nvim/vimscript/plugins/projections.vim"))

			vim.cmd([[
        autocmd User ProjectionistDetect :call projections#set_projections(&filetype)
        command! ROV silent only|RV
        command! AOV silent only|AV
      ]])
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		event = "VeryLazy",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		keys = {
			{
				"<leader>cc",
				function()
					local input = vim.fn.input("Ask copilot: ")

					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Ask copilot",
				mode = { "n", "v" },
			},
			{
				"<leader>co",
        "<CMD>CopilotChatOpen<CR>",
				desc = "Ask copilot",
				mode = { "n", "v" },
			},
		},
		opts = {
			selection = function(source)
				local select = require("CopilotChat.select")

        return select.visual(source) or select.buffer(source)
			end,
			prompts = {},
			window = {
				layout = "horizontal",
			},
      mappings = {
        reset = {
          normal ='<C-r>',
          insert = '<C-r>'
        },
      },
		},
	},
}
