local function lsp_symbol()
  local exclude = {
    ["terminal"] = true,
    ["toggleterm"] = true,
    ["prompt"] = true,
    ["NvimTree"] = true,
    ["help"] = true,
  } -- Ignore float windows and exclude filetype
  if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
    return "ignore"
  else
    local ok, lspsaga = pcall(require, "lspsaga.symbolwinbar")
    local sym
    if ok then
      sym = lspsaga.get_symbol_node()
    end

    local win_val = ""

    if sym ~= nil then
      win_val = win_val .. sym
    end

    return win_val
  end
end

return lsp_symbol
