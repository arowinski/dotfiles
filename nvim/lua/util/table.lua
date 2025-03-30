local M = {}

function M.map_with_index(fun, list)
  local acc = {}

  for index, name in ipairs(list) do
    table.insert(acc, fun(name, index))
  end

  return acc
end

function M.concat(t, ...)
  local new = { unpack(t) }
  for _, v in ipairs({ ... }) do
    for _, vv in ipairs(v) do
      new[#new + 1] = vv
    end
  end
  return new
end

return M
