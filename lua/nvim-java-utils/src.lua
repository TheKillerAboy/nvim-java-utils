local xml = require("xmlreader")

local M = {}

function get_eclipse_mvn_project_file()
  local project_file = vim.fs.find('.project', {
    type = 'files',
  })

  if #project_file < 0 then
    return nil
  end

  return project_file[0];
end

function read_eclipse_mvn_project_file(fname)
  fhandle = io.open(fname, 'r')
  data = fhandle:read("*a")

  local r = assert(xmlreader.from_string(data));

  while(r.read()) do
    if(r:node_type() == 'element') then
      if(r:name() == "classpathentry") then
        r:move_to_next_attribute()
      end
    end
  end
end

function M.get_src_dir()
  vim.fn.getcwd()
end
