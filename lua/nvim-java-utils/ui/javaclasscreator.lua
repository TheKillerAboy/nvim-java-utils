local Object = require("nui.object")
local Popup = require("nui.popup")
local Dropdown = require("nvim-java-utils.ui.dropdown")
local Label = require("nvim-java-utils.ui.label")
local Input = require("nvim-java-utils.ui.input")
local Button = require("nvim-java-utils.ui.button")
local Checkbox = require("nvim-java-utils.ui.checkbox")
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

function JavaClassCreator:_get_open_obj(options)
  local open = Checkbox("Open", { active = true })
  open:set_parent(self.popup_obj, self:_get_next_linenr())
  return open
end

function JavaClassCreator:_get_confirm_obj(options)
  local confirm = Button("Confirm", { justify = 'middle' })
  confirm:set_parent(self.popup_obj, self:_get_next_linenr())
  confirm:set_handle(
    function()
      local package = self.packages_obj:get_selected_item()
      local classname = self.classname_obj:get_input()
      local openfile = self.open_obj:get_active()

      if package == nil then
        vim.notify("No package was selected", vim.log.levels.ERROR)
        return
      end

      if classname == "" then
        vim.notify("No classname was entered", vim.log.levels.ERROR)
        return
      end

      options.handle(
        package,
        classname,
        {
          openfile = openfile
        }
      )

      self:unmount()
    end
  )
  return confirm
end

function JavaClassCreator:init(options)
  self.linenr = 0

  options.size = {
    width = "40%",
    height = 5
  }

  self.mapped_keys = {}

  self.popup_obj = self:_get_popup_obj(options)
  self.src_obj = self:_get_src_obj(options)
  self.packages_obj = self:_get_package_obj(options)
  self.classname_obj = self:_get_classname_obj(options)
  self.open_obj = self:_get_open_obj(options)
  self.confirm_obj = self:_get_confirm_obj(options)
end

function JavaClassCreator:mount()
  self.popup_obj:mount()
  self.src_obj:mount()
  self.packages_obj:mount()
  self.classname_obj:mount()
  self.open_obj:mount()
  self.confirm_obj:mount()

  self.popup_obj:map(
    'n',
    '<Esc>',
    function()
      self:unmount()
    end,
    {noremap = true, nowait = true}
  )
end

function JavaClassCreator:unmount()
  self.src_obj:unmount()
  self.packages_obj:unmount()
  self.classname_obj:unmount()
  self.open_obj:unmount()
  self.confirm_obj:unmount()
  self.popup_obj:unmount()
end

return JavaClassCreator
