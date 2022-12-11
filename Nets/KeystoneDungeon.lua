local c = require('Captures') or vcrCaptures
local Net = require('Nets.Net') or vcrNet


vcrKeystoneDungeon = Net:new()

vcrKeystoneDungeon.name = "Keystone"

vcrKeystoneDungeon.start = "CHALLENGE_MODE_START"
vcrKeystoneDungeon.stop = "ZONE_CHANGED_NEW_AREA"
vcrKeystoneDungeon.filter = {
  ["CHALLENGE_MODE_START"] = {c.getInstanceInfo, c.getMapDetailsPlayer, c.getGroupType, c.getPartyMembers, c.getKeystoneInfo, c.getActiveChallengeMapId},
  ["CHALLENGE_MODE_RESET"] = {},
  ["CHALLENGE_MODE_COMPLETED"] = {c.getKeystoneCompletionInfo},
  ["BOSS_KILL"] = {},
  ["ENCOUNTER_START"] = {},
  ["ENCOUNTER_END"] = {},
  ["PLAYER_DEAD"] = {},
  ["COMBAT_LOG_EVENT_UNFILTERED"] = {c.getPartyStatus},
  ["GROUP_ROSTER_UPDATE"] = {c.getGroupType, c.getPartyMembers},
  ["ROLE_CHANGED_INFORM"] = {c.getGroupType, c.getPartyMembers},
  ["PLAYER_REGEN_ENABLED"] = {c.getKeystoneCompletionInfo},
  ["CHALLENGE_MODE_MEMBER_INFO_UPDATED"] = {},
  ["CHALLENGE_MODE_MAPS_UPDATE"] = {c.getActiveChallengeMapId},
  ["CHALLENGE_MODE_DEATH_COUNT_UPDATED"] = {c.getDeathCount},
  ["MYTHIC_PLUS_NEW_WEEKLY_RECORD"] = {},
  ["CHAT_MSG_LOOT"] = {}
}

function vcrKeystoneDungeon:eventCondition(event)
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local timestamp, combatLogEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
    
    if (combatLogEvent == "UNIT_DIED") then
      local affiliation = bit.band(destFlags, 0xf)
      local type_controller = bit.band(destFlags, 0xff00)

      return type_controller == 0x0500 and (affiliation == 1 or affiliation == 2 or affiliation == 4) --player-controlled player and self/party/raid
    end
    
    return false
  end
  
  return true
end

function vcrKeystoneDungeon:stopCondition()
  return ({GetInstanceInfo()})[2] == "none"
end

return vcrKeystoneDungeon