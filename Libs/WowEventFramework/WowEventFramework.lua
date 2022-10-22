local event_map = {}
local secure_hooks = {}
local next_frame_callbacks = {}
local timer_callbacks = {}
local qevent_map = {}

local next_frame_queued = false
local timer_running = false

local function nextFrame()
  next_frame_queued = false
  
  local callbacks = {}
  
  --add currently registered callbacks to local list so callbacks can register new next frame callbacks without being affected by this function
  for id,c in pairs(next_frame_callbacks) do
    callbacks[id] = c
  end
  
  next_frame_callbacks = {}
  
  for id,c in pairs(callbacks) do
    c.callback(unpack(c.args))
  end
end

function quantify:registerNextFrame(callback, ...)
  local uuid = q:generateUUID()
  next_frame_callbacks[uuid] = {callback = callback, args = {...}}
  
  if (not next_frame_queued) then
    next_frame_queued = true
    C_Timer.After(0, nextFrame)
  end
end

local function timerFired()
  timer_running = false
  
  local exhausted = {}
  for id,c in pairs(timer_callbacks) do
    if (GetTime() - c.start > c.seconds) then
      table.insert(exhausted,id)            --remove after loop so iterator isn't affected
      c.callback(unpack(c.args))
    end
  end
  
  --remove expired timers
  for _,id in pairs(exhausted) do
    timer_callbacks[id] = nil
  end
  
end

function quantify:registerTimer(callback, seconds, ...)
  local uuid = q:generateUUID()  --for random access deletes
  timer_callbacks[uuid] = {callback = callback, seconds = seconds, args = {...}, start = GetTime()}
  
  if (not timer_running) then
    timer_running = true
    C_Timer.After(1, timerFired)
  end
end

function quantify:registerQEvent(event,func, ...)
  if (qevent_map[event] == nil) then
    qevent_map[event] = {}
  end

  table.insert(qevent_map[event], {func = func, args = {...}})  
end

function quantify:triggerQEvent(event, ...)
  if (qevent_map[event] ~= nil) then
    for _, f in pairs(qevent_map[event]) do

      if (#f.args > 0) then
        local args = {unpack(f.args)}
        for _,v in pairs({...}) do
          table.insert(args, v)
        end
        
        f.func(event, unpack(args))
      else
        f.func(event, ...)
      end
    end
  end  
end