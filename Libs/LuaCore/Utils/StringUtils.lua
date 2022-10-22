LCStringUtils = {}

local stringUtils = LCStringUtils

function stringUtils.capitalizeString(str)
  local res
  
  if (str ~= nil and string.len(str) > 0) then
    local c = string.sub(str,0,1)
    c = string.upper(c)
    res = c..string.sub(str,2)
  end
  
  return res
end

function stringUtils.generateUUID()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
  end)
end

return stringUtils