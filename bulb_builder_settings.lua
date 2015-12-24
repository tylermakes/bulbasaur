require("class")
require("bulb_color")
require("bulb_ai_strategy1")
require("bulb_ai_strategy2")
require("bulb_ai_strategy3")

BulbBuilderSettings = class(function(c)
	local types = {}
	types[1] = { id=1, tileName="player", color=BulbColor(1,0.8,0) }
	types[2] = { id=2, tileName="tree1", color=BulbColor(0,0.6,0) }
	types[3] = { id=3, tileName="tree2", color=BulbColor(0.6,1,0.6) }
	types[4] = { id=4, tileName="enemy1", isEnemy=true, color=BulbColor(0.8,0,0.6) }
	types[5] = { id=5, tileName="enemy2", isEnemy=true, color=BulbColor(1,1,0.6) }
	types[6] = { id=6, tileName="river", walkable=5, color=BulbColor(0,0,1) }
	types[7] = { id=7, tileName="seeds", color=BulbColor(1,0,0) }
	types[8] = { id=8, tileName="wall", color=BulbColor(0.3, 0.3, 0.3) }
	types[9] = { id=9, tileName="lava", walkable=10, color=BulbColor(1, 0.6, 0) }
	types[10] = { id=10, tileName="dirt", walkable=1, color=BulbColor(0.8,0.6,0) }
	types[11] = { id=11, tileName="enemy3", isEnemy=true, color=BulbColor(0.3,0.1,0.1) }
	c.types = types

	c.dirtType = types[10]
end)

function BulbBuilderSettings:getStrategyForEnemy(type)
	if (type == "enemy1") then
		return BulbAIStrategy1()
	elseif (type == "enemy2") then
		return BulbAIStrategy2()
	elseif (type == "enemy3") then
		return BulbAIStrategy3()
	end
end

function BulbBuilderSettings:getItemByName(tileName)
	for k, v in pairs(self.types) do
		if (v.tileName == tileName) then
			return v
		end
	end
end

function BulbBuilderSettings:getItemById(id)
	return self.types[id]
end