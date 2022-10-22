local tableUtils = require('Libs.LuaCore.Utils.TableUtils')

local lu = require('luaunit')

TestTableUtils = {}

function TestTableUtils:testLength()
  local res = tableUtils.length({'a', 'b', 'c'})
  
  lu.assertEquals(res, 3)
  
  res = tableUtils.length({a = 'a', b = 'b', c = 'c'})
  
  lu.assertEquals(res, 3)
  
  res = tableUtils.length({})
  
  lu.assertEquals(res, 0)
end

function TestTableUtils:testAddTables()
  local res = tableUtils.addTables({a = 5, b = 10}, {a = 10, b = 20, c = 1})
  
  lu.assertEquals(res, {a = 15, b = 30, c = 1})
end
  
lu.LuaUnit.verbosity = lu.VERBOSITY_VERBOSE
lu.LuaUnit.run()