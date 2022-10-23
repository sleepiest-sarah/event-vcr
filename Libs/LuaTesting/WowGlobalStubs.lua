
function GetCoinTextureString(n)
  return tostring(n)
end

function CreateFrame(s)
  local f = {}
  
  f.events = {}
  f.IsEventRegistered = function (self, event)
    return self.events[event]
  end
  
  f.RegisterEvent = function (self, event)
    self.events[event] = event
  end
  
  return f
end

function hooksecurefunc(table, func, callback)
  
end