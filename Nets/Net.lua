

vcrNet = {}
local Net = vcrNet
function Net:new()
  local o = {
      start = "",
      stop = "",
      name = "",
      filter = {}
    }
  
  setmetatable(o, self)
  self.__index = self
  return o
end

function Net:startCondition()
  return true
end

function Net:stopCondition()
  return true
end

function Net:eventCondition(event)
  return true
end

return Net