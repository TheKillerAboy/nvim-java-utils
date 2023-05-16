local M = {}

local src = require("nvim-java-utils.src")

function M.setup()
  vim.notify("SETUP", vim.log.levels.INFO, nil)
  vim.api.nvim_create_user_command(
    'JavaUtilsGetSrc',
    function(_)
      src.get_src_dir()
    end,
    {nargs = 0}
  )
end

return M
