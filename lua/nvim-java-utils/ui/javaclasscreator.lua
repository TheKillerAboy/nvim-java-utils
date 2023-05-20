local Object = require("nui.object")
local Popup = require("nui.popup")
local Dropdown = require("nvim-java-utils.ui.dropdown")
local Label = require("nvim-java-utils.ui.label")
local Input = require("nvim-java-utils.ui.input")
local logger = require("nvim-java-utils.log").getLogger()

local JavaClassCreator = Object("JavaClassCreator")

function JavaClassCreator:_get_popup_obj_map_method()
  return function (popup_obj, mode, key, handler, opts, force)
    if(self.mapped_keys[key] == nil) then
      self.mapped_keys[key] = {}
    end

    table.insert(self.mapped_keys[key], handler)

    Popup.map(
      popup_obj,
      mode,
      key,
      function()
        logger:info("Calling Handler")
        for _, _handler in ipairs(self.mapped_keys[key]) do
          _handler()
        end
      end,
      opts,
      force
    )
  end
end

function JavaClassCreator:_get_popup_obj(options)
   local popup_obj = Popup{
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
    },
  }

  popup_obj.map = self:_get_popup_obj_map_method()

  return popup_obj
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


function JavaClassCreator:_get_classname_obj(options)
  local classname = Input("Classname")
  classname:set_parent(self.popup_obj, self:_get_next_linenr())
  return classname
end

function JavaClassCreator:init(options)
  self.linenr = 0

  self.mapped_keys = {}

  self.popup_obj = self:_get_popup_obj(options)
  self.src_obj = self:_get_src_obj(options)
  self.packages_obj = self:_get_package_obj(options)
  self.classname_obj = self:_get_classname_obj(options)
end

function JavaClassCreator:mount()
  self.popup_obj:mount()
  self.src_obj:mount()
  self.packages_obj:mount()
  self.classname_obj:mount()
end

return JavaClassCreator
