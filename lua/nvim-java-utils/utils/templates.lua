local M = {}

local bootstrap = require('nvim-java-utils.bootstrap')
local string_utils = require('nvim-java-utils.utils.string')
local logger = require("nvim-java-utils.log").getLogger()

function M.load_template(tname)
  local plugin_dir = bootstrap.get_plugin_dir()
  local fpath = plugin_dir .. '/resources/templates/' .. string.gsub(tname, '%.temp$', '') .. '.temp'
  logger:info("Load Template: " .. fpath)

  local fileh = io.open(fpath, 'r')
  io.input(fileh)
  local template_data = io.read("*all")
  io.close(fileh)

  return template_data
end

function M.load_template_and_format(tname, fmt)
  return string_utils.format(M.load_template(tname), fmt)
end

return M
