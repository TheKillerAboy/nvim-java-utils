local Label = require("nvim-java-utils.ui.label")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local logger = require("nvim-java-utils.log").getLogger()

local Dropdown = Label:extend("NuiDropdown")

function Dropdown:_get_item_text()
  if self.selected_item_index > 0 and self.selected_item_index <= #self.items then
    return self.items[self.selected_item_index]
  end
  return ""
end

function Dropdown:_get_menu_lines(width)
  local lines = {}

  for _, item in pairs(self.items) do
    table.insert(lines, Menu.item(string.rep(" ", width - string.len(item)) .. item))
  end

  return lines
end

function Dropdown:_get_menu_obj(title_obj, item_obj)
  return Menu(
    {
      relative = {
        type = 'editor',
        winid = self.parent.winid
      },
      position = {
        row = self.parent._.position.row + self.linenr - 1,
        col = self.parent._.position.col + title_obj:length()
      },
      size = {
        height = #self.items,
        width = item_obj:length()
      }
    },
    {
      lines = self:_get_menu_lines(item_obj:length()),
      on_submit = function(item)
        self.selected_item_index = self:get_index(item)
        self:render()
      end
    }
  )
end

function Dropdown:get_index(item_meta)
  local item = string.gsub(item_meta.text, " +(.*)", "%1")

  for i, v in pairs(self.items) do
    if item == v then
      return i
    end
  end
  return error("Out of range")
end

function Dropdown:set_items(items)
  self.items = items
end

function Dropdown:init(title)
  Dropdown.super.init(self, title, "")
end

function Dropdown:mount()
  local title_obj, item_obj = self:render()

  local menu_obj = self:_get_menu_obj(title_obj, item_obj)

  logger:debug("Menu Object Metadata: " .. vim.inspect(menu_obj._))

  local menu_map_settings = self:_get_menu_map_settings()

  self.parent:map(
    menu_map_settings.mode,
    menu_map_settings.key,
    function()
      local cursor = vim.api.nvim_win_get_cursor(self.parent.winid)
      if(cursor[1] == self.linenr) then
        menu_obj:mount()
        if self.selected_item_index > 0 then
          vim.api.nvim_win_set_cursor(menu_obj.winid, {self.selected_item_index, 0})
        end
      end
    end,
    menu_map_settings.force
  )

  self.parent:on(
    event.BufLeave,
    function()
      self:unmount()
    end
  )
  logger:info("Dropdown Mount")
end

function Dropdown:unmount()
  local menu_map_settings = self:_get_menu_map_settings()
  self.parent:unmap(
    menu_map_settings.mode,
    menu_map_settings.key,
    menu_map_settings.force
  )
  logger:info("Dropdown Unmount")
end

return Dropdown
