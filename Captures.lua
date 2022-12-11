vcrCaptures = {}

local function capture(func, params, results)
  if (not params) then
    params = {}
  elseif (type(params) ~= 'table') then
    params = {params}
  end
  
  if (not results) then
    results = {}
  elseif (type(results) ~= 'table') then
    results = {results}
  end
  
  return {func = func, params = params, results = results}
end

function vcrCaptures.getMapDetailsPlayer()
  local map = C_Map.GetBestMapForUnit("player")
  
  local UiMapDetails
  if (map ~= nil) then
    UiMapDetails = C_Map.GetMapInfo(map)
  end
  
  return capture("C_Map.GetBestMapForUnit", "player", map)
        ,capture("C_Map.GetMapInfo", map, {UiMapDetails})
        ,capture("EJ_GetInstanceForMap", UiMapDetails.mapID, {EJ_GetInstanceForMap(UiMapDetails.mapID)})
end

function vcrCaptures.getInstanceInfo()
  local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize, lfgDungeonID = GetInstanceInfo()
  
  return capture("GetInstanceInfo", nil, {GetInstanceInfo()}), capture("GetRealZoneText", instanceMapID, {GetRealZoneText(instanceMapID)})
end

function vcrCaptures.isInInstance()
  return capture("IsInInstance", nil, {IsInInstance()})
end

function vcrCaptures.isBattleground()
  return capture("C_PvP.IsBattleground", nil, {C_PvP.IsBattleground()})
end

function vcrCaptures.getUnitMaxXpPlayer()
  return capture("UnitXPMax", "player", {UnitXPMax("player")})
end

function vcrCaptures.getUnitXpPlayer()
  return capture("UnitXP", "player", {UnitXP("player")})
end

function vcrCaptures.getCombatLog()
  return capture("CombatLogGetCurrentEventInfo", nil, {CombatLogGetCurrentEventInfo()})
end

function vcrCaptures.getUnitLevelPlayer()
  return capture("UnitLevel", "player", {UnitLevel("player")})
end

function vcrCaptures.getRestedXp()
  return capture("GetXPExhaustion", nil, {GetXPExhaustion()})
end  

function vcrCaptures.getMaxLevelForExpansion()
  return capture("GetMaxLevelForLatestExpansion", nil, {GetMaxLevelForLatestExpansion()}), capture("GetMaxLevelForPlayerExpansion", nil, {GetMaxLevelForPlayerExpansion()})
end

function vcrCaptures.isXPUserDisabled()
  return capture("IsXPUserDisabled", nil, {IsXPUserDisabled()})
end

function vcrCaptures.getTimeToWellRested()
  return capture("GetTimeToWellRested", nil, {GetTimeToWellRested()})
end

function vcrCaptures.getGroupType()
  return capture("IsInGroup", nil, {IsInGroup()}), capture("IsInRaid", nil, {IsInRaid()})
end

function vcrCaptures.getPartyMembers()
  local num_party_members = GetNumGroupMembers()
  local num_group_members_capture = capture("GetNumGroupMembers", nil, {GetNumGroupMembers()})
  
  local group_captures = {}
  for i=1,num_party_members-1 do
    local unit_id = "party"..i
    table.insert(group_captures, capture("GetUnitName", {unit_id, true}, {GetUnitName(unit_id, true)}))
    table.insert(group_captures, capture("UnitGroupRolesAssigned", {unit_id}, {UnitGroupRolesAssigned(unit_id)}))
  end
  
  return num_group_members_capture, unpack(group_captures)
end

function vcrCaptures.getPartyStatus()
  local num_party_members = GetNumGroupMembers()
  local num_group_members_capture = capture("GetNumGroupMembers", nil, {GetNumGroupMembers()})
  
  local party_captures = {}
  for i=1,num_party_members-1 do
    local unit_id = "party"..i
    table.insert(party_captures, capture("UnitIsDeadOrGhost", unit_id, {UnitIsDeadOrGhost(unit_id)}))
  end
  
  return num_group_members_capture, capture("UnitIsDeadOrGhost", "player", {UnitIsDeadOrGhost("player")}), unpack(party_captures)
end

function vcrCaptures.getKeystoneInfo()
  local activeKeystoneLevel, activeAffixIds = C_ChallengeMode.GetActiveKeystoneInfo()
  
  local affix_captures = {}
  for i,id in pairs(activeAffixIds) do
    table.insert(affix_captures, capture("C_ChallengeMode.GetAffixInfo", id, {C_ChallengeMode.GetAffixInfo(id)}))
  end
  
  return capture("C_ChallengeMode.GetActiveKeystoneInfo", nil, {C_ChallengeMode.GetActiveKeystoneInfo()}), unpack(affix_captures)
end

function vcrCaptures.getKeystoneCompletionInfo()
  return capture("C_ChallengeMode.GetCompletionInfo", nil, {C_ChallengeMode.GetCompletionInfo()})
end

function vcrCaptures.getDeathCount()
  return capture("C_ChallengeMode.GetDeathCount", nil, {C_ChallengeMode.GetDeathCount()})
end

function vcrCaptures.getActiveChallengeMapId()
  return capture("C_ChallengeMode.GetActiveChallengeMapID", nil, {C_ChallengeMode.GetActiveChallengeMapID()})
end

function vcrCaptures.getPlayerInformation()
  return capture("UnitGUID", "player", {UnitGUID("player")}), capture("UnitFullName", "player", {UnitFullName("player")})
end

function vcrCaptures.time()
  return capture("time", nil, {time()}), capture("GetTime", nil, {GetTime()})
end

function vcrCaptures.addOnMetadataLC()
  return capture("GetAddOnMetadata", {"LevelingChronicle", "Version"}, {GetAddOnMetadata("LevelingChronicle", "Version")})
end

return vcrCaptures