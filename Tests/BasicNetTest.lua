require('Libs.LuaTesting.LuaTesting')

local ev = require('EventVcr')
local evf = require('Libs.WowEventFramework.WowEventFramework')
local table_utils = require('Libs.LuaCore.Utils.TableUtils')

local vcrBasicDungeon = require('Nets.BasicDungeon')

local lu = require('luaunit')

TestBasicNet = {}

local function getInstanceInfoNone()
  return "somewhere", "none"
end

function TestBasicNet:testNetRunsSuccessfully()
  ev.setActiveNet(vcrBasicDungeon)
  
  evf.sframe:OnEvent("ADDON_LOADED", "EventVCR")
  
  evf.sframe:OnEvent("ZONE_CHANGED_NEW_AREA")
  
  GetInstanceInfo = getInstanceInfoNone
  
  evf.sframe:OnEvent("ZONE_CHANGED_NEW_AREA")
  
  --this shouldn't be logged
  evf.sframe:OnEvent("PLAYER_REGEN_DISABLED")
  
  local reel = vReel[vcrBasicDungeon.name][1]
  lu.assertEquals(#reel, 12)
end

lu.LuaUnit.verbosity = lu.VERBOSITY_VERBOSE
lu.LuaUnit.run('TestBasicNet')