local Label = require("nvim-java-utils.ui.label")
local logger = require("nvim-java-utils.log").getLogger()

local Checkbox = Label:extend("Checkbox")

function Checkbox:_get_item_text()
  if self.active then
    return ""
  else
    return ""
  end
end

function Checkbox:init(title, options)
  if options.active == nil then
    options.active = false
  end

  self.active = options.active
  Checkbox.super.init(self, title, "")
end

function Checkbox:render()
  Checkbox.super.render(
    self,
    {
      item = {
        extmark = "Normal",
        offset = 1
      }
    }
  )
end

function Checkbox:get_active()
  return self.active
end

function Checkbox:_get_checkbox_map_settings()
  return {
    mode = 'n',
    key = '<Enter>',
    force = {noremap = true, nowait = true}
  }
end

function Checkbox:mount()
  self:render()

  local checkbox_map = self:_get_checkbox_map_settings()

  self.parent:map(
    checkbox_map.mode,
    checkbox_map.key,
    function()
      local cursor = vim.api.nvim_win_get_cursor(self.parent.winid)
      if(cursor[1] == self.linenr) then
        self.active = not self.active
        self:render()
      end
    end
  )
end

return Checkbox
