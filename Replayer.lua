local string_utils = require('Libs.LuaCore.Utils.StringUtils') or LCStringUtils

local replayer = {}

local reel, callback

local function isEvent(f)
  return type(f[2]) == 'string'
end

local function isFunction(f)
  return type(f[2]) == 'table'
end

local function buildFuncParamKey(func, params)
  return func..table.concat(params)
end

local function mockFunctionCalls(index)
  if (#reel == index or isEvent(reel[index+1])) then
    return
  end
  
  local func_param_map = {}
  
  local frame = reel[index+1]
  local i = index+1
  while (i <= #reel and isFunction(frame)) do
    local timestamp, func_data = unpack(frame)
    
    func_param_map[buildFuncParamKey(func_data.func, func_data.params)] = func_data.results
    
    local mocked_func = function (...)
      return unpack(func_param_map[buildFuncParamKey(func_data.func, {...})])
    end
    
    if (string.find(func_data.func, '[.]')) then
      local table_name,func_name = string_utils.split(func_data.func, '.')
      local tab = _G[table_name] or {}
      tab[func_name] = mocked_func
      _G[table_name] = tab
    else
      _G[func_data.func] = mocked_func
    end
    
    i = i + 1
    frame = reel[i]
  end
end

local function play()
  
  for i,f in ipairs(reel) do
    if (isEvent(f)) then --event
      local timestamp, event, args = unpack(f)
      mockFunctionCalls(i)
      callback(event, unpack(args))
    end
  end
end

function replayer.fastForward(r)
  reel = r
  mockFunctionCalls(1)
end

function replayer.play(r, cb, realtime)
  reel = r
  callback = cb
  
  play()
end

return replayer