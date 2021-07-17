local utils = {}

function utils.reduce(list, acc, fn)
  for k, v in ipairs(list) do acc = fn(acc, v, k) end

  return acc
end

return utils;
