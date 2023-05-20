local M = {}

local xml2lua = require("xml2lua")
local xml_handler = require("xmlhandler.tree")
local xml_parser = xml2lua.parser(xml_handler)
local logger = require("nvim-java-utils.log").getLogger()
local Popup = require("nui.popup")
local Dropdown = require("nvim-java-utils.ui.dropdown")
local JavaClassCreator = require("nvim-java-utils.ui.javaclasscreator")

local function get_eclipse_mvn_classpath_file()
  local classpath_file = vim.fs.find({'.classpath'}, {
    type = 'file',
  })

  if #classpath_file < 1 then
    return nil
  end

  return classpath_file[1]
end

local function read_eclipse_mvn_classpath_file(fname)
  local handler = io.open(fname, "r")
  io.input(handler)
  local data = io.read("all*")
  io.close(handler)

  -- logger:debug(data)

  xml_parser:parse(data)

  for _, entry in pairs(xml_handler.root.classpath.classpathentry) do
    local attrs = entry._attr
    if(attrs.kind == 'src' and attrs.output == 'target/classes' and attrs.excluding == nil) then
      return attrs.path
    end
  end
end

function M.get_src_dir()
  classpath_file = get_eclipse_mvn_classpath_file()

  logger:info(string.format("Found Classpath File(%s)", classpath_file))

  java_source = read_eclipse_mvn_classpath_file(classpath_file)

  logger:info(string.format("Found Java Source(%s)", java_source))
end

function M.class()
  local javaClassCreator = JavaClassCreator{
    size = {
      width = 40,
      height = 5
    },
    packages = {
      "za",
      "za.co",
      "za.co.shoprite",
      "za.co.shoprite.awpexec",
      "za.co.shoprite.awpexec.command"
    },
    source = "/src/main/java",
    create_class = function ( package, classname )
      vim.notify("Creating Class " .. classname .. " in package " .. package)
    end
  }

  javaClassCreator:mount()
end

return M
