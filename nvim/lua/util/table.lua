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
