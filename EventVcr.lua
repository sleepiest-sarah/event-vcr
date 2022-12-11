local ef = require('Libs.WowEventFramework.WowEventFramework') or WowEventFramework
local table_utils = require('Libs.LuaCore.Utils.TableUtils') or LCTableUtils

eventVcr = {}

local ev = eventVcr

local active_net = vcrLevelChronicle
local net_started = false

local reel

local function logEvent(event, ...)
  table.insert(reel, {time(), event, ...})
end

local function logFunction(capture)
  table.insert(reel, {time(), capture})
end

local function captureEvent(event, ...)
  if (not net_started and event == active_net.start and active_net:startCondition()) then
    net_started = true
    
    vReel = vReel or {}
    vReel[active_net.name] = vReel[active_net.name] or {}
    reel = {}
    table.insert(vReel[active_net.name], reel)
  end
  
  if (net_started and active_net.filter[event] and active_net:eventCondition(event, ...)) then
    logEvent(event, {...})
    
    for _,v in ipairs(active_net.filter[event]) do
      local res = {v()}
      for _,capture in ipairs(res) do
        logFunction(capture)
      end
    end
  end
  
  if (net_started and event == active_net.stop and active_net:stopCondition()) then
    net_started = false
  end
end

local function loadAddon(event, addon)
  if (event == "ADDON_LOADED" and addon == "EventVCR") then
    
    local events = table_utils.getKeys(active_net.filter)
    
    if (not table_utils.contains(events, active_net.start)) then
      table.insert(events, active_net.start)
    end
    
    if (not table_utils.contains(events, active_net.stop)) then
      table.insert(events, active_net.stop)
    end
    
    ef.registerAllEvents(events, captureEvent)
  end
end

function ev.setActiveNet(net)
  active_net = net
end

ef.registerEvent("ADDON_LOADED", loadAddon)

return ev