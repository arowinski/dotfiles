local utils = require('utils')

local ruby = {}
local snippet = { ruby = ruby }

local stop_shift = function(size)
  local width = vim.bo.shiftwidth

  return string.rep(' ', size * width)
end

function ruby.open(type)
  local path = vim.fn['ruby#class_name'](1)
  local size = #path

  local value = utils.reduce(path, '', function(acc, value, index)
    local width = vim.bo.shiftwidth
    local shift = string.rep(' ', width * (index - 1))

    if index == size then
      return acc .. shift  .. type .. " " .. value
    else
      return acc .. shift .. "module " .. value .. "\n"
    end
  end)

  return value .. "\n" .. stop_shift(size)
end

function ruby.close()
  local list = vim.fn['ruby#class_name'](1)
  local size = #list
  local width = vim.bo.shiftwidth

  return utils.reduce(list, '', function(acc, value, index)
    return acc .. string.rep(' ', (size - index) * width) .. "end\n"
  end)
end


return snippet;
