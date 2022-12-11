require('Libs.LuaTesting.LuaTesting')

local ev = require('EventVcr')
local evf = require('Libs.WowEventFramework.WowEventFramework')

local replayer = require('Replayer')
local test_reel = require('Reels.BasicLevelingReel')

local lu = require('luaunit')

TestReplayer = {}

function TestReplayer:testReplayerRunsSuccessfully()
  local num_events = 0
  local cb = function(event,...) num_events = num_events + 1 end
  
  replayer.fastForward(test_reel)
  
  replayer.play(test_reel, cb)
  
  lu.assertEquals(num_events, 25)
  
  lu.assertEquals(UnitXP("player"),170)
  lu.assertEquals(select(5,CombatLogGetCurrentEventInfo()), "Airei")
end

lu.LuaUnit.verbosity = lu.VERBOSITY_VERBOSE
lu.LuaUnit.run('TestReplayer')