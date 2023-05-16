local M = {}

local xml2lua = require("xml2lua")

function get_eclipse_mvn_project_file()
  local project_file = vim.fs.find({'.project'}, {
    type = 'file',
  })

  if #project_file < 1 then
    return nil
  end

  return project_file[1]
end

function read_eclipse_mvn_project_file(fname)
   vim.notify(fname, vim.log.levels.INFO, nil)
end

function M.get_src_dir()
  return read_eclipse_mvn_project_file(get_eclipse_mvn_project_file())
end

return M
