local c = require('Captures') or vcrCaptures
local Net = require('Nets.Net') or vcrNet

vcrLeveling = Net:new()

vcrLeveling.name = "Leveling"

vcrLeveling.start = "PLAYER_LOGIN"
vcrLeveling.stop = "PLAYER_LOGOUT"
vcrLeveling.filter = {
  ["PLAYER_LOGIN"] = {c.getUnitMaxXpPlayer, c.getUnitXpPlayer, c.getUnitLevelPlayer, c.getRestedXp, c.getMaxLevelForExpansion, c.isXPUserDisabled, c.getPlayerInformation},
  ["CHAT_MSG_COMBAT_XP_GAIN"] = {},
  ["PLAYER_LEVEL_UP"] = {},
  ["PLAYER_XP_UPDATE"] = {c.getUnitMaxXpPlayer, c.getUnitXpPlayer},
  ["SCENARIO_COMPLETED"] = {},
  ["PET_BATTLE_CLOSE"] = {},
  ["CHAT_MSG_OPENING"] = {},
  ["PLAYER_DEAD"] = {},
  ["COMBAT_LOG_EVENT_UNFILTERED"] = {c.getCombatLog},
  ["QUEST_TURNED_IN"] = {},
  ["PLAYER_LEVEL_CHANGED"] = {},
  ["PLAYER_UPDATE_RESTING"] = {c.getTimeToWellRested},
  ["DISABLE_XP_GAIN"] = {},
  ["ENABLE_XP_GAIN"] = {},
  ["PLAYER_LOGOUT"] = {}
}

function vcrLeveling:eventCondition(event, ...)
  if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
    local _, combatLogEvent = CombatLogGetCurrentEventInfo()
    return combatLogEvent == "PARTY_KILL"
  elseif (event == "CHAT_MSG_OPENING") then
    return string.match(..., "You perform")
  end
  
  return true
end

return vcrLeveling