local logger = require("nvim-java-utils.log").getLogger()
local Object = require("nui.object")
local Text = require("nui.text")

local Button = Object("Button")

function Button:_justify_text(text, justify)
  if justify == nil then
    justify = 'left'
  end

  local whitespace_len = self.parent._.size.width - string.len(text)

  if justify == 'left' then
    return text .. string.rep(" ", whitespace_len)
  elseif justify == 'middle' then
    local left = math.floor(whitespace_len / 2)
    local right = whitespace_len - left

    return string.rep(" ", left) .. text .. string.rep(" ", right)
  elseif justify == 'right' then
    return string.rep(" ", whitespace_len) .. text
  end
end

function Button:_get_text_obj()
  local text = self:_justify_text(self.title, self.options.justify)

  return Text(text, 'Visual')
end

function Button:set_parent(parent, linenr)
  self.parent = parent
  self.linenr = linenr
end

function Button:init(title, options)
  self.title = title

  if options == nil then
    options = {}
  end

  self.options = options
  self.handle = nil

  self.parent = nil
  self.linenr = 0
end

function Button:set_handle(handle)
  self.handle = handle
end

function Button:_ensure_buf_ready_for_render()
  local line_buf = vim.api.nvim_buf_get_lines(self.parent.bufnr, self.linenr - 1, self.linenr, false)
  if(#line_buf) then
    vim.api.nvim_buf_set_lines(self.parent.bufnr, self.linenr - 1, self.linenr, false,{string.rep(" ", self.parent._.size.width)})
  end
end

function Button:render()
  self:_ensure_buf_ready_for_render()

  local text_obj = self:_get_text_obj()
  text_obj:render(self.parent.bufnr, self.parent.ns_id, self.linenr, 0)
  return text_obj
end

function Button:mount()
  self:render()

  self.parent:map(
    'n',
    '<Enter>',
    function()
      local cursor = vim.api.nvim_win_get_cursor(self.parent.winid)
      if(cursor[1] == self.linenr) then
        self.handle()
      end
    end,
    {noremap = true, nowait = true}
  )
end

function Button:unmount()
end

return Button
