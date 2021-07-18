require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})

require("trouble").setup({
    position = "bottom",
    height = 10,
    width = 50,
    icons = true,
    mode = "lsp_workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    action_keys = {
        close = "q",
        cancel = "<esc>",
        refresh = "r",
        jump = {"<cr>", "g"},
        open_split = { "<c-x>" },
        open_vsplit = { "<c-v>" },
        jump_close = {"o"},
        toggle_mode = "m",
        toggle_preview = "P",
        hover = "K",
        preview = "p",
        previous = "k",
        next = "j"
    },
    indent_lines = true,
    auto_preview = true,
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    }
})

-- Signs fix

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

U.nmap('<leader>e', "<cmd>TroubleToggle<cr>")

U.nmap('[r', '<cmd>lua vim.lsp.diagnostic.goto_prev({enable_popup = false})<CR>')
U.nmap(']r', '<cmd>lua vim.lsp.diagnostic.goto_next({enable_popup = false})<CR>')

vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {virtual_text = false, underline = true, signs = true}
    )

