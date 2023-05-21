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
  local javautilscreateclass = require("nvim-java-utils.commands.javautilsclasscreate")

  logger:logLine(logger.INFO)
  logger:info("Setup nvim-java-utils")

  create_user_commd(
    logger,
    'JavaUtilsCreateClass',
    javautilscreateclass.command,
    {nargs = 0}
  )
end

return M
