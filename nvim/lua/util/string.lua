local M = {}

function M.camelcase(str)
  str = str.gsub(" " .. str, "%W%l", str.upper):sub(2)

  return str.gsub(str, "_", "")
end

return M
