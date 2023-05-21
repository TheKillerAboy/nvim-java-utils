local M = {}

function M.format(str, fmt)
  for key, value in pairs(fmt) do
    str = string.gsub(str, "{{%s*" .. key .. "%s*}}", value)
  end
  return str
end

return M
