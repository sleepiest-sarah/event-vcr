local c = require('Captures') or vcrCaptures
local Net = require('Nets.Net') or vcrNet

vcrLevelChronicle = Net:new()

vcrLevelChronicle.name = "LevelChronicle"

vcrLevelChronicle.start = "PLAYER_LOGIN"
vcrLevelChronicle.stop = "PLAYER_LOGOUT"
vcrLevelChronicle.filter = {
  ["PLAYER_LOGIN"] = {c.getUnitMaxXpPlayer, c.getUnitXpPlayer, c.getUnitLevelPlayer, c.getRestedXp, c.getMaxLevelForExpansion, c.isXPUserDisabled, c.getPlayerInformation, c.time},
  ["CHAT_MSG_COMBAT_XP_GAIN"] = {c.time, c.isInInstance},
  ["PLAYER_LEVEL_UP"] = {c.time},
  ["PLAYER_XP_UPDATE"] = {c.getUnitMaxXpPlayer, c.getUnitXpPlayer, c.time, c.isInInstance, c.isBattleground, c.getRestedXp},
  ["SCENARIO_COMPLETED"] = {c.time},
  ["PET_BATTLE_CLOSE"] = {c.time},
  ["PET_BATTLE_OPENING_DONE"] = {c.time},
  ["PET_BATTLE_OVER"] = {c.time},
  ["CHAT_MSG_OPENING"] = {c.time},
  ["QUEST_TURNED_IN"] = {c.time},
  ["PLAYER_UPDATE_RESTING"] = {c.getTimeToWellRested},
  ["PLAYER_ENTERING_BATTLEGROUND"] = {c.time, c.isBattleground},
  ["PVP_MATCH_COMPLETE"] = {c.time, c.isBattleground},
  ["PLAYER_LOGOUT"] = {},
  ["PLAYER_ENTERING_WORLD"] = {c.getInstanceInfo, c.time, c.isInInstance},
  ["ADDON_LOADED"] = {c.addOnMetadataLC},
  ["MAP_EXPLORATION_UPDATED"] = {},
  ["CHAT_MSG_SYSTEM"] = {},
  ["WORLD_QUEST_COMPLETED_BY_SPELL"] = {}
}

function vcrLevelChronicle:eventCondition(event, ...)
  if (event == "CHAT_MSG_OPENING") then
    return string.match(..., "You perform")
  elseif (event == "ADDON_LOADED") then
    return "LevelingChronicle" == select(1,...)
  elseif (event == "PLAYER_XP_UPDATE") then
    return "player" == select(1,...)
  elseif (event == "CHAT_MSG_SYSTEM") then
    return string.match(..., "experience gained")
  end
  
  return true
end

return vcrLevelChronicle