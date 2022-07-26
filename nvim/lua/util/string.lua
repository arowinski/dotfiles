local M = {}

function M.camelcase(str)
  str = str.gsub(" " .. str, "%W%l", str.upper):sub(2)

  return str.gsub(str, "_", "")
end

function M.replace(str, what, with)
  -- escape pattern
  what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1")
  -- escape replacement
  with = string.gsub(with, "[%%]", "%%%%")

  return string.gsub(str, what, with)
end

return M
