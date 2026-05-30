local function moveWindow(to)
  local win = hs.window.focusedWindow()
  if not win then
    return
  end

  local screen = win:screen()
  local frame = screen:frame()

  local layouts = {
    ["0,0_1x1"] = { x = frame.x, y = frame.y, w = frame.w / 2, h = frame.h / 2 },
    ["1,0_1x1"] = { x = frame.x + frame.w / 2, y = frame.y, w = frame.w / 2, h = frame.h / 2 },
    ["0,1_1x1"] = { x = frame.x, y = frame.y + frame.h / 2, w = frame.w / 2, h = frame.h / 2 },
    ["1,1_1x1"] = { x = frame.x + frame.w / 2, y = frame.y + frame.h / 2, w = frame.w / 2, h = frame.h / 2 },
    ["0,0_2x1"] = { x = frame.x, y = frame.y, w = frame.w, h = frame.h / 2 },
    ["0,1_2x1"] = { x = frame.x, y = frame.y + frame.h / 2, w = frame.w, h = frame.h / 2 },
    ["0,0_1x2"] = { x = frame.x, y = frame.y, w = frame.w / 2, h = frame.h },
    ["1,0_1x2"] = { x = frame.x + frame.w / 2, y = frame.y, w = frame.w / 2, h = frame.h },
    ["0,0_2x2"] = { x = frame.x, y = frame.y, w = frame.w, h = frame.h },
  }

  if to == "next_screen" then
    win:moveToScreen(screen:next())
    return
  end

  if to == "prev_screen" then
    win:moveToScreen(screen:previous())
    return
  end

  local target = layouts[to]
  if target then
    win:setFrame(target)
  end
end

local mediaTapCount = 0
local mediaTapTimer = nil

local function postSystemKey(key)
  hs.eventtap.event.newSystemKeyEvent(key, true):post()
  hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

local function findBuiltInOutput()
  return hs.fnutils.find(hs.audiodevice.allOutputDevices(), function(device)
    local uid = device:uid() or ""
    local name = device:name() or ""
    return uid:match("BuiltInSpeakerDevice") or name:match("Built%-in") or (name:match("MacBook") and name:match("Speaker"))
  end)
end

local function setDefaultOutput(device, label)
  if not device then
    hs.alert.show(label .. " not found")
    return
  end

  local ok, err = pcall(function()
    device:setDefaultOutputDevice()
  end)

  if ok then
    hs.alert.show(label)
  else
    hs.alert.show("Audio switch failed: " .. tostring(err))
  end
end

hs.urlevent.bind("move-window", function(_, params)
  moveWindow(params.to)
end)

hs.urlevent.bind("audio-output-toggle", function()
  local proxy = hs.audiodevice.findOutputByName("Proxy Audio Device")
  local builtIn = findBuiltInOutput()
  local current = hs.audiodevice.defaultOutputDevice()

  if current and proxy and current:uid() == proxy:uid() then
    setDefaultOutput(builtIn, builtIn and builtIn:name() or "Built-in speakers")
  else
    setDefaultOutput(proxy, "Proxy Audio Device")
  end
end)

hs.urlevent.bind("media-control", function(_, params)
  if params.key ~= "play_or_pause" then
    return
  end

  mediaTapCount = mediaTapCount + 1

  if mediaTapTimer then
    mediaTapTimer:stop()
  end

  mediaTapTimer = hs.timer.doAfter(0.3, function()
    local count = mediaTapCount
    mediaTapCount = 0
    mediaTapTimer = nil

    if count == 1 then
      postSystemKey("PLAY")
    elseif count == 2 then
      postSystemKey("NEXT")
    else
      postSystemKey("PREVIOUS")
    end
  end)
end)
