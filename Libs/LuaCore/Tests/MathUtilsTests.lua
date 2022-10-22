local mathUtils = require('Libs.LuaCore.Utils.MathUtils')

local lu = require('luaunit')

TestMathUtils = {}

function TestMathUtils:testGetShorthandNumber()
  local res = mathUtils.getShorthandNumber(500)
  
  lu.assertIsString(res)
  lu.assertEquals(res, "500")
  
  res = mathUtils.getShorthandNumber(1.23)
  
  lu.assertEquals(res, "1")
  
  res = mathUtils.getShorthandNumber(1300)
  
  lu.assertEquals(res, "1k")
  
  res = mathUtils.getShorthandNumber(1751)
  
  lu.assertEquals(res, "2k")
  
  res = mathUtils.getShorthandNumber(23123)
  
  lu.assertEquals(res, "23k")
  
  res = mathUtils.getShorthandNumber(5239029)
  
  lu.assertEquals(res, "5m")
end

function TestMathUtils:testGetShorthandNumberWithPrecision()
  local res = mathUtils.getShorthandNumber(500, 2)
  
  lu.assertIsString(res)
  lu.assertEquals(res, "500.00")
  
  res = mathUtils.getShorthandNumber(1300, 1)
  
  lu.assertEquals(res, "1.3k")
  
  res = mathUtils.getShorthandNumber(1751, 4)
  
  lu.assertEquals(res, "1.7510k")
  
  res = mathUtils.getShorthandNumber(23123, 0)
  
  lu.assertEquals(res, "23k")
  
  res = mathUtils.getShorthandNumber(5239029, 2)
  
  lu.assertEquals(res, "5.24m")
end

function TestMathUtils:testGetCommaFormattedNumberString()
  local res = mathUtils.getCommaFormattedNumberString(1500)
  
  lu.assertIsString(res)
  lu.assertEquals(res, "1,500")
  
  res = mathUtils.getCommaFormattedNumberString(52564250)
  
  lu.assertEquals(res, "52,564,250")
  
  res = mathUtils.getCommaFormattedNumberString(232)
  
  lu.assertEquals(res, "232")
  
  res = mathUtils.getCommaFormattedNumberString(1432.69)
  
  lu.assertEquals(res, "1,432.7")
end

lu.LuaUnit.run()