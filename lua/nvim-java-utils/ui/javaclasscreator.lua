local Object = require("nui.object")
local Popup = require("nui.popup")
local Dropdown = require("nvim-java-utils.ui.dropdown")
local Label = require("nvim-java-utils.ui.label")
local logger = require("nvim-java-utils.log").getLogger()

local JavaClassCreator = Object("JavaClassCreator")

function JavaClassCreator:_get_popup_obj(options)
   return Popup{
    relative = "editor",
    position = "50%",
    enter = true,
    focusable = true,
    size = options.size,
    border = {
     text = {
      top = "Java Class Creator"
     },
     style = "rounded"
    }
  }
end

function JavaClassCreator:_get_next_linenr()
  self.linenr = self.linenr + 1
  return self.linenr
end

function JavaClassCreator:_get_src_obj(options)
  local src = Label("Source", options.source)
  src:set_parent(self.popup_obj, self:_get_next_linenr())
  return src
end

function JavaClassCreator:_get_package_obj(options)
  local package = Dropdown("Package")
  package:set_parent(self.popup_obj, self:_get_next_linenr())
  package:set_items(options.packages)
  return package
end

function JavaClassCreator:init(options)
  self.linenr = 0

  self.popup_obj = self:_get_popup_obj(options)
  self.src_obj = self:_get_src_obj(options)
  self.packages_obj = self:_get_package_obj(options)
end

function JavaClassCreator:mount()
  self.popup_obj:mount()
  self.src_obj:mount()
  self.packages_obj:mount()
end

return JavaClassCreator
