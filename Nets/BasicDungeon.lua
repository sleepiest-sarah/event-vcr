local captures = require('Captures') or vcrCaptures
local Net = require('Nets.Net') or vcrNet

vcrBasicDungeon = Net:new()

vcrBasicDungeon.name = "BasicDungeon"

vcrBasicDungeon.start = "ZONE_CHANGED_NEW_AREA"
vcrBasicDungeon.stop = "ZONE_CHANGED_NEW_AREA"
vcrBasicDungeon.filter = {
  ["ZONE_CHANGED_NEW_AREA"] = {captures.getInstanceInfo, captures.getMapDetailsPlayer},
  ["PLAYER_REGEN_DISABLED"] = {},
  ["PLAYER_REGEN_ENABLED"] = {},
  ["BOSS_KILL"] = {},
  ["ENCOUNTER_END"] = {}
  }

function vcrBasicDungeon:startCondition()
  return ({GetInstanceInfo()})[2] == "party"
end

function vcrBasicDungeon:stopCondition()
  return ({GetInstanceInfo()})[2] == "none"
end

return vcrBasicDungeon