local Label = require("nvim-java-utils.ui.label")
local Popup = require("nui.popup")
local logger = require("nvim-java-utils.log").getLogger()

local Input = Label:extend("NuiInput")

function Input:_get_input_obj(title_obj, item_obj)
  return Popup{
    enter = true,
    focusable = true,
    relative = "editor",
    position = {
      row = self.parent._.position.row + self.linenr - 1,
      col = self.parent._.position.col + title_obj:length()
    },
    size = {
      width = item_obj:length(),
      height = 1
    },
    buf_options = {
      modifiable = true,
      readonly = false
    }
  }
end

function Input:init(title)
  Input.super.init(self, title, "")
end

function Input:_get_input_map_settings()
  return {
    key = '<Enter>',
    force = {noremap = true, nowait = true}
  }
end

function Input:mount()
  local title_obj, item_obj = self:render()

  local input_obj = self:_get_input_obj(title_obj, item_obj)

  local input_map_settings = self:_get_input_map_settings()

  self.parent:map(
    'n',
    input_map_settings.key,
    function()
      local cursor = vim.api.nvim_win_get_cursor(self.parent.winid)
      if(cursor[1] == self.linenr) then
        logger:info("Input popup mount")
        input_obj:mount()
        input_obj:show()
        vim.api.nvim_buf_set_lines(input_obj.bufnr, 0, 1, true, { self.item })
        vim.cmd("startinsert")
        vim.api.nvim_win_set_cursor(input_obj.winid, {1, string.len(self.item) + 1})
      end
    end,
    input_map_settings.force
  )

  input_obj:map(
    'i',
    '<Enter>',
    function()
      logger:info("Input popup unmount")
      local text = vim.api.nvim_buf_get_lines(input_obj.bufnr, 0, 1, true)
      input_obj:hide()
      if #text == 0 then
        self.item = ""
      else
        self.item = text[1]
      end
      vim.cmd("stopinsert")
      self:render()
    end,
    input_map_settings.force
  )

  input_obj:map(
    'i',
    '<Esc>',
    function()
      logger:info("Input popup unmount")
      input_obj:hide()
      vim.cmd("stopinsert")
    end,
    input_map_settings.force
  )
end

return Input
