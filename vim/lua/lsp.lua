local nvim_lsp = require('lspconfig')
local nmap = require('utils').nmap

-- LSP  Settings

nmap('<leader>p', "<cmd>lua vim.lsp.buf.formatting()<CR>")

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {virtual_text = false, underline = true, signs = true}
    )

-- Solargraph

nvim_lsp.solargraph.setup {
    root_dir = nvim_lsp.util.root_pattern(".git"),
    cmd = {"solargraph", "stdio"},
    filetypes = {"ruby"},
    flags = {debounce_text_changes = 150}
}
