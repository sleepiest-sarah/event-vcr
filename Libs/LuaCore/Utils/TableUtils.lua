LCTableUtils = {}

local tableUtils = LCTableUtils

function tableUtils.printTable(t, depth)
  depth = depth or 0
  
  if (not t or depth > 5) then
    return
  end
  
  for k,v in pairs(t) do
    if (type(v) == "table") then
      print(string.format("%s:", tostring(k)))
      q:printTable(v, depth + 1)
    else
      print(string.format("%s: %s", tostring(k), tostring(v)))
    end
  end
end

function tableUtils.shallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--doesn't handle metadata
function tableUtils.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[q:deepcopy(orig_key)] = q:deepcopy(orig_value)
        end
        setmetatable(copy, q:shallowCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tableUtils.getTableKeys(t)
  local keys = {}
  
  for k,_ in pairs(t) do
    table.insert(keys, k)
  end
  
  return keys  
end


function tableUtils.getKeyForMaxValue(t,subkey)
  local max = -math.huge
  local max_key = nil
  
  for k,v in pairs(t) do
    if (subkey and v[subkey] > max) then
      max_key = k
      max = v[subkey]
    elseif (not subkey and v > max) then
      max_key = k
      max = v
    end
  end
  
  return max_key
end

function tableUtils.getKeyForMinValue(t,subkey)
  local min = math.huge
  local min_key = nil
  
  for k,v in pairs(t) do
    if (subkey and v[subkey] < min) then
      min_key = k
      min = v[subkey]
    elseif (not subkey and v < min) then
      min_key = k
      min = v
    end
  end
  
  return min_key
end

--Blizzard has tContains(table, value)
function tableUtils.contains(t,value)
  for _,v in ipairs(t) do
    if (v == value) then
      return true
    end
  end
  return false
end

--#table doesn't work for non-integer indexes
function tableUtils.length(t)
  local count = 0
  for _,_ in pairs(t) do
    count = count + 1
  end
  
  return count
end

function tableUtils.keyTable(t)
  local res = {}
  for i,v in pairs(t) do
    res[v] = v
  end
  
  return res
end

function tableUtils.addTables(a,b,shallow)
  --b expected to be the most up to date in the case of missing keys
  for k,v in pairs(b) do
    if (type(v) == "table" and not shallow) then
      if (a[k] == nil) then
        a[k] = {}
      end
      q:addTables(a[k], v)
    elseif (tonumber(v) ~= nil) then
      if (a[k] == nil) then
        a[k] = 0
      end
      a[k] = a[k] + tonumber(v)
    end
  end
  
  return a
end

function tableUtils.subtractTables(b,a)
  for k,v in pairs(b) do
    if (type(v) == "table") then
      if (a[k] == nil) then
        a[k] = {}
      end
      q:subtractTables(v,a[k])
    elseif (tonumber(v) ~= nil) then
      if (a[k] == nil) then
        a[k] = 0
      end
      a[k] = tonumber(v) - a[k]
    end
  end
  
  return a  
end

function tableUtils.addKeysLeft(a,b)
  a = a or {}
  for k,v in pairs(b) do
    if (not a[k]) then
      a[k] = type(v) == "table" and {} or v
    end
  end
  
  return a
end

return LCTableUtils