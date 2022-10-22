local stringUtils = require('Libs.LuaCore.Utils.StringUtils')

local lu = require('luaunit')

TestStringUtils = {}

function TestStringUtils:testCapitalizeString()
  local result = stringUtils.capitalizeString("bear in a chair.")
  
  lu.assertIsString(result)
  lu.assertEquals(result, "Bear in a chair.")
  
  result = stringUtils.capitalizeString("BEAR")
  
  lu.assertEquals(result, "BEAR")
  
  result = stringUtils.capitalizeString("8ear")
  lu.assertIsString(result)
  lu.assertEquals(result, "8ear")
end

function TestStringUtils:testGenerateUUID()
  local uuid1 = stringUtils.generateUUID()
  local uuid2 = stringUtils.generateUUID()
  
  lu.assertNotEquals(uuid1, uuid2)
  lu.assertIsString(uuid1)
  lu.assertEquals(#uuid1, 36)
end

lu.LuaUnit.run()