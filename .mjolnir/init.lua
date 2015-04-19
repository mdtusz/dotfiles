local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local tiling = require "mjolnir.tiling"
local hints = require "mjolnir.th.hints"

hotkey.bind({"cmd", "alt", "ctrl"}, "D", function()
  local win = window.focusedwindow()
  local f = win:frame()
  f.x = f.x + 10
  win:setframe(f)
end)

local mash = {"ctrl", "cmd"}

local function fullcenter(window)
  frame = window:screen():frame()
  frame.x = 0
  frame.y = 0
  frame.w = frame.w
  frame.h = frame.h
  window:setframe(frame)
end

hotkey.bind(mash, "l", function() tiling.cyclelayout() end)
hotkey.bind(mash, "j", function() tiling.cycle(1) end)
hotkey.bind(mash, "k", function() tiling.cycle(-1) end)
hotkey.bind(mash, "c", function() tiling.togglefloat(fullcenter) end)
hotkey.bind(mash, "space", function() tiling.promote() end)
hotkey.bind(mash, "e", function() hints.windowHints() end)