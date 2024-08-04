return {
	{
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>p",
				function()
					require("conform").format()
				end,
				"Format the current buffer",
			},
		},
		opts = {
			default_format_opts = {
				quiet = false,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				sh = { "shfmt" },
				["*"] = { "typos" },
				ruby = { "typos", lsp_format = "first" },
			},
		},
	},
}
