local M = {}

function M.setup(lsp, options)
  lsp.solargraph.setup(vim.tbl_extend("force", options, {
    root_dir = lsp.util.root_pattern(".git"),
    cmd = { "solargraph", "stdio" },
    settings = { solargraph = { useBundler = true } },
    filetypes = { "ruby" },
    flags = { debounce_text_changes = 150 },
  }))
end

return M
