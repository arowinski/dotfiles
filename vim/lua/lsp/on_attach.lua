return function(client, _)
  local function buf_map(lhs, rhs)
    U.buf_nmap(lhs, '<cmd>lua  ' .. rhs .. '<CR>')
  end

  require'lsp_signature'.on_attach({ use_lspsaga = true })

  buf_map('gD', 'vim.lsp.buf.declaration()')
  buf_map('gd', 'vim.lsp.buf.definition()')
  buf_map('gt', 'vim.lsp.buf.references()')

  buf_map('K', "require'lspsaga.hover'.render_hover_doc()")
  buf_map('gh', "require'lspsaga.provider'.preview_definition()")
  buf_map('gs', "require('lspsaga.signaturehelp').signature_help()")
  buf_map('<Leader>d', "require'lspsaga.diagnostic'.show_line_diagnostics()")
  buf_map('<C-u>', "require('lspsaga.action').smart_scroll_with_saga(1)")
  buf_map('<C-d>', "require('lspsaga.action').smart_scroll_with_saga(-1)")
  U.buf_nmap('<C-a>', "<cmd>Lspsaga code_action<cr>")

  -- buf_map('K', "vim.lsp.buf.hover()")
  -- buf_map('gs', "vim.lsp.buf.signature_help()")
  -- buf_map('<Leader>d', "vim.lsp.diagnostic.show_line_diagnostics()")

  if client.resolved_capabilities.document_range_formatting then
    U.buf_vmap("<Leader>p", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
  end
end
