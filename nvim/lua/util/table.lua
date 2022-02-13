local M = {}

function M.merge(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end

  return t1
end

function M.map_with_index(fun, list)
  local acc = {}

  for index, name in ipairs(list) do
    table.insert(acc, fun(name, index))
  end

  return acc
end

return M
