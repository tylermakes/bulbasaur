require("class")
require("bulb_color")

BulbBuilderSettings = class(function(c)
	local types = {}
	types[1] = { id=1, tileName="seeds", color=BulbColor(1,0,0) }
	types[2] = { id=2, tileName="tree1", color=BulbColor(0,0.6,0) }
	types[3] = { id=3, tileName="tree2", color=BulbColor(0.6,1,0.6) }
	types[4] = { id=4, tileName="enemy1", color=BulbColor(1,0.6,0) }
	types[5] = { id=5, tileName="enemy2", color=BulbColor(1,1,0.6) }
	types[6] = { id=6, tileName="river", color=BulbColor(0,0,1) }
	types[7] = { id=7, tileName="player", color=BulbColor(1,0.8,0) }
	c.types = types

end)

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