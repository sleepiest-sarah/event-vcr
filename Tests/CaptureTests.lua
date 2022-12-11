require('Libs.LuaTesting.LuaTesting')

local c = require('Captures') or vcrCaptures
local table_utils = require('Libs.LuaCore.Utils.TableUtils')

local lu = require('luaunit')



TestCaptures = {}

function TestCaptures:testGetMapDetailsPlayer()
  local first_capture, second_capture = c.getMapDetailsPlayer()
  
  lu.assertIsTable(first_capture)
  lu.assertIsTable(second_capture)
  lu.assertEquals(table_utils.length(first_capture), 3)
  lu.assertEquals(table_utils.length(second_capture), 3)
  
  lu.assertEquals(first_capture.func, "C_Map.GetBestMapForUnit")
  lu.assertEquals(first_capture.params, {"player"})
  lu.assertIsTable(first_capture.results)
end

function TestCaptures:testUnpackCaptures()
  local captures = {c.getKeystoneInfo()}
  
  lu.assertEquals(#captures, 4)
end

lu.LuaUnit.verbosity = lu.VERBOSITY_VERBOSE
lu.LuaUnit.run('TestCaptures')