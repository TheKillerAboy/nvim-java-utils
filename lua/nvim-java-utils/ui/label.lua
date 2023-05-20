local Object = require("nui.object")
local Text = require("nui.text")
local logger = require("nvim-java-utils.log").getLogger()

local Label = Object("NuiLabel")

function Label:_get_title_text()
  if string.len(self.title) == 0 then
    return ""
  end
  return self.title .. ':'
end

function Label:_get_item_text()
  return self.item
end

function Label:_get_title_obj()
  return Text(self:_get_title_text())
end

function Label:_get_item_obj(title_obj)
  local item_text = self:_get_item_text()
  local whitespace_len = self.parent._.size.width - string.len(item_text) - title_obj:length()
  local final_item_text = string.rep(" ", whitespace_len) .. item_text

  return Text(final_item_text, "Folded")
end

function Label:set_parent(parent, linenr)
  self.parent = parent
  self.linenr = linenr
end

function Label:init(title, item)
  self.title = title
  self.item = item

  self.parent = nil
  self.linenr = 0
end

function Label:_ensure_buf_ready_for_render()
  local line_buf = vim.api.nvim_buf_get_lines(self.parent.bufnr, self.linenr - 1, self.linenr, false)
  if(#line_buf) then
    vim.api.nvim_buf_set_lines(self.parent.bufnr, self.linenr - 1, self.linenr, false,{string.rep(" ", self.parent._.size.width)})
  end
end

function Label:render()
  local title_obj = self:_get_title_obj()
  local item_obj = self:_get_item_obj(title_obj)

  self:_ensure_buf_ready_for_render()

  if title_obj:length() > 0 then
    title_obj:render(self.parent.bufnr, self.parent.ns_id, self.linenr, 0)
  end
  item_obj:render(self.parent.bufnr, self.parent.ns_id, self.linenr, title_obj:length())

  return title_obj, item_obj
end

function Label:mount()
  self:render()
end

function Label:unmount()
end

return Label
