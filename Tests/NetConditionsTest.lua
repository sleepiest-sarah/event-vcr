require('Libs.LuaTesting.LuaTesting')

local ev = require('EventVcr')
local evf = require('Libs.WowEventFramework.WowEventFramework')
local table_utils = require('Libs.LuaCore.Utils.TableUtils')

local vcrLeveling = require('Nets.Leveling')

local lu = require('luaunit')

local function getCombatLogPartyKill()
  return os.time(), "PARTY_KILL"
end

TestNetConditions = {}

function TestNetConditions:testNetWithConditions()
  ev.setActiveNet(vcrLeveling)
  
  evf.sframe:OnEvent("ADDON_LOADED", "EventVCR")
  
  evf.sframe:OnEvent("PLAYER_LOGIN")
  
  evf.sframe:OnEvent("CHAT_MSG_OPENING", "Sam performs mining") --this one shouldn't get logged
  
  evf.sframe:OnEvent("COMBAT_LOG_EVENT_UNFILTERED") --this one shouldn't get logged
  
  CombatLogGetCurrentEventInfo = getCombatLogPartyKill
  
  evf.sframe:OnEvent("COMBAT_LOG_EVENT_UNFILTERED")
  
  evf.sframe:OnEvent("CHAT_MSG_OPENING", "You perform mining")
  
  evf.sframe:OnEvent("PLAYER_LOGOUT")
  
  local reel = vReel[vcrLeveling.name][1]
  lu.assertEquals(#reel, 14)
  lu.assertEquals(reel[13][2], "CHAT_MSG_OPENING")
end

lu.LuaUnit.verbosity = lu.VERBOSITY_VERBOSE
lu.LuaUnit.run('TestNetConditions')