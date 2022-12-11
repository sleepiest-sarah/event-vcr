require('Libs.LuaTesting.LuaTesting')

local ev = require('EventVcr')
local evf = require('Libs.WowEventFramework.WowEventFramework')
local table_utils = require('Libs.LuaCore.Utils.TableUtils')

local vcrKeystone = require('Nets.KeystoneDungeon')

local lu = require('luaunit')

local function getInstanceInfoNone()
  return "somewhere", "none"
end

local function getCombatLogUnitDied()
  return os.time(), "UNIT_DIED", nil, nil, nil, nil, nil, nil, nil, 0x0501
end

TestKeystoneNet = {}

function TestKeystoneNet:testKeystoneNet()
  ev.setActiveNet(vcrKeystone)
  
  evf.sframe:OnEvent("ADDON_LOADED", "EventVCR")
  
  evf.sframe:OnEvent("BOSS_KILL") -- shouldn't get logged
  
  evf.sframe:OnEvent("CHALLENGE_MODE_START", 1)
  
  evf.sframe:OnEvent("BOSS_KILL", 1, "daBoss")
  
  evf.sframe:OnEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
  
  evf.sframe:OnEvent("PLAYER_REGEN_ENABLED")
  
  evf.sframe:OnEvent("COMBAT_LOG_EVENT_UNFILTERED")
  
  CombatLogGetCurrentEventInfo = getCombatLogUnitDied
  
  evf.sframe:OnEvent("COMBAT_LOG_EVENT_UNFILTERED")
  
  evf.sframe:OnEvent("CHAT_MSG_LOOT")
  
  evf.sframe:OnEvent("CHALLENGE_MODE_COMPLETED")
  
  GetInstanceInfo = getInstanceInfoNone
  
  evf.sframe:OnEvent("ZONE_CHANGED_NEW_AREA")
  
  evf.sframe:OnEvent("PLAYER_REGEN_ENABLED")  --shouldn't get logged
  
  local reel = vReel[vcrKeystone.name][1]
  lu.assertEquals(#reel, 37)
  lu.assertEquals(reel[1][2], "CHALLENGE_MODE_START")
  lu.assertEquals(reel[37][2].func, "C_ChallengeMode.GetCompletionInfo")
end

lu.LuaUnit.verbosity = lu.VERBOSITY_VERBOSE
lu.LuaUnit.run('TestKeystoneNet')