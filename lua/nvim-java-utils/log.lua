local M = {}

require("logging.file")

function M.getLogFile()
  return '/var/log/nvim-java-utils.log'
end

local logger = logging.file.new {
  filename = M.getLogFile(),
}
logger:setLevel(logger.DEBUG)

function M.getLogger()
  return logger
end

function logger.logLine(self, level)
  if(level == nil) then
    level = self.level
  end
  self:log(level, "=================================================")
end

return M
