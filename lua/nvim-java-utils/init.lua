local M = {}

function M.build()
  local opts = {rockspec = 'nvim-java-utils-dev-1.rockspec'}
  require('nvim-java-utils.bootstrap').bootstrap(opts)
end


function M.remove()
  local opts = {rockspec = 'nvim-java-utils-dev-1.rockspec'}
  require('nvim-java-utils.bootstrap').uninstall(opts)
end

local function create_user_commd(logger, name, fnc, opts)
  logger:info(string.format("Adding User Commmand(:%s)", name))
  vim.api.nvim_create_user_command(
    name,
    function(_)
      logger:info(string.format("Calling Command(:%s)", name))
      fnc()
    end,
    opts
  )
end

function M.setup()
  local logger = require("nvim-java-utils.log").getLogger()
  local src = require("nvim-java-utils.src")

  logger:logLine(logger.INFO)
  logger:info("Setup nvim-java-utils")

  create_user_commd(
    logger,
    'JavaUtils',
    function()end,
    {nargs = 0}
  )
end

return M
