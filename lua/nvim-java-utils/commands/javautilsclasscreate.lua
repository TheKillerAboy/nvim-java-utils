local M = {}

local xml2lua = require("xml2lua")
local logger = require("nvim-java-utils.log").getLogger()
local JavaClassCreator = require("nvim-java-utils.ui.javaclasscreator")
local template_utils = require("nvim-java-utils.utils.templates")

local function get_xml_handler()
  if package.loaded['xmlhandler.tree'] ~= nil then
    package.loaded['xmlhandler.tree'] = nil
  end
  return require('xmlhandler.tree')
end

local function from_package_to_path(package)
  return string.gsub(package, "%.", "/")
end

local function from_path_to_package(package, source)
  if source ~= nil then
    package = string.gsub(package, "^" .. source, "")
  end
  return string.gsub(package, "/", ".")
end

local function get_classpath_file()
  local files = vim.fs.find('.classpath', { type = 'file' })
  return files[1]
end

local function get_source_from_classpath_file(classpath_file)
  local fileh = io.open(classpath_file, 'r')

  io.input(fileh)
  local xml_data = io.read("*all")
  io.close(fileh)

  local xml_handler = get_xml_handler()
  local xml_parser = xml2lua.parser(xml_handler)
  xml_parser:parse(xml_data)

  logger:debug("XML Data: " .. xml_data)

  for _, entry in pairs(xml_handler.root.classpath.classpathentry) do
    local attrs = entry._attr
    if(attrs.kind == 'src' and attrs.output == 'target/classes' and attrs.excluding == nil) then
      local source = vim.fn.getcwd() .. '/' .. attrs.path
      logger:info("Source: " .. source)
      return source
    end
  end
end

local function get_source()
  local classpath_file = get_classpath_file()
  return get_source_from_classpath_file(classpath_file)
end

local function get_packages(source)
  local packages_set = {}

  for name, type in vim.fs.dir(source, { depth = math.huge }) do
    if type == "directory" then
      local package = from_path_to_package(name, source)
      logger:debug(string.format("Package(%s)", package))
      packages_set[package] = true
    end
  end

  local packages = {}

  for key, _ in pairs(packages_set) do
    table.insert(packages, key)
  end

  logger:debug("Packages: " .. vim.inspect(packages))

  return packages
end

local function get_class_java_path(source, package, classname)
  return source .. '/' .. from_package_to_path(package) .. '/' .. classname .. '.java'
end

local function write_class_java(path, data)
  local fh = io.open(path, 'w')
  io.output(fh)
  io.write(data)
  io.close(fh)
end

local function get_handle(source)
  return function (package, classname, opts)
    local class_java_path = get_class_java_path(source, package, classname)
    local class_data = template_utils.load_template_and_format(
      'javaclass.temp',
      {
        package = package,
        classname = classname
      }
    )

    logger:info("Saving to " .. class_java_path)

    write_class_java(class_java_path, class_data)

    if(opts.openfile) then
      vim.cmd(":edit " .. class_java_path)
      -- TODO: focus currectly
      -- local wins = vim.api.nvim_list_wins()
      -- logger:info(vim.inspect(wins))
      -- for _, win in ipairs(wins) do
      --   local win_path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
      --   logger:info(win_path)
      --   if win_path == class_java_path then
      --     logger:info("Setting " .. win_path)
      --     vim.api.nvim_set_current_win(win)
      --   end
      -- end
    end
  end
end

function M.command()
  local source = get_source()
  local packages = get_packages(source)
  local handle = get_handle(source)

  local javaClassCreator = JavaClassCreator{
    packages = packages,
    source = source,
    handle = handle
  }

  javaClassCreator:mount()
end

return M
