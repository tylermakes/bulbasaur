require("class")

BulbGameSettings = class(function(c)
	local types = {}
	types[1] = { tileName="test1", cost=1001 }
	types[2] = { tileName="test2", cost=1002 }
	types[3] = { tileName="test3", cost=1003 }
	types[4] = { tileName="test4", cost=1004 }
	types[5] = { tileName="test5", cost=1005 }
	types[6] = { tileName="test6", cost=1006 }
	types[7] = { tileName="test7", cost=1007 }
	types[8] = { tileName="test8", cost=1008 }
	types[9] = { tileName="test9", cost=1009 }
	types[10] = { tileName="test10", cost=10010 }
	c.types = types
end)

-- function BulbGameSettings:setupFromData()
-- end